#!/usr/bin/env bash

pipewrench-merge --conf=tables.yml --debug_level INFO --env=env.yml --pipeline-templates=../../templates/sqoop-parquet-full-load
