#!/usr/bin/env bash

if $(hadoop fs -test -d {{ conf.raw_database.path }}/{{ table.destination.name }}); then
    hadoop fs -rm -r {{ conf.raw_database.path }}/{{ table.destination.name }}
else
    echo "Raw {{ table.destination.name }} directory doesn't exist"
fi

if $(hadoop fs -test -d {{ conf.staging_database.path }}/{{ table.destination.name }}); then
    hadoop fs -rm -r {{ conf.staging_database.path }}/{{ table.destination.name }}
else
    echo "Staging {{ table.destination.name }} directory doesn't exist"
fi