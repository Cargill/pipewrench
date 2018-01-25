#!/usr/bin/env bash

if $(hadoop fs -test -d {{ conf.staging_database.path }}/); then
    hadoop fs -rm -r {{ conf.staging_database.path }}/
else
    echo "Staging {{ table.destination.name }} directory doesn't exist"
fi

if $(hadoop fs -test -d {{ conf.result_database.path }}/); then
    hadoop fs -rm -r {{ conf.result_database.path }}/
else
    echo "Parquet {{ table.destination.name }} directory doesn't exist"
fi
