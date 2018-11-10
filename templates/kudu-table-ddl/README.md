# Kudu Table DDL

This template will produce Kudu create table ddl statements.

## Artifacts Created
- Kudu table
- Compute Stats script

## Running the Pipeline

`make tables`:
- Creates Kudu tables if they dont exist using impala-shell commands

`make compute-stats`:
- Computes stats on Kudu tables

`make tables-clean`:
- Drops existing Kudu tables

