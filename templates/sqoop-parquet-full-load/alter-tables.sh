#!/usr/bin/env bash

set -x

IMPALA_CMD="{{ conf.impala_cmd }}"
PARTITION_FILE="{{ conf.raw_database.path }}/{{ table.destination.name }}_partitioned/latest-partition"
PARTITION_NUMBER=1

if $(hdfs dfs -test -e $PARTITION_FILE); then
	PARTITION_NUMBER=$(hdfs dfs -cat $PARTITION_FILE)

	if [[ $PARTITION_NUMBER -eq 4 ]]; then
		PARTITION_NUMBER=1
	else
		PARTITION_NUMBER=$((PARTITION_NUMBER+1))
	fi
fi

${IMPALA_CMD} insert-overwrite.sql --var=val=$PARTITION_NUMBER

if [ $? -eq 0 ]; then
	${IMPALA_CMD} alter-location.sql --var=val=$PARTITION_NUMBER
	
	if $(hdfs dfs -test -e $PARTITION_FILE); then
		hdfs dfs -rm -skipTrash $PARTITION_FILE
	fi
	
	echo $PARTITION_NUMBER | hdfs dfs -put - $PARTITION_FILE
fi