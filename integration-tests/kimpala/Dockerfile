FROM nimmis/java:14.04-oracle-8-jdk
MAINTAINER Sandish Kumar HN <sanysandish@gmail.com>

# Base image doesn't start in root
WORKDIR /

# Add the CDH 5 repository
COPY conf/cloudera.list /etc/apt/sources.list.d/cloudera.list
# Set preference for cloudera packages
COPY conf/cloudera.pref /etc/apt/preferences.d/cloudera.pref
# Add repository for python installation
COPY conf/python.list /etc/apt/sources.list.d/python.list

# Add a Repository Key
RUN wget http://archive.cloudera.com/cdh5/ubuntu/trusty/amd64/cdh/archive.key -O archive.key && sudo apt-key add archive.key && \
    apt-get update

# Install CDH package and dependencies
RUN apt-get install -y sqoop zookeeper-server && \
    apt-get install -y hadoop-conf-pseudo && \
    apt-get install -y python2.7 && \
    apt-get install -y spark-core spark-history-server spark-python && \
    apt-get install -y mysql-client && \
    apt-get install -y make

COPY conf/cloudera-impala-kudu.list /etc/apt/sources.list.d/

RUN curl -o archive.key https://archive.cloudera.com/cdh5/ubuntu/trusty/amd64/cdh/archive.key \
    && apt-key add archive.key \
    && apt-key update \
    && apt-get update

RUN apt-get install -y sqoop wget nano make hive hive-metastore \
    impala impala-catalog impala-server \
    impala-state-store impala-shell \
    kudu-master kudu-tserver \
    rsyslog

# Copy updated config files
COPY conf/core-site.xml /etc/hadoop/conf/core-site.xml
COPY conf/hdfs-site.xml /etc/hadoop/conf/hdfs-site.xml
COPY conf/mapred-site.xml /etc/hadoop/conf/mapred-site.xml
COPY conf/hadoop-env.sh /etc/hadoop/conf/hadoop-env.sh
COPY conf/yarn-site.xml /etc/hadoop/conf/yarn-site.xml
COPY conf/fair-scheduler.xml /etc/hadoop/conf/fair-scheduler.xml
COPY conf/spark-defaults.conf /etc/spark/conf/spark-defaults.conf
COPY conf/hive-site.xml /etc/hive/conf/

# Format HDFS
RUN sudo -u hdfs hdfs namenode -format


# Mysql Driver
RUN wget http://central.maven.org/maven2/mysql/mysql-connector-java/5.1.6/mysql-connector-java-5.1.6.jar
RUN cp mysql-connector-java-5.1.6.jar /var/lib/sqoop/
RUN wget http://www.java2s.com/Code/JarDownload/java-json/java-json.jar.zip
RUN unzip java-json.jar.zip
RUN cp java-json.jar /var/lib/sqoop/

RUN echo "--use_hybrid_clock=false" >> /etc/kudu/conf/master.gflagfile \
    && echo "--use_hybrid_clock=false" >> /etc/kudu/conf/tserver.gflagfile

COPY conf/run-all-services.sh /run-all-services.sh
RUN chmod +x /run-all-services.sh

COPY conf/impala /etc/default/impala


# NameNode (HDFS)
EXPOSE 8020 50070

# DataNode (HDFS)
EXPOSE 50010 50020 50075

# ResourceManager (YARN)
EXPOSE 8030 8031 8032 8033 8088

# NodeManager (YARN)
EXPOSE 8040 8042

# JobHistoryServer
EXPOSE 10020 19888

# Hue
EXPOSE 8888

# Spark history server
EXPOSE 18080

# Technical port which can be used for your custom purpose.
EXPOSE 9999

CMD ["/run-all-services.sh"]
