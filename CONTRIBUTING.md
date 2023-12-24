# Contributing

## Setup

```bash
$ bin/setup
```

## Running the tests

```bash
$ bundle exec rake app:test
```

```bash
$ bundle exec rake app:test:system
```

## Running the dummy app

```bash
$ bin/rails s
```

Make sure you restart the server after making changes to JS.

## Populating the dummy app with fixtures

```bash
$ FIXTURES_PATH="../fixtures" RAILS_ENV=development test/dummy/bin/rails db:fixtures:load --trace
```

## Releasing

1. Bump the version in `lib/hotwire_combobox/version.rb` (e.g. `VERSION = "0.1.0"`)
2. Bump the version in `Gemfile.lock` (e.g. `hotwire_combobox (0.1.0)`)
3. Commit the change (e.g. `git commit -am "Bump to 0.1.0"`)
4. Run `bundle exec rake release`
