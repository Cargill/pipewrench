# Integration tests
These tests are designed to be run on a Hadoop cluster to utilize Impala, HDFS, and Kudu.

## Dependencies
- mysql client
- Docker

## Overview

The tests will spin up a docker container, load data, then run the pipeline using the mysql Docker container as the datasource.

## Running the tests

Tests can be run by calling

```bash
./run-tests
```

in this directory.

