#!/bin/bash

NAME_DIR=$1
echo $NAME_DIR

if [ "$(ls -A $NAME_DIR)" ]; then
  echo "NameNode is already formatted."
else
  echo "Format NameNode."
  hdfs namenode -format
fi

/etc/init.d/ssh start
/hadoop-3.3.5/sbin/start-all.sh
hdfs dfs -mkdir -p /user/test 
hdfs dfs -mkdir -p /user/tmp 
hdfs dfs -mkdir -p /user/hive/warehouse 
hdfs dfs -chmod g+w /user/tmp 
hdfs dfs -chmod g+w /user/test
hdfs dfs -chmod g+w /user/hive/warehouse 
# chmod -R 777 /opt
schematool -initSchema -dbType postgres
hiveserver2