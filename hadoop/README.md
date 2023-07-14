# docker로 하둡구성하기
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

## NameNode 컨테이너 기동 후
1. docker command
    ```py
    docker ps -f name=node
    docker network ls # bridge, hadoop_bridge, host 확인
    docker volume ls -f name=hadoop # hadoop_namenode 확인
    docker logs -f namenode
    ```
1. 네임노드 웹UI http://localhost:50070 접속 가능여부 확인
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
