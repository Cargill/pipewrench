#!/usr/bin/env python
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
import argparse
from pipewrench import merge
from marshmallow import Schema, fields
import yaml
# This script will validate required metatada properties are filled in a given configuration.

class Column(Schema):
    comment = fields.String(required=True)

class Table(Schema):
    META_CONTACT_INFO = fields.String(required=True)
    META_LOAD_FREQUENCY = fields.String(required=True)
    META_SECURITY_CLASSIFICATION = fields.String(required=True)
    META_SOURCE = fields.String(required=True)
    id = fields.String(required=True)
    columns = fields.Nested(Column, many=True)


class Conf(Schema):
    tables = fields.Nested(Column, many=True)


def main(conf_path, env_path):
    has_errors = False

    env = merge.get_env(env_path)
    conf = merge.get_conf(conf_path, env)

    for table in conf['tables']:
        result = Table().load(table)
        if (result.errors):
            print(yaml.dump({ table['id']: result.errors}))
        else:
            print('ok')
        has_errors = True

    exit(not has_errors)


if __name__ == "__main__":

    parser = argparse.ArgumentParser(description='yaml schema validator'
                                                 'Usage: ./script.py --env=/path/to/env'
                                                 ' --conf=/path/to/conf')

    parser.add_argument('--conf',
                        dest='conf',
                        help='Yaml format configuration file.'
                             ' This file can be used as a template to be filled by '
                             '\'env.yml\'')
    parser.add_argument('--env',
                        dest='env',
                        help='Yaml format environment file.'
                             ' Key-value pairs in this file that are templated in '
                             '\'conf.yml\'')

    args = parser.parse_args()
    main(args.conf, args.env)
