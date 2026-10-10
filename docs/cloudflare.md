# Cloudflare edge work for AI readiness

The site is static (Jekyll on GitHub Pages) behind Cloudflare, so these items can
only be done in the Cloudflare dashboard. Nothing here is deployed from the repo.
Verify each one at the edge with `curl`, not by reading configuration.

## 1. Stop rejecting AI crawlers (AIR-1.2)

The scan saw HTTP 403 for OAI-SearchBot, ChatGPT-User, GPTBot and ClaudeBot.

1. Security > Events: filter by those user agents and note which rule or
   product (Bot Fight Mode, Super Bot Fight Mode, "Block AI bots", a WAF
   custom rule, rate limiting) returns the block.
2. Allow them: turn off "Block AI bots" for this zone, or add a WAF custom
   rule with action Skip for `http.user_agent contains` each of OAI-SearchBot,
   ChatGPT-User, GPTBot, ClaudeBot, PerplexityBot (match your intended policy).
3. If Cloudflare's "Manage robots.txt" is on, it prepends its own block to our
   `robots.txt`. Turn it off, or confirm that the combined file still carries
   our `Content-Signal` line and does not contradict it.
4. Verify: every command below must print `200`.

```bash
for ua in OAI-SearchBot ChatGPT-User GPTBot ClaudeBot; do
  curl -s -o /dev/null -w "$ua %{http_code} %{size_download}\n" -A "$ua" https://handbook.ten7.com/ourbenefits.html
done
```

## 2. X-Robots-Tag on non-HTML files (AIR-4.4)

Rules > Transform Rules > Modify Response Header > Set static.

| Match | Header | Value |
| --- | --- | --- |
| `http.request.uri.path.extension in {"png" "ico" "svg" "webmanifest"}` (icons) | `X-Robots-Tag` | `noindex` |
| `http.request.uri.path.extension eq "pdf"` (benefit plan documents) | `X-Robots-Tag` | `noindex, nofollow` if they should stay out of search, otherwise `all`. Decide deliberately. |

Verify: `curl -sI https://handbook.ten7.com/favicon-32x32.png | grep -i x-robots`

## 3. Markdown negotiation and caching (AIR-7.3, 7.4)

Markdown companions already exist at `<page>.html.md` and `/index.md`.
Negotiation needs a Worker, because GitHub Pages cannot vary on `Accept`.

Caveat that decides the design: Cloudflare's cache ignores `Vary` except for
`Accept-Encoding` (and images). A Worker that returns Markdown for the same
URL as the HTML will poison the cache unless the cache key includes the
variant. Sketch (review and test before deploying):

```js
export default {
  async fetch(request) {
    const url = new URL(request.url);
    const wantsMd = (request.headers.get('Accept') || '').includes('text/markdown');
    const isPage = url.pathname === '/' || url.pathname.endsWith('.html');
    if (!isPage) return fetch(request);

    const target = new URL(request.url);
    if (wantsMd) {
      target.pathname = url.pathname === '/' ? '/index.md' : `${url.pathname}.md`;
    }
    const res = await fetch(target.toString(), {
      cf: { cacheKey: `${target}#${wantsMd ? 'md' : 'html'}` },
    });
    const out = new Response(res.body, res);
    out.headers.append('Vary', 'Accept');
    if (wantsMd) out.headers.set('Content-Type', 'text/markdown; charset=utf-8');
    return out;
  },
};
```

Verify at the edge, twice (second request should be a cache HIT) and for both variants:

```bash
curl -sI -H "Accept: text/markdown" https://handbook.ten7.com/ourbenefits.html | grep -iE "content-type|vary|cf-cache-status"
curl -sI https://handbook.ten7.com/ourbenefits.html | grep -iE "content-type|vary|cf-cache-status"
```

Then set Cache Rules: `/llms.txt` and `*.md` get an Edge TTL (for example 1 day).
Purge them on deploy by adding a `purge_cache` step to
`.github/workflows/pages.yml` with a zone-scoped API token stored as a secret.
