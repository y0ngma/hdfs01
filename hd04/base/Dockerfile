FROM ubuntu:22.04

# 바이너리를 내려받기 위해 설치
RUN apt-get update
RUN apt install -y openjdk-8-jdk curl wget ssh pdsh

# Hadoop 을 내려받고 /opt/hadoop에 압축 해제
ENV HADOOP_VERSION=3.3.5
ENV HADOOP_URL=https://archive.apache.org/dist/hadoop/common/hadoop-$HADOOP_VERSION/hadoop-$HADOOP_VERSION.tar.gz
RUN curl -fSL "$HADOOP_URL" -o /tmp/hadoop.tar.gz \
    && tar -xvf /tmp/hadoop.tar.gz -C /opt/ \
    && rm /tmp/hadoop.tar.gz \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# 데이터 디렉토리 생성 및 설정 폴더의 심볼릭 링크 생성
RUN ln -s /opt/hadoop-$HADOOP_VERSION /opt/hadoop \
    && mkdir /opt/hadoop/dfs \
    && ln -s /opt/hadoop-$HADOOP_VERSION/etc/hadoop /etc/hadoop \
    && rm -rf /opt/hadoop/share/doc

# 로컬의 core-site.xml 파일을 복제
ADD core-site.xml /etc/hadoop/

# 실행 환경에 필요한 환경 변수 등록
ENV HADOOP_PREFIX /opt/hadoop
ENV HADOOP_CONF_DIR /etc/hadoop
ENV PATH $HADOOP_PREFIX/bin/:$PATH
ENV JAVA_HOME /usr/lib/jvm/zulu8-ca-amd64

#SPARK
ENV SPARK_VERSION=3.4.0
ENV SPARK_URL=https://dlcdn.apache.org/spark/spark-$SPARK_VERSION/spark-$SPARK_VERSION-bin-hadoop3.tgz
RUN curl -fSL "$SPARK_URL" -o /tmp/spark.tgz \
    && tar -xvf /tmp/spark.tgz -C /opt/ \
    && rm /tmp/spark.tgz \
    && ln -s spark-3.4.0-bin-hadoop3 spark \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# HIVE
ENV HIVE_VERSION=3.1.3
ENV HIVE_URL=https://downloads.apache.org/hive/hive-$HIVE_VERSION/apache-hive-$HIVE_VERSION-bin.tar.gz
RUN wget $HIVE_URL \
    && tar xzf apache-hive-$HIVE_VERSION-bin.tar.gz -C /opt/hadoop \
    && apt-get clean && rm -rf /var/lib/apt/lists/*
# RUN tar xzf apache-hive-$HIVE_VERSION-bin.tar.gz
# RUN cp -r apache-hive-$HIVE_VERSION-bin /hadoop-$HADOOP_VERSION/
# RUN rm -rf apache-hive-$HIVE_VERSION-bin.tar.gz
# RUN rm -rf apache-hive-$HIVE_VERSION-bin \

# intermediate layer에 쌓이는 cached 패키지 파일과 리스트 정리
RUN apt-get clean && rm -rf /var/lib/apt/lists/*