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

        self.assertEqual('value', merge.render("{{ conf }}", **values))

    def test_render_with_type_mapping(self):
        global type_mappings
        merge.type_mappings = {'type_mapping': {'blob': {'kudu': 'string'}}}
        values = {'conf': 'nevermind', 'column': {'datatype': 'blob'}}

        assert 'string' == merge.render("{{ map_datatypes(column).kudu }}", **values)

class CleanseColumnTest(unittest.TestCase):
    def test_period_replace(self):
        column_name = "gluten_conc.overflow"
        actual = merge.cleanse_column(column_name)
        self.assertEqual("gluten_conc_overflow", actual)

    def test_dollar_replace(self):
        column_name = "gluten_conc$overflow"
        actual = merge.cleanse_column(column_name)
        self.assertEqual("gluten_conc_overflow", actual)

    def test_percent_replace(self):
        column_name = "gluten_conc%overflow"
        actual = merge.cleanse_column(column_name)
        self.assertEqual("gluten_conc_overflow", actual)

    def test_underscore_shortening_replace(self):
        column_name = "gluten_conc__overflow"
        actual = merge.cleanse_column(column_name)
        self.assertEqual("gluten_conc_overflow", actual)

    def test_remove_initial_lodash(self):
        column_name = "_gluten_conc_overflow"
        actual = merge.cleanse_column(column_name)
        self.assertEqual("gluten_conc_overflow", actual)

    def test_remove_initial_slash(self):
        column_name = "/gluten_conc_overflow"
        actual = merge.cleanse_column(column_name)
        self.assertEqual("gluten_conc_overflow", actual)

    def test_at_replace(self):
        column_name = "gluten_conc@overflow"
        actual = merge.cleanse_column(column_name)
        self.assertEqual("gluten_concaoverflow", actual)

    def test_pound_replace(self):
        column_name = "gluten_conc#overflow"
        actual = merge.cleanse_column(column_name)
        self.assertEqual("gluten_concpoverflow", actual)

    def test_paren_replace(self):
        column_name = "slope (rise/run)"
        actual = merge.cleanse_column(column_name)
        self.assertEqual("slope_rise_run_", actual)

    def test_space_replace(self):
        column_name = "hot dish"
        actual = merge.cleanse_column(column_name)
        self.assertEqual("hot_dish", actual)

    def test_dash_replace(self):
        column_name = "hot-dish"
        actual = merge.cleanse_column(column_name)
        self.assertEqual("hot_dish", actual)

    def test_pipe_replace(self):
        column_name = "hot|dish"
        actual = merge.cleanse_column(column_name)
        self.assertEqual("hot_dish", actual)

if __name__ == '__main__':
    unittest.main()