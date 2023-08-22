#!/bin/bash

## NameNode의 네임스페이스가 포맷되었는지 확인 및 포맷진행
# 네임스페이스 디렉토리를 입력받아서 
NAME_DIR=$1

# 비어있지 않다면 이미 포맷된 것이므로 건너뛰고
if [ "$(ls -A $NAME_DIR)" ]; then
  echo "NameNode is already formatted."
# 비어있다면 포맷을 진행
else
  echo "Format NameNode ============================================== "
  $HADOOP_HOME/bin/hdfs --config $HADOOP_CONF_DIR namenode -format
fi

# NameNode 기동
echo "Run NameNode ============================================== "
$HADOOP_HOME/bin/hdfs --config $HADOOP_CONF_DIR namenode
/etc/init.d/ssh start
service ssh start
start-all.sh

# logging 바인딩 충돌경고 제거(SLF4J: Class path contains multiple SLF4J bindings)
rm /opt/hadoop-3.3.5/apache-hive-3.1.3-bin/lib/log4j-slf4j-impl-2.17.1.jar

# Hive
hdfs dfs -mkdir -p /user/test
hdfs dfs -mkdir -p /user/tmp
hdfs dfs -mkdir -p /user/hive/warehouse
hdfs dfs -chmod g+w /user/tmp
hdfs dfs -chmod g+w /user/test
hdfs dfs -chmod g+w /user/hive/warehouse
# metastore 기동
hiveserver2
# hive의 Metastore db로 사용하기 위해 postgres를 초기화
schematool -initSchema -dbType postgres
