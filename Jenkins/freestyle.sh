#!/bin/bash

# Get the current working directory
path=$(pwd)
echo "Current path: $path"

# Echo service name and branch for visibility
echo "Service Name: $SERVICE_NAME"
echo "Service Branch: $SERVICE_BRANCH"

S3_BUCKET="wooak-builds"  # your_bucketname
APPLICATION_NAME="wooak"   # codedeploy_application_name

#List Files:

ls -lrtha

# Set service directory
SERVICE_DIR=$SERVICE_NAME

# Check if a deployment is already in progress
deployment_check=$(aws deploy list-deployments --application-name "$APPLICATION_NAME" --deployment-group-name "$SERVICE_NAME" --include-only-statuses InProgress Created Queued | jq -r '.deployments | length')

if [ "$deployment_check" -ne 0 ]; then
   echo "Deployment in progress. Please wait."
   exit 1
fi

# Navigate to service directory
# cd "$SERVICE_DIR" || { echo "Directory $SERVICE_DIR not found. Exiting..."; exit 1; }

# Stash, checkout, and pull the latest code from the specified branch
git stash && git checkout "$SERVICE_BRANCH" && git pull origin "$SERVICE_BRANCH"
if [ $? -ne 0 ]; then
   echo "!!!! FATAL ERROR! Aborting... !!!!"
   echo "REASON: GIT PULL FAILED IN SERVICE REPO"
   exit 1
fi

# Get the latest Git commit hash
GIT_HEAD_HASH_CODE=$(git rev-parse --short HEAD)

# Show commit details
echo "Deploying commit: $GIT_HEAD_HASH_CODE"
git show "$GIT_HEAD_HASH_CODE"

# Create artifact directory and prepare the build
BUILD_FILE="build.$SERVICE_NAME.${GIT_HEAD_HASH_CODE}.zip"
rm -rf "build.$SERVICE_NAME"
mkdir "build.$SERVICE_NAME"

# Copy Required Files
cp ./codedeploy/docker-compose.yaml   ./build.$SERVICE_NAME/docker-compose.yaml
cp ./codedeploy/appspec.yml ./build.$SERVICE_NAME/appspec.yml
cp -R ./codedeploy/script ./build.$SERVICE_NAME/script

# Docker build and push
Tag=${GIT_HEAD_HASH_CODE}
RepoURI="182307324535.dkr.ecr.ap-south-1.amazonaws.com/wooak"

#Docker Login
#sudo cat "/root/password.txt" | sudo docker login -u glyphhq --password-stdin 
aws ecr get-login-password --region ap-south-1 | sudo docker login --username AWS --password-stdin 182307324535.dkr.ecr.ap-south-1.amazonaws.com

# Build Docker image
sudo docker build -t "$RepoURI:$Tag" -f ./Dockerfile .
if [ $? -gt 0 ]; then
   echo "Docker build failed for $RepoURI:$Tag"
   exit 1
fi

# Tag the Docker image
sudo docker tag "$RepoURI:$Tag" "$RepoURI:$Tag"
if [ $? -gt 0 ]; then
   echo "Docker tagging failed for $RepoURI:$Tag"
   exit 1
fi

# Push Docker image to DockerHub
sudo docker push "$RepoURI:$Tag"
if [ $? -gt 0 ]; then
   echo "Docker push failed for $RepoURI:$Tag"
   exit 1
fi

# Modify docker-compose.yaml with the new image tag and repo URI
sed -i "s,tag,$Tag,g" ./build.$SERVICE_NAME/docker-compose.yaml
sed -i "s,repo,$RepoURI,g" ./build.$SERVICE_NAME/docker-compose.yaml

# Zip the build directory
sudo zip -r "$BUILD_FILE" build.$SERVICE_NAME
sudo chmod 444 "$BUILD_FILE"

# Upload the zip file to S3
aws s3 cp "$PWD/$BUILD_FILE" "s3://$S3_BUCKET/$BUILD_FILE"
if [ $? -gt 0 ]; then
   echo "Failed to upload to S3"
   exit 1
fi

# Trigger the deployment via AWS CodeDeploy
aws deploy create-deployment \
  --application-name "$APPLICATION_NAME" \
  --deployment-group-name "$SERVICE_NAME" \
  --deployment-config-name CodeDeployDefault.OneAtATime \
  --description "$SERVICE_NAME deployment for tag $GIT_HEAD_HASH_CODE" \
  --s3-location bucket="$S3_BUCKET",bundleType=zip,key="$BUILD_FILE"

# Check deployment status
if [ $? -eq 0 ]; then
  echo "Deployment initiated successfully."
else
  echo "Failed to create deployment."
  exit 1
fi
