VARGRANT_SYNC_FOLDER=../../hdfs01_hd02_folder
if [ -d $VARGRANT_SYNC_FOLDER ]; then
  echo "My vagrant sync folder dir in host: $VARGRANT_SYNC_FOLDER"
else
  echo "Creating my vagrant sync folder: $VARGRANT_SYNC_FOLDER"
  mkdir -p $VARGRANT_SYNC_FOLDER

cp -r ./cpfile/* $VARGRANT_SYNC_FOLDER
fi