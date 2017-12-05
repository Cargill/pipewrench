#!/bin/bash -e
echo 'loading baseball data'
mysql -P 3306 -uroot -ppipewrench -h mysql < /data/load-baseball.sql
echo 'loading vocab data'
mysql -P 3306 -uroot -ppipewrench -h mysql < /data/load-vocab.sql
echo 'loading titanic data'
mysql -P 3306 -uroot -ppipewrench -h mysql < /data/load-titanic.sql
echo 'loading data complete'
