# Contributing

## Submitting issues
Use the github [issue tracker](https://github.com/Cargill/pipewrench/issues) to submit bugs or ask questions.

## Submitting features and fixes
To contribute features or bug fixes, create a [fork](https://help.github.com/articles/fork-a-repo/) then a
[pull request](https://help.github.com/articles/creating-a-pull-request/) back to this repository.

- Please provide a detailed commit message
- When contributing new pipelines, be sure to add an example configuration in the `examples` directory.
- Tests for templates are optional and can help speed template development.
- Full tests for pipelines using Docker are encouraged.

## Running tests

All tests should be passing when running `make test` from the root directory.

Before making a pull request `make build` should exit successfully

`make build` depends on docker and docker-compose. See the [integration test documentation](./integration-tests/README.md)
for details.
