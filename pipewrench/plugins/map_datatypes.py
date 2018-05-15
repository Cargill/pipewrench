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

import logging
import yaml
import codecs
import os

type_mappings = {}

def load_mapping_file(mapping, template_dir, type_mapping_file):
    """
    Load a type mapping file from disk into a global variable.
    :param mapping: the name of the mapping
    :param templates_dir: templates directory
    :param conf: the configuration
    :return:
    """
    try:
        with codecs.open(os.path.join(template_dir, type_mapping_file), 'r', 'UTF-8') as mapping_file:
            logging.debug('mapping file: %s', mapping)
            type_mappings[mapping] = yaml.load(mapping_file.read())
            logging.debug("type mappings: %s", type_mappings)
    except KeyError:
        logging.warning(
            "no mapping file found '%s', templates calling this mapping will error.", mapping)

def map_datatypes(column, template_dir, type_mapping_file):
    """
    Given a column, extract its datatype and return possible mappings
     for it from a type-mappings.yml file.
     For example, a mapping with the datatype 'bigint' may look like:

    bigint:
     kudu: bigint
     impala: bigint
     parquet: bigint
     avro: long

     when given a column with 'bigint' this function will return:

     kudu: bigint
     impala: bigint
     parquet: bigint
     avro: long

    This function is intended to be called directly from templates
    :param conf: The configuration. Not used but kept for consistency with other functions.
    :param column: The column containing the datatype to map
    :return: The mapped datatype
    """
    load_mapping_file('type_mapping',template_dir, type_mapping_file)
    datatype = column['datatype'].lower()
    logging.debug('found datatype %s', datatype)
    mapped_datatype = type_mappings['type_mapping'].get(datatype)
    logging.debug('mapped %s to %s', datatype, mapped_datatype)
    return mapped_datatype
