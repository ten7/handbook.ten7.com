# TEN7 Employee Handbook

Hello, we're [TEN7](https://ten7.com/) and this is our official
[employee handbook](https://handbook.ten7.com/). If you're a new team member,
grab a cup of your favorite beverage and [read it](https://handbook.ten7.com/).

## License

This handbook is open source and licensed under the
[GNU General Public License v3.0](LICENSE). You are welcome to
[fork the repo](https://github.com/ten7/handbook.ten7.com) and use this for your
own organization.

## Installing locally

You need:

- **Ruby 3.3.6** (see `.ruby-version`; use rbenv, asdf, mise or similar so the
  right version is picked up automatically)
- **Node.js** 12 or newer (we've tested with Node 22) and npm
- Bundler (`gem install bundler`)

Then clone the repo and run:

- `npm install` (this also runs `bundle install` for the Jekyll gems, via the
  `preinstall` script)
- `npm run dev`

`npm run dev` builds the images, CSS and JS, builds the Jekyll site, and
watches all of it for changes. When it's up you can see the site at:

* http://localhost:4000 for the handbook (served by Browsersync, reloads on change)
* http://localhost:3001 for the Browsersync control panel

Don't run `bundle exec jekyll serve` alongside `npm run dev`: both want port
4000.

`npm run build` does a one-off build into `_site`.

### Troubleshooting

If `npm install` fails during `bundle install`, run `ruby --version`. It should
say 3.3.6. If it doesn't, install it (for example `brew install rbenv ruby-build`,
then `rbenv install 3.3.6`) and run `npm install` again.

On an Apple Silicon Mac, if you get an error about eventmachine (1.2.7), run
`gem install eventmachine -v '1.2.7' --source 'https://rubygems.org/'` and then
`npm install` again.

If you can't get `npm run dev` running, you can start the pieces by hand:

1. `bundle config set --local path 'vendor/bundle'`
2. `bundle install`
3. `npm install`
4. `npm run dev`

Here's a video resource that might help: https://www.youtube.com/watch?v=UKB9ylw0G4U

## Deploying

The site is built and deployed by GitHub Actions
(`.github/workflows/pages.yml`) on every push to `main`. In the repository
settings, Pages must use "GitHub Actions" as its source. The build reads the git
history to set each page's last-modified date, so it needs a full checkout.
