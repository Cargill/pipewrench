#!/usr/bin/env bash
impala="{{ conf.impala_cmd }}"

${impala} compute-stats-report.sql
