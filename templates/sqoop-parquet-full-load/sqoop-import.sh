#!/bin/bash
{#    Copyright 2017 Cargill Incorporated

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

      http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License. #}
# Create a Sqoop job
set -eu
sqoop import \
    -D 'mapred.job.name={{ conf.source_database.name }}.{{ table.source.name }}.{{ conf.sqoop_job_name_suffix }}' \
    --connect '{{ conf.source_database.connection_string }}' \
    --username '{{ conf.user_name }}' \
    --password-file '{{ conf.sqoop_password_file }}' \
{%- if conf["sqoop_driver"] is defined %}
    --driver {{ conf.sqoop_driver }} \
{%- endif %}
    {%- set map_java_column = sqoop_map_java_column(table.columns, clean_column=true) %}
    {%- if map_java_column %}
    {{ map_java_column }} \
    {%- endif %}
    --delete-target-dir \
    --target-dir {{ conf.raw_database.path }}/{{ table.destination.name }}_avro/ \
    --temporary-rootdir {{ conf.raw_database.path }}/{{ table.destination.name }}_avro/ \
    --as-avrodatafile \
    --fetch-size {% if table.columns|length < 30 -%} 10000 {% else %} 5000 {% endif %} \
    --compress  \
    --compression-codec snappy \
    {%- if table.num_mappers > 1 %}
    --split-by {{ table.split_by_column }} \
    --boundary-query 'SELECT min({{ table.split_by_column }}), max({{ table.split_by_column }}) FROM {{ conf.source_database.name }}.{{ table.source.name }}' \{%- endif %}
    -m {{ table.num_mappers or 1 }} \
    {% if conf["sqoop_driver"] is defined %}
      {%- if "sqlserver" in conf["sqoop_driver"].lower() -%}
      --query 'SELECT {% for column in table.columns%} "{{ column.name }}" AS "{{ cleanse_column(column.name) }}"{% if loop.last %} {% else %},{% endif %} {% endfor %} FROM {{ conf.source_database.name }}.{{ table.source.name }} WHERE $CONDITIONS'
      {%- else -%}
      --query 'SELECT {% for column in table.columns%} "{{ column.name }}" AS "{{ cleanse_column(column.name) }}"{% if loop.last %} {% else %},{% endif %} {% endfor %} FROM {{ conf.source_database.name }}.{{ table.source.name }} WHERE $CONDITIONS'
      {% endif -%}
    {%- else -%}
    --query 'SELECT {% for column in table.columns%} "{{ column.name }}" AS "{{ cleanse_column(column.name) }}"{% if loop.last %} {% else %},{% endif %} {% endfor %} FROM {{ conf.source_database.name }}.{{ table.source.name }} WHERE $CONDITIONS'
    {%- endif -%}

