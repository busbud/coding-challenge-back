# Busbud Coding Challenge

## Getting Started

Begin by forking this repo and cloning your fork. GitHub has apps for [Mac](http://mac.github.com/) and [Windows](http://windows.github.com/) that make this easier.

### Setting up a Ruby environment

Get started by installing [`rbenv`](https://github.com/sstephenson/rbenv#basic-github-checkout) and [`ruby-build`](https://github.com/sstephenson/ruby-build#installing-as-an-rbenv-plugin-recommended).

For OS X users, this will require the Xcode Command Line tools and a few [Homebrew](http://github.com/mxcl/homebrew) packages. Details [here](https://github.com/sstephenson/ruby-build/wiki#suggested-build-environment).

Once that's done run

```
rbenv install 2.0.0-p247
```

followed by

```
rbenv shell 2.0.0-p247
```

### Setting up the project

In the project directory run

```
gem install bundler
```

followed by

```
bundle install
```

(You may need to run `rbenv rehash` if the `bundle` command is unavailable).

### Running the tests

The test suite can be run with

```
bundle exec rspec
```

### Starting the application

To start a local server run

```
bundle exec thin start
```

which should produce output similar to

```
Using rack adapter
Thin web server (v1.6.1 codename Death Proof)
Maximum connections set to 1024
Listening on 0.0.0.0:3000, CTRL+C to stop
```

## Requirements

Write a simple API endpoint that runs a query string against the [Google Geocoding API](https://developers.google.com/maps/documentation/geocoding/) to return a list of suggested cities.

- Requests must be authenticated against username and hashed password combinations stored in a Redis database using http basic auth.
- All functional tests should pass (additional tests may be implemented as necessary).
- The final application should be [deployed to Heroku](https://devcenter.heroku.com/articles/rack).

### Non-functional

- All code should be written in Ruby
- Work should be submitted as a pull-request to this repo
- Documentation and maintainability is a plus
