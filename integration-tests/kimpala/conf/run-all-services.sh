#!/bin/bash

service hadoop-hdfs-namenode start
service hadoop-hdfs-datanode start

sudo -u hdfs hadoop fs -mkdir -p /tmp/hadoop-yarn/staging/history/done_intermediate
sudo -u hdfs hadoop fs -chown -R mapred:mapred /tmp/hadoop-yarn/staging
sudo -u hdfs hadoop fs -chmod -R 1777 /tmp
sudo -u hdfs hadoop fs -mkdir -p /var/log/hadoop-yarn
sudo -u hdfs hadoop fs -chown yarn:mapred /var/log/hadoop-yarn

service hadoop-yarn-resourcemanager start
service hadoop-yarn-nodemanager start
service hadoop-mapreduce-historyserver start

sudo -u hdfs hadoop fs -mkdir -p /user/hdfs
sudo -u hdfs hadoop fs -chown hdfs /user/hdfs

# init spark history server
sudo -u hdfs hadoop fs -mkdir /user/spark
sudo -u hdfs hadoop fs -mkdir /user/spark/applicationHistory
sudo -u hdfs hadoop fs -chown -R spark:spark /user/spark
sudo -u hdfs hadoop fs -chmod 1777 /user/spark/applicationHistory

sleep 20
# init spark shared libraries
# client than can use SPARK_JAR=hdfs://<nn>:<port>/user/spark/share/lib/spark-assembly.jar
sudo -u spark hadoop fs -mkdir -p /user/spark/share/lib 
sudo -u spark hadoop fs -put /usr/lib/spark/lib/spark-assembly.jar /user/spark/share/lib/spark-assembly.jar 

service spark-history-server start

echo "Start Impala Kudu"
service impala-state-store start
service impala-catalog start
service impala-server start
service kudu-master start
service kudu-tserver start

echo "Setting Permission"
sudo -u hdfs hadoop fs -mkdir /user/root
sudo -u hdfs hadoop fs -mkdir /user/root/db
sudo -u hdfs hadoop fs -mkdir /user/root/db/staging
sudo -u hdfs hadoop fs -chown -R root:root /user/root
sudo -u hdfs hadoop fs -chmod -R 1777  /user/root
sudo -u hdfs hadoop fs -chmod -R 1777  /user

