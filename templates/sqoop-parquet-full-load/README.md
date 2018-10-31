# Sqoop Parquet Full load
This pipeline will sqoop data into a Avro (staging) table insert data to Parquet table with partitions and creates destination table pointing the location to fresh copy of data inserted

## Artifacts Created
- Avro table
- Parquet table with partitions
- Parquet (Destination) table 
- Sqoop import job

## Pipeline Flow

![Pipeline flow](../../docs/images/sqoop-parquet-full-load.png)

## Running the pipeline

`make first-run` :
- Get the source table rowcount and save the count in a text file(sourceCount.txt)
- Delete the avro schema if exists
- Sqoop import into avro data format
- Copy avro schema to the correct location
- Create avro table if not exists, on top of sqooped data
- Create a parquet table if not exists, partitioned by ingest_partition(int)
- Invalidate metadata on avro table
- Create report(final) table if not exists, stored as parquet
- alter-tables
  - Check if partition file named 'latest_partition' exists in HDFS
  - If not, script sets the value of PARTITION_NUMBER to 1
  - Insert overwrite data from avro table into partitioned parquet table where ingest_partition=1
  - Alter location of report(final) table to latest partition file(ingest_partition=1)
  - Remove the partition file named 'latest_partition' if exists
  - Create a partition file named 'latest_partition' with integer 1 in it
- Compute stats on report(final) table
- Compare and display row count from source table, avro table, and report table

`make update` :
- Get the source table rowcount and save the count in a text file(sourceCount.txt)
- Delete the avro schema if exists
- Sqoop import into avro data format
- Copy avro schema to the correct location
- Create a parquet table if not exists, partitioned by ingest_partition(int)
- Invalidate metadata on avro table
- Create report(final) table if not exists, stored as parquet
- alter-tables
  - Check if partition file named 'latest_partition' exists in HDFS
  - Get the number from the partition file named 'latest_partition'(This file was generated after first-run and has number 1 in it)
  - variable 'PARTITION_NUMBER' gets incremented by 1 after every run(rolls back to 1 after 4)
  - Insert overwrite data from avro table into partitioned parquet table where ingest_partition=PARTITION_NUMBER
  - Alter location of report(final) table to latest partition file(ingest_partition=PARTITION_NUMBER)
  - Remove the partition file named 'latest_partition' if exists
  - Create a partition file named 'latest_partition' with PARTITION_NUMBER in it
- Compute stats on report(final) table
- Compare and display row count from source table, avro table, and report table

`make clean` :
- Clean data for avro, partitioned and report tables
- Drop avro, partitioned and report tables if exists

`make integration-test` :
- make clean
- make first-run
- make update
- Compare and display row count from source table, avro table, and report table
