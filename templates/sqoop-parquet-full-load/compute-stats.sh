#!/usr/bin/env bash
now=$(date)
DAY=$(date -d "$now" '+%d')
val=$((DAY%4))
impala="{{ conf.impala_cmd }}"

${impala} compute-stats_avro.sql --var=val=$val
${impala} compute-stats_result.sql --var=val=$val
${impala} compute-stats_final.sql --var=val=$val