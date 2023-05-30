# Hadoop dockerizing from scratch
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
    docker cp hdfs_con:/hadoop-3.3.4/etc/hadoop/hadoop-env.sh /home/yh-jung/home/hdfs01/hd01/

    # 54번째 줄에 다음과 같이 내부 자바 설치 경로 입력
    export JAVA_HOME=/lib/jvm/java-11-openjdk-amd64

    # @docker-compose.yml 이후 해당 파일로 내부의 파일 덮어쓰기
    volumes:
    - /home/yh-jung/home/hdfs01/hd01/hadoop-env.sh:/hadoop-3.3.4/etc/hadoop/hadoop-env.sh

    # 컨테이너내부 /hadoop-3.3.4 경로에서 hadoop인식 확인
    bin/hadoop
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
