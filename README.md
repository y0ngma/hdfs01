# docker로 하둡구성하기

https://blog.geunho.dev/posts/hadoop-docker-test-env-hdfs/#fn:1

## 명령어
```bash
# 이미지 빌드 로그 보기
cd base
docker build --progress=plain -t hadoop-base:2.9.2 .

cd ../namenode
docker build -t hadoop-namenode:2.9.2 .

cd ..
docker-compose up -d
```