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
import pipewrench as p

__all__ = ['map_datatypes'] 

def map_datatypes(column):
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
    datatype = column['datatype'].lower()
    logging.debug('found datatype %s', datatype)
    mapped_datatype = p.merge.type_mappings['type_mapping'].get(datatype)
    logging.debug('mapped %s to %s', datatype, mapped_datatype)
    return mapped_datatype
