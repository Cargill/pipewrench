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

sqoop {{ conf.sqoop_ops }} \
import \
    --connect {{ conf.source_database.connection_string }} \
    --username {{ conf.user_name }} \
    --password-file {{ conf.sqoop_password_file }} \
    --driver  {{ conf.sqoop_driver }} \
    --delete-target-dir \
    --target-dir {{ conf.staging_database.path }}/{{ table.destination.name }}/ \
    --temporary-rootdir {{ conf.staging_database.path }}/{{ table.destination.name }}/ \
    --as-avrodatafile \
    --fetch-size 10000 \
    --compress  \
    --compression-codec snappy \
    -m 1 \
    --query 'SELECT {% for column in table.columns%} {% if loop.last %} {{ '"{}"'.format(column.name) }} {% else %} {{ '"{}",\t\n'.format(column.name) }} {% endif %} {% endfor %}
        FROM {{ conf.source_database.name }}.{{ table.source.name }} WHERE $CONDITIONS'

