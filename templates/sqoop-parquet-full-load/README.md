# Sqoop to IMPALA Pipeline
This pipeline will sqoop data into a Avro (staging) table insert data to Parquet table with partitions and creates destination table pointing the location to fresh copy of data inserted

## Artifacts Created
- Impala Avro table
- Impala Parquet table with partitions
- Impala Parquet (Destination) table 
- Sqoop import job

## Running the pipeline

`make first-run` :
- create and execute Sqoop import job
- create Impala avro tables
- create Impala parquet table
- create Destination table
- Insert data into Parquet from Avro table by casting column datatypes

`make update` :
- execute the Sqoop job
- updates data in Avro table
- Insert data into new partition of Parquet from Avro table by casting column datatypes
- Alter destination table location to the new partition

`make clean` :
- Clean up _all_ data on HDFS and Impala DDL. This is non reversible.
