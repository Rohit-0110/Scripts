#!/bin/bash
cd /home/ec2-user/codedeploy/reactive-resume
echo "Stopping SERVICE";
cd /home/ec2-user/codedeploy/reactive-resume
sudo docker-compose stop -t 60 server
echo "Successfully Stopped REACTIVE-RESUME SERVICE!";