FROM ubuntu:22.04

# 바이너리를 내려받기 위해 설치
RUN apt-get update \
    && apt-get install -y openssh-client openssh-server \
    && apt-get update \
    && apt install -y openjdk-8-jdk curl wget ssh pdsh vim

# Hadoop 을 내려받고 /opt/hadoop에 압축 해제
ENV HADOOP_VERSION=3.3.5
ENV HADOOP_URL=https://archive.apache.org/dist/hadoop/common/hadoop-$HADOOP_VERSION/hadoop-$HADOOP_VERSION.tar.gz
RUN curl -fSL "$HADOOP_URL" -o /tmp/hadoop.tar.gz \
    && tar -xvf /tmp/hadoop.tar.gz -C /opt/ \
    && rm /tmp/hadoop.tar.gz \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# HIVE
ENV HIVE_VERSION=3.1.3
ENV HIVE_URL=https://downloads.apache.org/hive/hive-$HIVE_VERSION/apache-hive-$HIVE_VERSION-bin.tar.gz
RUN wget $HIVE_URL -P /tmp/ \
    && tar xzf /tmp/apache-hive-$HIVE_VERSION-bin.tar.gz -C /opt/hadoop-$HADOOP_VERSION/ \
    && rm -f /tmp/apache-hive-$HIVE_VERSION-bin.tar.gz \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

#SPARK
ENV SPARK_VERSION=3.4.0
ENV SPARK_URL=https://dlcdn.apache.org/spark/spark-$SPARK_VERSION/spark-$SPARK_VERSION-bin-hadoop3.tgz
RUN curl -fSL "$SPARK_URL" -o /tmp/spark.tgz \
    && tar -xvf /tmp/spark.tgz -C /opt/ \
    && rm /tmp/spark.tgz \
    && ln -s spark-3.4.0-bin-hadoop3 spark \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# 데이터 디렉토리 생성 및 설정 폴더의 심볼릭 링크 생성
RUN ln -s /opt/hadoop-$HADOOP_VERSION /opt/hadoop \
    && mkdir /opt/hadoop/dfs \
    && ln -s /opt/hadoop-$HADOOP_VERSION/etc/hadoop /etc/hadoop \
    && rm -rf /opt/hadoop/share/doc

## 1. hadoop 환경 변수 등록
ENV HADOOP_HOME /opt/hadoop
ENV HADOOP_CONF_DIR /etc/hadoop
ENV PATH $HADOOP_HOME/bin/:$PATH
# ENV HADOOP_INSTALL=$HADOOP_HOME 
# ENV HADOOP_MAPRED_HOME=$HADOOP_HOME
# ENV HADOOP_COMMON_HOME=$HADOOP_HOME
# ENV HADOOP_HDFS_HOME=$HADOOP_HOME
# ENV HADOOP_COMMON_LIB_NATIVE_DIR=$HADOOP_HOME/lib/native 
# ENV HADOOP_OPTS="-Djava.library.path=$HADOOP_HOME/lib/native"
# stop-all.sh 등의 명령어 실행시 필요
ENV HDFS_NAMENODE_USER=root
ENV HDFS_SECONDARYNAMENODE_USER=root
ENV HDFS_DATANODE_USER=root
ENV YARN_HOME=$HADOOP_HOME
ENV YARN_RESOURCEMANAGER_USER=root
ENV YARN_NODEMANAGER_USER=root
ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64/

# 로컬의 파일을 복제
ADD core-site.xml $HADOOP_CONF_DIR/
ADD hadoop-env.sh $HADOOP_CONF_DIR/
ADD hadoop-functions.sh $HADOOP_HOME/libexec/

## 2. hive 환경 변수 등록
ENV HIVE_HOME=$HADOOP_HOME/apache-hive-3.1.3-bin
ENV PATH=$PATH:$HADOOP_HOME/sbin:$HADOOP_HOME/bin:$HIVE_HOME/bin:/spark/bin

## 3. spark 환경 변수 등록
RUN SPARK_HOME="/spark-$SPARK_VERSION-bin-hadoop3"

## 4. ssh 문제
RUN ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa
RUN cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
RUN chmod 0600 ~/.ssh/authorized_keys

# intermediate layer에 쌓이는 cached 패키지 파일과 리스트 정리
RUN apt-get clean && rm -rf /var/lib/apt/lists/*