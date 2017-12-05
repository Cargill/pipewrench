#!/bin/bash

export HADOOP_OPTS="-Djava.net.preferIPv4Stack=true $HADOOP_CLIENT_OPTS"
export YARN_RESOURCEMANAGER_OPTS="-Xmx64m"
