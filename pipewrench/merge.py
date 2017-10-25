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
Main application module responsible for
- Parsing config file and environment
- Merging environment into config file
- Looping through config and templates, and outputting pipeline configuration
"""
import argparse
import codecs
import logging
import os
from json import dumps
from jinja2 import Template
import yaml



OUT_DIR = "output"
LOGGING_FORMAT = "[%(levelname) s:%(filename)s:%(lineno)s in %(funcName)20s() ] %(message)s"

# Type mappings are loaded globally by `load_mapping_file` so they can be used from templates
# pylint: disable=invalid-name
type_mappings = {}


def main():
    """
    Main method
    :return: nothing, writes to file
    """
    parser = argparse.ArgumentParser(description='pipewrench-merge '
                                                 'pipeline automation tool')

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
    parser.add_argument('--pipeline-templates',
                        dest='pipeline_template_dir',
                        help='yaml environment file')

    parser.add_argument('--debug_level',
                        dest='debug_level',
                        help='One of \'CRITICAL\', \'WARNING\','
                             ' \'DEBUG\', \'INFO\', \'WARNING\'')

    args = parser.parse_args()

    logging_level = getattr(logging, args.debug_level.upper()) \
        if args.debug_level else 'INFO'
    logging.basicConfig(format=LOGGING_FORMAT, level=logging_level)

    merge(args.pipeline_template_dir, args.env, args.conf)


def merge(template_dir, env_path, conf_path):
    """
    :param template_dir: The template directory
    :param env_path: Path to the environment yaml file
    :param conf_path: Path to the configuration yaml file
    :return: nothing, writes to file
    """
    env = get_env(env_path)
    conf = get_conf(path=conf_path, env=env)

    load_mapping_file('type_mapping', template_dir, conf)

    merge_templates(template_dir, conf)

# pylint: disable=too-many-locals
def merge_templates(template_dir, conf):
    """
     - Apply an `env.yml` to a configuration (`tables.yml`)
     - Loop through the tables in the configuration
     - Render a template for each file in the `templates` directory
     - Place the result in the `output` directory
    :param template_dir: The directory containing Jinja2 templates
    :param conf: The configuration as dict|list from yaml
    :return: None
    """
    if not os.path.exists(OUT_DIR):
        os.mkdir(OUT_DIR)

    pipeline_name = os.path.basename(template_dir)
    pipeline_out_dir = os.path.join(OUT_DIR, pipeline_name)
    if not os.path.exists(pipeline_out_dir):
        os.mkdir(pipeline_out_dir)
    templates_symlink = os.path.join(os.path.abspath(pipeline_out_dir), "templates")
    if not os.path.exists(templates_symlink):
        templates_dir_abs = os.path.abspath(template_dir)
        logging.debug('creating symlink from: %s to %s', templates_dir_abs, templates_symlink)

        os.symlink(templates_dir_abs, templates_symlink)
    tables = conf['tables']
    logging.info('loading %d table(s)', len(tables))
    # render jinja meta templates
    for template_name in os.listdir(template_dir):
        if template_name.endswith(".meta"):
            template_path = os.path.join(os.path.realpath(template_dir), template_name)

            with codecs.open(template_path, 'r', 'UTF-8') as template_file:
                logging.debug('reading template: "%s"', template_path)
                template = template_file.read()
                # Remove the '.meta'  file extension from the name of the files
                file_path = os.path.join(pipeline_out_dir, template_name)[:-5]
                rendered = render_meta(template, conf, tables)
                write(rendered, file_path)

    for table in tables:
        table_dir = os.path.join(pipeline_out_dir, table['id'])
        if not os.path.exists(table_dir):
            os.mkdir(table_dir)

        logging.debug("type mappings loaded: \n%s", type_mappings)

        dir_templates = [os.path.realpath(os.path.join(template_dir, x))
                         for x in os.listdir(template_dir)]

        # render jinja table templates
        for template_path in dir_templates:
            template_name = os.path.basename(template_path)

            # Don't try to render directories as templates
            if os.path.isdir(template_path) or template_name.endswith("test.py"):
                continue

            # Read each line in the 'imports' file and render the template it points to
            if template_name == 'imports':
                imports = open(template_path).read().splitlines()
                for i in imports:
                    full_path = os.path.realpath(os.path.join(template_dir, i))
                    render_write_template(conf, table, table_dir, os.path.basename(i), full_path)

            # Render the rest of the templates
            elif not template_name.endswith(".meta"):
                template_path = os.path.join(template_dir, template_name)
                render_write_template(conf, table, table_dir, template_name, template_path)


def render_write_template(conf, table, table_dir, template_name, template_path):
    """
    Render a template and write it to file.
    :param conf: the configuration
    :param table: the current table name
    :param table_dir: the current table directory
    :param template_name: the template name
    :param template_path: the path of the template in the tempaltes directory
    :return:
    """
    with codecs.open(template_path, 'r', 'UTF-8') as template_file:
        logging.debug('Rendering template: "%s"', template_path)

        template = template_file.read()
        file_path = os.path.join(table_dir, template_name)
        rendered = render_table(template, conf, table)
        write(rendered, file_path)


def load_mapping_file(mapping, templates_dir, conf):
    """
    Load a type mapping file from disk into a global variable.
    :param mapping: the name of the mapping
    :param templates_dir: templates directory
    :param conf: the configuration
    :return:
    """
    try:
        with codecs.open(os.path.join(templates_dir, conf[mapping]), 'r', 'UTF-8') as mapping_file:
            logging.debug('mapping file: %s', mapping)
            type_mappings[mapping] = yaml.load(mapping_file.read())
            logging.debug("type mappings: %s", type_mappings)
    except KeyError:
        logging.warning(
            "no mapping file found '%s', templates calling this mapping will error.", mapping)


def render(template, **kwargs):
    """
    Render a template.
    :param template: The (str) template
    :param kwargs: A dictionary of arguments to fill the template
    :return: The reified template
    """
    template = Template(template)
    template_functions = [map_datatypes, dumps]

    for function in template_functions:
        template.globals[function.__name__] = function

    return template.render(**kwargs)


def render_table(template, conf, table):
    """
    Render a single table/template pair
    :param template: The template to render
    :param conf: The configuration to be passed to the template
    :param table: The table to pass to the template
    :return: a rendered template
    """
    return render(template, conf=conf, table=table)


def render_meta(template, conf, tables):
    """
    :param template: The template to render
    :param conf: The configuration
    :param tables: A list of tables to render
    :return: A rendered template
    """
    return render(template, conf=conf, tables=tables)


def get_conf(path, env):
    """
    Read the configuration template from file and apply the environement to it.
    :param path: Path to the configuration
    :param env: The environment (a Map)
    :return: The configuration (loaded yaml)
    """
    with codecs.open(path, 'r', 'UTF-8') as conf_file:
        str_conf = conf_file.read()

        # Apply environment arguments and functions to configuration
        env_applied = render(str_conf, **env)

        # Load the conf yaml into Python data structures
        conf = yaml.load(env_applied)
        logging.debug('conf: %s', conf)

        return conf


def get_env(path):
    """
    Read the environment file from given path.
    :param path: Path to the environment file.
    :return: the environment (loaded yaml)
    """
    with codecs.open(path, 'r', 'UTF-8') as env_file:
        conf_string = env_file.read()

        env = yaml.load(conf_string)
        logging.debug('env: %s', env)
        return env


def write(string, fpath):
    """
    Write string to path. If it's a bash script make it executable.
    :param string: String to write
    :param fpath: Path to write to
    :return:
    """
    with codecs.open(fpath, 'w', 'UTF-8') as f:
        f.write(string)
        if fpath.endswith('.sh'):
            os.chmod(fpath, 0o750)


# Script entrypoint
if __name__ == '__main__':
    main()


# Template functions.
# These functions are intended to be called from Jinja2 templates.
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
    mapped_datatype = type_mappings['type_mapping'].get(datatype)
    logging.debug('mapped %s to %s', datatype, mapped_datatype)
    return mapped_datatype


# Testing Functions
def merge_single_template(template_file_path, type_mapping, conf):
    """
    Merge a single template and return the result. Used for unit testing Jinja templates.
    :param template_file_path: The template file to render
    :param type_mapping: The type mapping file
    :param conf: The configuration as str
    :return:
    """
    type_mappings['type_mapping'] = type_mapping
    table = conf['tables'][0]
    with codecs.open(template_file_path, 'r', 'UTF-8') as template_file:
        template = template_file.read()
        return render_table(template, conf, table)
