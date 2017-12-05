## Pipewrench Docker Import and Export Demo
- sqoop-parquet-hdfs-kudu-impala
- kudu-impala-hdfs-parquet-sqoop

### Both Import and Export runs at init
````
cd pipwrench_docker_import_export
sudo docker build -t pipewrench_kudu_impala .
cd ../
sudo docker-compose up
````


## Sqoop-Parquet-Hdfs-Kudu-Impala
### Pipewrench import 
````
cd /root/examples/sqoop-parquet-hdfs-kudu-impala/
./generate-scripts
cd output/sqoop-parquet-hdfs-kudu-impala/first_imported_table
make first-run
````
## Kudu-Impala-Hdfs-Parquet-Sqoop
### Pipewrench Export

````
cd /root/examples/kudu-hdfs-parquet-sqoop/
./generate-scripts
cd output/kudu-hdfs-parquet-sqoop/first_imported_table
make first-run
```