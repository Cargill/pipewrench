import pipewrench.merge as pw
import yaml
import argparse

def clean_tables(conf):
    tables=conf['tables']
    for table in tables:
        table["destination"]["clean_name"]= table["destination"]["name"].replace('/','_').replace('.','_')
    with open('data.yml', 'w') as outfile:
        yaml.dump(conf, outfile, default_flow_style=False)


parser = argparse.ArgumentParser(description='pipewrench-merge '
                                             'pipeline automation tool')

parser.add_argument('--conf',
                    dest='conf',
                    help='Yaml format configuration file.'
                         ' This file can be used as a template to be filled by '
                         '\'tables.yml\'')
parser.add_argument('--env',
                    dest='env',
                    help='Yaml format environment file.'
                         ' Key-value pairs in this file that are templated in '
                         '\'env.yml\'')
args = parser.parse_args()


env=pw.get_env(path=args.env)
conf=pw.get_conf(path=args.conf,env=env)
print(clean_tables(conf))
