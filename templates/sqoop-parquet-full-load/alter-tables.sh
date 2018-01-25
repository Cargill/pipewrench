#!/usr/bin/env bash
now=$(date)
DAY=$(date -d "$now" '+%d')
val=$((DAY%4))
impala="{{ conf.impala_cmd }}"

${impala%?}q "INVALIDATE METADATA {{ conf.staging_database.name }}.{{ table.destination.name }}_avro;"
${impala%?}q "INSERT OVERWRITE TABLE {{ conf.result_database.name }}.{{ table.destination.name }}_parquet PARTITION (mod_val=$val)
SELECT {% for column in table.columns %}
{%- if column["datatype"] == "decimal" %}
cast ({{ column.name }} as decimal({{column.precision}}, {{column.scale}}) )
{%- else %} {{ column.name }}
{% endif %}
{%- if not loop.last -%}, {% endif %}
{%- endfor %}
 FROM {{ conf.staging_database.name }}.{{ table.destination.name }}_avro;"
${impala%?}q "ALTER TABLE {{ conf.final_database.name }}.{{ table.destination.name }} SET LOCATION '{{ conf.result_database.path }}/{{ table.destination.name }}/mod_val=$val/';"