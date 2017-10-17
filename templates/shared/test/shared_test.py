#    Copyright 2017 Cargill Incorporated
#
#    Licensed under the Apache License, Version 2.0 (the "License");
#    you may not use this file except in compliance with the License.
#    You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
#    Unless required by applicable law or agreed to in writing, software
#    distributed under the License is distributed on an "AS IS" BASIS,
#    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#    See the License for the specific language governing permissions and
#    limitations under the License.

from pipewrench import test_util
import json

def test_sqoop_create_sh():
    conf_string = '''---
    source_database:
      name: sourcedb
    sqoop_job_name_suffix: unittest
    staging_database:
      name: test_db
      path: /data/
    source_database.connection_string: jdbc://mydb
    user_name: myuser
    sqoop_password_file: mypasswordfile
    tables:
      - destination:
          name: destination
        source:
          name: source_table
        split_by_column: col1
        check_column: col1
        columns:
          - name: col1
            datatype: string
            comment: column one comment
          - name: col2
            datatype: int
            comment: column two comment'''

    expected = test_util.read_file('sqoop-create.sh')
    actual = test_util.merge_single(conf_string, None, '../sqoop-create.sh')

    assert actual == expected

def test_avro_avsc_with_decimal():
    type_mappings = {'decimal': {'avro': 'decimal'},
                     'string': { 'avro': 'string'}}

    conf_string = '''---
    source_database:
      name: sourcedb
    sqoop_job_name_suffix: unittest
    staging_database:
      name: test_db
      path: /data/
    source_database.connection_string: jdbc://mydb
    user_name: myuser
    sqoop_password_file: mypasswordfile
    tables:
      - id: mytable
        destination:
          name: destination
        source:
          name: source_table
        split_by_column: col1
        check_column: col1
        columns:
          - name: col1
            datatype: string
            comment: column one comment
          - name: col2
            datatype: decimal
            precision: 4
            scale: 2
            comment: column two comment'''

    expected = test_util.read_file('avro.avsc')

    actual = test_util.merge_single(conf_string, type_mappings, '../avro.avsc')

    actual_json = json.dumps(json.loads(actual), sort_keys=True)
    expected_json = json.dumps(json.loads(expected), sort_keys=True)

    assert actual_json== expected_json

def test_kudu_table_create_sql():
    type_mappings = {'int': {'kudu': 'decimal'},
                     'string': { 'kudu': 'string'}}
    conf_string = '''---
    source_database:
      name: sourcedb
    sqoop_job_name_suffix: unittest
    staging_database:
      name: test_db
      path: /data/
    source_database.connection_string: jdbc://mydb
    user_name: myuser
    sqoop_password_file: mypasswordfile
    tables:
      - destination:
          name: destination
        source:
          name: source_table
        split_by_column: col1
        check_column: col1
        kudu:
          hash_by:
            - col1
          num_partitions: 10
        columns:
          - name: col1
            datatype: string
            comment: column one comment
          - name: col2
            datatype: int
            comment: column two comment'''

    expected = test_util.read_file('kudu-table-create.sql')
    actual = test_util.merge_single(conf_string, type_mappings, '../kudu-table-create.sql')

    assert actual == expected
