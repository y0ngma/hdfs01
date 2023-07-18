#!/bin/bash

## NameNode의 네임스페이스가 포맷되었는지 확인 및 포맷진행
# 네임스페이스 디렉토리를 입력받아서 
NAME_DIR=$1
# echo "$JAVA_HOME 내 파일 목록 ============================================== "
# echo "$(ls $JAVA_HOME)"
# echo "$HADOOP_HOME/bin/hdfs 파일 목록 ============================================== "
# echo "$(ls $HADOOP_HOME/bin/hdfs)"
# echo "$HADOOP_CONF_DIR 파일 목록 ============================================== "
# echo "$(ls $HADOOP_CONF_DIR)"

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