#!/usr/bin/env bash
python clean_tables.py --conf=tables.yml --env=env.yml
pipewrench-merge --conf=data.yml --debug_level INFO --env=env.yml --pipeline-templates=../../templates/sqoop-parquet-full-load
cd /home/cloudera/Desktop/pipewrench/examples/sqoop-parquet-full-load/output/sqoop-parquet-full-load/first_imported_table
make first-run
