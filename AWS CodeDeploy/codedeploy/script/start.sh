#!/bin/bash
echo "Starting Horilla Service...";
cd /home/ubuntu/codedeploy/build.hr-horilla.service
directory="horilla-data"
if [ ! -d "$directory" ]; then
  echo "Directory does not exist. Creating it..."
  mkdir -p "$directory" 
  echo "Directory created: $directory"
else
  echo "Directory already exists: $directory"
fi
sudo docker-compose pull
sudo docker-compose -f docker-compose.yaml up -d --no-deps --build --remove-orphans -t 0 --scale server=1 server db
echo "Container Count Validation Step"
CONTAINERS=1
running_container=sudo docker ps | grep -i server | awk '{print $1}' | wc -
if [ $CONTAINERS -eq $running_container ]
then
  echo "Active Running containers Validation Pass"
else
  echo "Active Running containers Validation failed"
  exit 1
fi
echo "Started Service succesfully!";