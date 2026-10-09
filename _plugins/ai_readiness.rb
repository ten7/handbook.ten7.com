# frozen_string_literal: true

# Two things for crawlers and AI agents, both derived from the page's own source:
#
# 1. date_published / date_modified from the git history of the source file, so
#    they only move when that page's content moves, never on a deploy.
#    (Needs the full history: the deploy workflow checks out with fetch-depth 0.)
# 2. A Markdown companion for every page at "<url>.md", written from the same
#    source as the HTML with no navigation or other chrome.

require 'open3'
require 'time'

module AiReadiness
  def self.git_time(site, path, first:)
    args = ['git', '-C', site.source, 'log', '--follow', '--format=%cI', '--', path]
    out, status = Open3.capture2e(*args)
    return nil unless status.success?

    times = out.lines.map(&:strip).reject(&:empty?)
    times.empty? ? nil : (first ? times.last : times.first)
  rescue StandardError
    nil
  end

  def self.content_items(site)
    docs = site.collections['pages'] ? site.collections['pages'].docs : []
    index = site.pages.select { |p| p.url == '/' }
    docs + index
  end

  def self.companion_path(url)
    url == '/' ? 'index.md' : "#{url.sub(%r{\A/}, '')}.md"
  end
end

Jekyll::Hooks.register :site, :pre_render do |site|
  AiReadiness.content_items(site).each do |item|
    path = item.respond_to?(:relative_path) ? item.relative_path : item.path
    item.data['date_published'] = AiReadiness.git_time(site, path, first: true)
    item.data['date_modified'] = AiReadiness.git_time(site, path, first: false)
    item.data['markdown_source'] = item.content.dup
  end
end

Jekyll::Hooks.register :site, :post_write do |site|
  AiReadiness.content_items(site).each do |item|
    out = File.join(site.dest, AiReadiness.companion_path(item.url))
    title = item.data['title'].to_s.strip
    File.write(out, "# #{title}\n\n#{item.data['markdown_source'].to_s.strip}\n")
  end
end
