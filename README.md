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

To get running, clone the repo, then:

- `npm install`
- `npm run dev`


If you are trying to run this from a MAC M1 (arm64 processor), you might be run
into some issues. Here are a few things to try to resolve things we've seen before:

1. Make sure you have Homebrew
2. Run `ruby --version` and if nothing comes up, then run `brew install ruby@3.0`
3. Once ruby is installed, run `gem install --user-install bundler jekyll`
4. If you get an error about eventmachine (1.2.7), run
   `gem install eventmachine -v '1.2.7' --source 'https://rubygems.org/'` at
   your **root** and a second time at the **project root**,
5. `bundle config set --local path 'vendor/bundle'`
6. `bundle install`
7. `bundle exec jekyll s` (to get your Jekyll site up locally, and in file watch
   mode)
8. `npm install`
9. Get the Jekyll site up locally: `npm run dev`

Sould you run into issues restarting the Jekyll server, you might have to re-run
steps 4-9. Here's a video resource that might help: https://www.youtube.com/watch?v=UKB9ylw0G4U

You should be able to see the site at: 
* http://localhost:3001 for the backend
* http://localhost:4000 for the frontend
