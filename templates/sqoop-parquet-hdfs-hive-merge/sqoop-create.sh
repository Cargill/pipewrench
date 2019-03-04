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
sqoop job -D 'sqoop.metastore.client.record.password=true' \
    -D 'mapred.job.name={{ conf.source_database.name }}.{{ table.source.name }}.{{ conf.sqoop_job_name_suffix }}' \
    --create {{ conf.source_database.name }}.{{ table.source.name }}.{{ conf.sqoop_job_name_suffix }} \
    -- import \
    --connect {{ conf.source_database.connection_string }} \
    --username {{ conf.user_name }} \
    --password-file {{ conf.sqoop_password_file }} \
    --target-dir {{ conf.staging_database.path }}/{{ table.destination.name }}/incr \
    --incremental append \
    --temporary-rootdir {{ conf.staging_database.path }}/{{ table.destination.name }} \
    --append \
    {{ map_clobs_macro(table.columns) }} \
    --split-by {{ table.split_by_column }} \
    --check-column {{ table.check_column }} \
    --as-parquetfile \
    --fetch-size 1000 \
    --compress  \
    --compression-codec snappy \
    -m {{ table.num_mappers or 1 }} \
    --query 'SELECT {{ table.columns|map(attribute='name')|join(',\n\t')}}
        FROM {{ conf.source_database.name }}.{{ table.source.name }} WHERE $CONDITIONS'

