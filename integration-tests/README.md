# Integration tests
These tests are designed to be run on a Hadoop cluster to utilize Impala, HDFS, and Kudu.

## Dependencies
- mysql client
- Docker

## Overview

The tests will spin up a docker container, load data, then run the pipeline using the mysql Docker container as the datasource.

## Running the tests

In each integration test dir, copy the `env.yml.template into `env.yml` and fill it with
values for your environment (database, path, hostname for connection string)

Tests can be run by calling

```bash
./run-tests
```

in this directory.

