#!/bin/bash
echo "Starting Resume Service...";
cd /home/ec2-user/codedeploy/reactive-resume
sudo docker-compose pull
sudo docker-compose -f docker-compose.yaml up -d --no-deps --build --remove-orphans -t 0 --scale app=1 app
echo "Container Count Validation Step"
