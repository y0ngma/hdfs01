VARGRANT_SYNC_FOLDER=../../hdfs01_sync_folder
if [ -d $VARGRANT_SYNC_FOLDER ]; then
  echo "My vagrant sync folder dir in host: $VARGRANT_SYNC_FOLDER"
else
  echo "Creating my vagrant sync folder: $VARGRANT_SYNC_FOLDER"
  mkdir -p $VARGRANT_SYNC_FOLDER

cp ./cpfile/core-site.xml $VARGRANT_SYNC_FOLDER
cp ./cpfile/hadoop-env.sh $VARGRANT_SYNC_FOLDER
cp ./cpfile/hdfs-site.xml $VARGRANT_SYNC_FOLDER
cp ./cpfile/docker-compose.yml $VARGRANT_SYNC_FOLDER
cp ./cpfile/Dockerfile $VARGRANT_SYNC_FOLDER
fi