#!/usr/bin/env bash

#DAY=$(date +"%-d")
#val=$((DAY%4))

#val=$(head -c 1 partition.txt)
impala="{{ conf.impala_cmd }}"
val=$(${impala} get-partition.sql | awk -F'=' ' { print substr ($(NF-0),0,1) } ' | grep -o '[1-4]*')

if [[ $val -eq 4 ]]
then
        val=1
else
        val=$((val+1))
fi


${impala} insert_overwrite.sql --var=val=$val
${impala} alter-location.sql --var=val=$val