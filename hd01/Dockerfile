FROM ubuntu:23.04

RUN apt update
RUN apt-get update
RUN apt-get install openjdk-11-jdk -y
RUN apt-get install wget -y

RUN wget https://dlcdn.apache.org/hadoop/common/hadoop-3.3.4/hadoop-3.3.4.tar.gz
RUN tar -xzvf hadoop-3.3.4.tar.gz && rm hadoop-3.3.4.tar.gz