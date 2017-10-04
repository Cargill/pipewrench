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
Utilities for unit testing individual templates
(like templates/sqoop-parquet-hdfs-impala/test/kudu-table-insert.sql)
"""
import yaml
from pipewrench import merge


def merge_single(conf_string, type_mappings, template_name):
    '''
    Merge a configuration with given template
    :param conf_string: (str) The configuration
    :param type_mappings: (dict[dict[str,str]]) The type mapping
    :param template_name: (str) The name of the template to render
    :return:
    '''
    conf = yaml.load(conf_string)

    return merge.merge_single_template(template_name, type_mappings, conf)


def read_file(path):
    """
    Read a file and return the contents as string
    :param f: (str) The file to read
    :return:  (str) The file contents
    """
    with open(path, 'r') as file:
        return file.read()
