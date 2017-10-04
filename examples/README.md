# sqoop-parquet-hdfs-impala example config

Run `pipewrench-merge` on an environment file `env.yml`, a set of tables `tables.yml`, and a set of templates
creating pipeline config that can be applied with a Makefile.

Config files and all templates are meant to be easily modified for your environment.

## Running the example

Execute `generate-scripts`

```bash
./sqoop-parquet-hdfs-impala/generate-scripts
./sqoop-parquet-hdfs-kudu-impala/generate-scripts
```

Generated config can be found int `example-dir/output/first_imported_table` and 
`example-dir/output/second_imported_table`.


