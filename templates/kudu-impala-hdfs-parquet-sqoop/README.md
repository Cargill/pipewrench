# Kudu to Sqoop Pipeline
This pipeline will sqoop data from Kudu table into Sqoop export job

## Artifacts Created
- Impala Parquet table
- Impala Kudu table
- Sqoop job
- Text/Parquet file

## Running the pipeline

`make first-run` :
- create SQL/Intermediate tables
- create a Sqoop job
- execute the Sqoop Export job, inserting data into Text/Parquet(Text until this https://reviews.apache.org/r/61522/ issue resolve)

`make update` :
- execute the Sqoop Export job

`make clean` :
- Clean up _all_ data on HDFS and Impala DDL. This is non reversible.


Dependency for graphs for all targets can be found [here](../../docs/pipelines/sqoop-parquet-hdfs-impala/png)


