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
"""
Tests for the merge module.
"""
import unittest
import merge

class MergeTest(unittest.TestCase):
    def test_throw_error_on_undefined(self):
        values = {'conf': 'value'}

        self.assertEquals('value', merge.render("{{ conf }}", **values))

    def test_render_with_type_mapping(self):
        global type_mappings
        merge.type_mappings = {'type_mapping': {'blob': {'kudu': 'string'}}}
        values = {'conf': 'nevermind', 'column': {'datatype': 'blob'}}

        assert 'string' == merge.render("{{ map_datatypes(column, 'kudu') }}", **values)
