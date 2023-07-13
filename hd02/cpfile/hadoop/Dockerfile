FROM ubuntu:22.04
RUN apt update
RUN apt install wget -y
RUN wget https://downloads.apache.org/hadoop/common/hadoop-3.3.5/hadoop-3.3.5.tar.gz
RUN tar xzf hadoop-3.3.5.tar.gz

#HIVE
RUN wget https://downloads.apache.org/hive/hive-3.1.3/apache-hive-3.1.3-bin.tar.gz
RUN tar xzf apache-hive-3.1.3-bin.tar.gz
RUN cp -r apache-hive-3.1.3-bin /hadoop-3.3.5/

RUN apt install openjdk-8-jdk -y wget ssh pdsh
RUN rm -rf hadoop-3.3.5.tar.gz
RUN rm -rf apache-hive-3.1.3-bin.tar.gz
RUN rm -rf apache-hive-3.1.3-bin

#SPARK
RUN wget https://dlcdn.apache.org/spark/spark-3.4.0/spark-3.4.0-bin-hadoop3.tgz
RUN tar xvzf spark-3.4.0-bin-hadoop3.tgz
RUN ln -s spark-3.4.0-bin-hadoop3 spark

ENV HADOOP_HOME=/hadoop-3.3.5
ENV HADOOP_INSTALL=$HADOOP_HOME 
ENV HADOOP_MAPRED_HOME=$HADOOP_HOME
ENV HADOOP_COMMON_HOME=$HADOOP_HOME
ENV HADOOP_HDFS_HOME=$HADOOP_HOME
ENV YARN_HOME=$HADOOP_HOME
ENV HADOOP_COMMON_LIB_NATIVE_DIR=$HADOOP_HOME/lib/native 
ENV HIVE_HOME=$HADOOP_HOME/apache-hive-3.1.3-bin
ENV PATH=$PATH:$HADOOP_HOME/sbin:$HADOOP_HOME/bin:$HIVE_HOME/bin:/spark/bin
ENV HADOOP_OPTS="-Djava.library.path=$HADOOP_HOME/lib/native"
ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64/
ENV HDFS_NAMENODE_USER=root
ENV HDFS_DATANODE_USER=root
ENV HDFS_SECONDARYNAMENODE_USER=root
ENV YARN_RESOURCEMANAGER_USER=root
ENV YARN_NODEMANAGER_USER=root
RUN SPARK_HOME="/spark-3.4.0-bin-hadoop3"

#HADOOP-CONF
COPY ./config/hadoop-env.sh /hadoop-3.3.5/etc/hadoop/hadoop-env.sh
COPY ./config/core-site.xml /hadoop-3.3.5/etc/hadoop/core-site.xml
COPY ./config/hdfs-site.xml /hadoop-3.3.5/etc/hadoop/hdfs-site.xml
COPY ./config/mapred-site.xml /hadoop-3.3.5/etc/hadoop/mapred-site.xml
COPY ./config/yarn-site.xml /hadoop-3.3.5/etc/hadoop/yarn-site.xml

#HIVE-CONF
COPY ./config/hive/hive-env.sh $HIVE_HOME/conf/hive-env.sh
COPY ./config/hive/hive-site.xml $HIVE_HOME/conf/hive-site.xml

RUN apt-get install -y openssh-server

RUN mkdir -p /opt/hadoop/dfs/name
RUN mkdir -p /opt/hadoop/dfs/data

RUN ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa
RUN cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
RUN chmod 0600 ~/.ssh/authorized_keys

ADD start.sh /start.sh
RUN chmod a+x /start.sh
RUN echo $(pwd)
CMD ["/start.sh", "/opt/hadoop/dfs/name"]