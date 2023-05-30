FROM ubuntu:23.04

RUN apt update && apt-get update 
RUN apt-get install -y openjdk-11-jdk wget sudo vim tree
RUN wget https://dlcdn.apache.org/hadoop/common/hadoop-3.3.4/hadoop-3.3.4.tar.gz && tar -xzvf hadoop-3.3.4.tar.gz && rm hadoop-3.3.4.tar.gz

RUN apt-get install -y ssh pdsh

CMD ["tail","-f","/dev/null"]