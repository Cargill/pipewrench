#!/usr/bin/env bash
impala="{{ conf.impala_cmd }}"

${impala} compute-stats_avro.sql
${impala} compute-stats_final.sql
