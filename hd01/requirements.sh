### 하둡관련
sudo apt update && sudo apt-get update
sudo apt-get install -y openjdk-11-jdk wget sudo vim tree
sudo apt-get install -y ssh pdsh

# 하둡 파일 경로가 존재하지 않으면 다운받고 압축해제하기
HDFS_DIR=/hadoop-3.3.4; SYNC_DIR=/sync; ZIP_DIR=$SYNC_DIR$HDFS_DIR.tar.gz
if [ ! -d $HDFS_DIR ]
then
    echo "$HDFS_DIR is NOT found!!!!!!"
    if [ ! -e $ZIP_DIR ]
    then
        echo "HDFS zip file is NOT found in $ZIP_DIR!!!!!!!!!!!!!!"
        wget -P $SYNC_DIR https://dlcdn.apache.org/hadoop/common$HDFS_DIR$HDFS_DIR.tar.gz
        echo "Download is completed in $ZIP_DIR !!!!!!!!!!!"
    else
        echo "HDFS zip file is found in $ZIP_DIR!!!!!!!!!!!!!!!!"
    fi
    sudo tar -xzvf $ZIP_DIR -C /
    echo "Unzip is completed in $HDFS_DIR !!!!!!!!!!!!!"
else
    echo "hdfs dir found in $HDFS_DIR. Nothing to do!!!!!!!!!!!!!!!"
fi