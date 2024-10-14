# Contributing

## Setup

Run `bin/setup`

## Running the tests

```bash
$ bin/test
```

```bash
$ bin/test_system
```

You can optionally pass the path to a specific test.

## Running the dummy app

```bash
$ bin/dev
```

Make sure you restart the server after making changes to the engine (including JS).

## Populating the dummy app with fixtures

Run `bin/load_fixtures`

## Releasing

Run `bin/release x.y.z`, use `--dry` to skip publishing. This is not idempotent. If releasing fails, take note of where the process left off and continue manually.
