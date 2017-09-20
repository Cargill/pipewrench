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
set -euo pipefail
sqoop job -D 'sqoop.metastore.client.record.password=true' \
    --create {{ conf.source_database.name }}.{{ table.source.name }}.{{ conf.sqoop_job_name_suffix }} \
    -- import \
    --connect {{ conf.source_database.connection_string }} \
    --username {{ conf.user_name }} \
    --password-file {{ conf.sqoop_password_file }} \
    --target-dir {{ conf.staging_database.path }}/{{ table.destination.name }}/incr \
    --incremental append \
    --temporary-rootdir {{ conf.staging_database.path }}/{{ table.destination.name }} \
    --append \
    --split-by {{ table.split_by_column }} \
    --check-column {{ table.check_column }} \
    --as-parquetfile \
    --direct \
    --fetch-size 10000 \
    --compress  \
    --compression-codec snappy \
    -m 1 \
    --query 'SELECT TOP 1000 {{ table.columns|map(attribute='name')|join(',\n        ')}}
        FROM {{ conf.source_database.name }}.{{ table.source.name }} WHERE $CONDITIONS'

