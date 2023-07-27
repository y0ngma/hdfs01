#! /bin/sh

$HADOOP_HOME/bin/hdfs --config $HADOOP_CONF_DIR datanode
service ssh start
/etc/init.d/ssh start