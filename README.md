# Hadoop dockerizing from scratch

## 개념
    Hadoop, Hive, Spark, Kafka 등 어디까지 구성할지
- 구조
    - DW
    - ODS (staging)
    - DM
- 분석환경
### hive =sql(저장형식 orc 압축율 3배 장점)
### kafka
- 트럭IoT 실시간 대용량데이터 
- producer consumer 데이터 유실이 적고 순차적으로 메세지 형태로 전송(선입선출)
### Spark
- 유용한 시각화 오픈소스 (지도표시) 사용가능

## 도커 정보
https://www.44bits.io/ko/post/is-docker-container-a-virtual-machine-or-a-process
- 도커 컨테이너는 가상머신이 아니고 프로세스다
    >컨테이너는 호스트 시스템의 커널을 사용한다.
    >컨테이너는 이미지에 따라서 실행되는 환경(파일 시스템)이 달라진다.
    - 가령 맥OS의 경우 리눅스가 아니므로 네이티브하게 도커를 사용할 수 없어서 도커 데스크탑은 리눅스킷 기반 경량 가상머신 위에서 도커를 실행
    - cat /etc/*-release

## 도큐먼트 참고 진행
### 하둡클러스터 실행 준비
- https://hadoop.apache.org/docs/stable/hadoop-project-dist/hadoop-common/SingleCluster.html#Prepare_to_Start_the_Hadoop_Cluster
    ```
    # 컨테이너 구동 후 내부에 수정할 파일을 복사해오기
    # docker cp [컨테이너명]:[내부경로/hadoop-env.sh] [가져올경로]
    docker cp namenode:/etc/hadoop/hadoop-env.sh .

    # 54번째 줄에 다음과 같이 내부 자바 설치 경로 입력
    export JAVA_HOME=/lib/jvm/java-11-openjdk-amd64

    # @docker-compose.yml 이후 해당 파일로 내부의 파일 덮어쓰기
    volumes:
    - /home/yh-jung/home/hdfs01/hd01/hadoop-env.sh:/hadoop-3.3.4/etc/hadoop/hadoop-env.sh

    # 컨테이너내부 /hadoop-3.3.4 경로에서 hadoop인식 확인
    bin/hadoop
    /hadoop-3.3.4/bin/hadoop version
    ```
### 1. Standalone Operation
- https://hadoop.apache.org/docs/stable/hadoop-project-dist/hadoop-common/SingleCluster.html#Standalone_Operation
    ```
    # @/hadoop-3.3.4
    mkdir input
    cp etc/hadoop/*.xml input
    bin/hadoop jar share/hadoop/mapreduce/hadoop-mapreduce-examples-3.3.4.jar grep input output 'dfs[a-z.]+'
    cat output/*
    ```

### 2. Pseudo-Distributed Operation
1. Format the filesystem:
    `$ bin/hdfs namenode -format`
1. Start NameNode daemon and DataNode daemon:
    `$ sbin/start-dfs.sh`
    - 에러발생 https://cwiki.apache.org/confluence/display/HADOOP2/connectionrefused
    ```
    root@e39abee09715:~# /hadoop-3.3.4/sbin/start-dfs.sh
    Starting namenodes on [e39abee09715]
    pdsh@e39abee09715: e39abee09715: connect: Connection refused
    Starting datanodes
    localhost: ERROR: Cannot set priority of datanode process 2253
    pdsh@e39abee09715: localhost: ssh exited with exit code 1
    2023-05-31 05:47:11,302 ERROR conf.Configuration: error parsing conf hdfs-site.xml
    ```

    - 이후 다음을 추가
    ```
    #@ /root/.bashrc
    export HADOOP_HOME=/usr/lib/hadoop_package/hadoop-2.5.6
    export HADOOP_MAPRED_HOME=$HADOOP_HOME 
    export HADOOP_COMMON_HOME=$HADOOP_HOME 
    export HADOOP_HDFS_HOME=$HADOOP_HOME 
    export YARN_HOME=$HADOOP_HOME
    export HADOOP_COMMON_LIB_NATIVE_DIR=$HADOOP_HOME/lib/native 
    export PATH=$PATH:$HADOOP_HOME/sbin:$HADOOP_HOME/bin
    ```
    - cannot-set-priority-of-datanode-process
        - https://stackoverflow.com/questions/46283634/localhost-error-cannot-set-priority-of-datanode-process-32156
        - 이미 사용중인 포트번호 일 수도 있음.
    - /home/ubuntu 사용자명이 우분투 왜?

---

# 노드별 컨테이너로 하둡구성하기
https://blog.geunho.dev/posts/hadoop-docker-test-env-hdfs/#fn:1

## 디렉토리 구조
```
.
└── hadoop
    ├── base
    ├── namenode
    ├── datanode
    └── docker-compose.yml
```

## 명령어
```bash
# docker 실행 권한 부여
sudo chown yhjeong:yhjeong /var/run/docker.sock

# @/hdfs01/hadoop/base 베이스 이미지 빌드
cd base
docker build --progress=plain -t hadoop-base:2.9.2 .

# @/hdfs01/hadoop/namenode : 네임노드 이미지 빌드
cd ../namenode
docker build -t hadoop-namenode:2.9.2 .

# @/hdfs01/hadoop(root dir) : NameNode 컨테이너 기동
cd ..
docker-compose up -d
```

## NameNode 컨테이너 기동 정상여부 확인
1. docker command
```bash
docker ps -f name=node
docker logs -f namenode
```

1. 생성된 bridge 네트워크 확인
```bash
# docker network ls
NETWORK ID          NAME                DRIVER              SCOPE
0d9989bd9f78        bridge              bridge              local
9ae1ae84360f        hadoop_bridge       bridge              local
62a94ebd58b7        host                host                local
```

1. 생성된 volume 확인
```bash
# docker volume ls -f name=node
DRIVER              VOLUME NAME
local               hadoop_namenode
```

1. 네임노드 웹UI http://localhost:50070 접속 가능여부 확인
    - http://192.168.0.125:50070

1. NameNode 컨테이너 내부에 있는 Hadoop클라이언트 실행
    - datanode 띄우지 않더라도 폴더생성삭제, 파일목록조회 가능
        ```py
        # namenode 이름의 컨테이너의 hadoop 클라이언트를 실행. 파일 시스템의 root 디렉토리를 모두 조회한다
        docker exec namenode /opt/hadoop/bin/hadoop fs -ls -R /

        # 명령어 등록
        alias hadoop="docker exec namenode /opt/hadoop/bin/hadoop"

        # 폴더 생성/조회/삭제
        hadoop fs -mkdir -p /tmp/test/app
        hadoop fs -ls -R /tmp
        hadoop fs -rm -r /tmp/test/app
        ```

## DataNode
1. 파일 블록을 저장하는 로컬 파일 시스템 경로
1. DataNode 용 hdfs-site.xml 설정
1. 이미지 생성
    ```bash
    cd datanode
    docker build -t hadoop-datanode:2.9.2 .
    ```

---

# Note
```bash
# 자동 종료되는 컨테이너 프로세스 접속 exec안될때 사용가능한 명령어
# docker run -it --entrypoint=/bin/bash your_image_id
docker run -it --entrypoint=/bin/bash ff735660e7fa
# cp, mv 파일 강제 덮어쓰기 명령어
/usr/bin/cp -f src_path/test.txt trg_path/test.txt
# 명령어 확인하기
docker image inspect hadoop_hadoop:latest | jq '.[].ContainerConfig.Cmd'
```

## error
- 윈도우와 우분투 왔다갔다 하면서 코드내 공백이 바뀐경우
https://github.com/puphpet/puphpet/issues/266

- CentOS Stream 8에 Virtualbox 설치시 yum 명령어 안되는 문제
https://www.how2shout.com/how-to/install-virtualbox-in-centos-8-linux-or-stream.html
```bash
sudo dnf config-manager --add-repo=https://download.virtualbox.org/virtualbox/rpm/el/virtualbox.repo
sudo rpm --import https://www.virtualbox.org/download/oracle_vbox.asc
```

- 도커 no space left 에러
    - docker system df에 (builder 캐시 RECLAIMABLE 비율 확인)
    - docker builder prune
    - 참고
        - https://collabnix.com/how-to-clear-docker-cache/
        - https://www.baeldung.com/linux/docker-fix-no-space-error#2-changing-the-storage-location
    - RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*(캐시삭제)
        ```
        # 마지막에 한번 캐시삭제시
        hadoop-base                   latest           1fea6560a19b   2 hours ago     3.53GB
        # 매 압축해제 마다 캐시삭제시 이미지 용량(intermediate layer)
        hadoop-base                   latest           19c3bc0260f7   19 minutes ago   2.83GB
        ```
    - <none>으로 되어있는 이미지 삭제
        - https://www.lainyzine.com/ko/article/docker-prune-usage-remove-unused-docker-objects/
        ```
        # docker image prune와 동일
        docker rmi $(docker images -f dangling=true -q)
        ```

- namenode is running as process 77.  Stop it first and ensure /tmp/hadoop-root-namenode.pid file is empty before retry.

- ssh 수동 실행으로 웹UI 접속확인
```bash
# this tells you whether your ssh instance is active/inactive
service ssh status
# OR this list all running processes whose names contain the string "ssh"
ps -A | grep ssh
# It's likely that ssh would be active and running but sshd would not. To enable them:
service ssh start
# for Debian/Ubuntu
/etc/init.d/ssh start
/hadoop-3.3.5/sbin/start-all.sh

```

## 포맷
1. 서버 종료
    - 모든 노드의 네임노드 프로세스와 데이타노드 프로세스 종료
1. 네임노드 포맷
    - hdfs namenode -format
1. 설정 변경
    - dfs.datanode.data.dir 경로에서 VERSION파일의 clusterID를 신규롤 생성된 ID로 변경
    - cat /opt/hadoop/dfs/name/**/VERSION
