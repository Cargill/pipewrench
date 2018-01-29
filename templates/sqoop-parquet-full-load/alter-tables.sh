#!/usr/bin/env bash
now=$(date)
DAY=$(date -d "$now" '+%d')
val=$((DAY%4))
impala="{{ conf.impala_cmd }}"

${impala} insert_overwrite.sql --var=val=$val
${impala} alter-location.sql --var=val=$val