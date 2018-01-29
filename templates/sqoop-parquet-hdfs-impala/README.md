# Sqoop to Kudu Pipeline
This pipeline will sqoop data into a Parquet

## Artifacts Created
- Impala Parquet table
- Impala Kudu table
- Sqoop job
- Parquet file

## Running the pipeline

`make first-run` :
- create Impala tables
- create a Sqoop job
- execute the Sqoop job, inserting data into Parquet

`make update` :
- execute the Sqoop job

`make clean` :
- Clean up _all_ data on HDFS and Impala DDL. This is non reversible.


Dependency for graphs for all targets can be found [here](../../docs/pipelines/sqoop-parquet-hdfs-impala/png)


