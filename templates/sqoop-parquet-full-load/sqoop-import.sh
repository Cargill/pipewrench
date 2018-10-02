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
{# This function will put the --map-column-java col=String parameter for any clob data types.#}
 {% macro map_clobs_macro(columns) -%}
   {{ map_clobs(columns) }}
 {%- endmacro -%}
# Create a Sqoop job
set -eu
{% set mapcolumn = [] %}
{%- for column in table.columns -%}
{%- if column["datatype"].lower() == "varbinary" or column["datatype"].lower() == "binary"  or column["datatype"].lower() == "longvarbinary"  -%}
{%- set mapcolumn = mapcolumn.append(column["name"]) -%}
{%- endif -%}
{%- endfor -%}
sqoop import \
    --connect '{{ conf.source_database.connection_string }}' \
    --username '{{ conf.user_name }}' \
    --password-file '{{ conf.sqoop_password_file }}' \
{%- if conf["sqoop_driver"] is defined %}
    --driver {{ conf.sqoop_driver }} \
{%- endif %}
    {% if mapcolumn|length > 0 -%}
    --map-column-java {% for column in mapcolumn -%}
    {% if loop.last -%}
     {{ '"{}"'.format(column) }}=String \
    {%- else -%}
     {{ '"{}"'.format(column) }}=String,
    {%- endif -%}
    {% endfor %}
    {% endif -%}
    --delete-target-dir \
    --target-dir {{ conf.raw_database.path }}/{{ table.destination.name }}_avro/ \
    --temporary-rootdir {{ conf.raw_database.path }}/{{ table.destination.name }}_avro/ \
    --as-avrodatafile \
    --fetch-size {% if table.columns|length < 30 -%} 10000 {% else %} 5000 {% endif %} \
    --compress  \
    --compression-codec snappy \
    -m {{ table.num_mappers or 1 }} \
{%- if conf["sqoop_driver"] is defined %}
    {%- if "sqlserver" in conf["sqoop_driver"].lower() -%}
    --query 'SELECT {% for column in table.columns%} {% if loop.last %} {{ '"{}"'.format(column.name) }} {% else %} {{ '"{}",'.format(column.name) }} {% endif %} {% endfor %} FROM {{ table.source.name }} WHERE $CONDITIONS'
    {%- elif "sap" in conf["sqoop_driver"].lower() -%}
    --query 'SELECT {% for column in table.columns%} {% if loop.last %} {{ '"{}"'.format(column.name) }} {% else %} {{ '"{}",'.format(column.name) }} {% endif %} {% endfor %} FROM {{ conf.source_database.name }}.{{ table.source.name }} WHERE $CONDITIONS'
    {%- else -%}
    --query 'SELECT {% for column in table.columns%} {% if loop.last %} {{ column.name }} {% else %} {{ column.name }}, {% endif %} {% endfor %} FROM {{ conf.source_database.name }}.{{ table.source.name }} WHERE $CONDITIONS'
    {% endif -%}
{%- else %}
    --query 'SELECT {% for column in table.columns%} {% if loop.last %} {{ column.name }} {% else %} {{ column.name }}, {% endif %} {% endfor %} FROM {{ conf.source_database.name }}.{{ table.source.name }} WHERE $CONDITIONS'
{%- endif -%}
