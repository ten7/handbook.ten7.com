# TEN7 Employee Handbook

Hello, we're [TEN7](https://ten7.com/) and this is our official
[employee handbook](https://handbook.ten7.com/). If you're a new team member,
grab a cup of your favorite beverage and [read it](https://handbook.ten7.com/).

## License

This handbook is open source and licensed under the
[GNU General Public License v3.0](LICENSE). You are welcome to
[fork the repo](https://github.com/ten7/handbook.ten7.com) and use this for your
own organization.

To get running, clone the repo, then:

- `npm install`
- `npm run dev`

## To run on an Mac with an arm64 processor (M1)

If you are trying to run this from a MAC M1 (arm64 processor), you may have to
go through these steps at your root:

1. make sure you have Homebrew
2. run `ruby --verions` if nothing some up run `brew install ruby@3.0`
3. once ruby is installed, run `gem install --user-install bundler jekyll`
4. if you get an error about evventmachine (1.2.7), run
   `gem install eventmachine -v '1.2.7' --source 'https://rubygems.org/'` at
   your root and a second time at the project root, and then `bundle install`
5. Final step: `npm install`

Resource: https://www.youtube.com/watch?v=UKB9ylw0G4U

### Result

You should be able to see the site at: backend: http://localhost:3001 frontend:
http://localhost:4000
