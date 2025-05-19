#!/bin/bash
MOUNT_POINT="$HOME/s3"
BUCKET_NAME="lumericalpsi"
AWS_ACCESS_KEY=""
AWS_SECRET_KEY=""
CREDENTIALS_FILE="/etc/passwd-s3fs"

# Store AWS credentials
echo "Configuring AWS credentials..."
echo "${AWS_ACCESS_KEY}:${AWS_SECRET_KEY}" > ${CREDENTIALS_FILE}
sudo chmod 0640 ${CREDENTIALS_FILE}
sudo chgrp "domain users" ${CREDENTIALS_FILE}

if [ ! -d "$MOUNT_POINT" ]; then
    echo "Creating mount point at ${MOUNT_POINT}..."
    mkdir -p ${MOUNT_POINT}
fi

# MOUNT S3 BUCKET
echo "Mounting S3 bucket..."
s3fs ${BUCKET_NAME} ${MOUNT_POINT} -o passwd_file=${CREDENTIALS_FILE}

# VERIFY
if mount | grep -q "$MOUNT_POINT"; then
    echo "S3 bucket mounted successfully at ${MOUNT_POINT}"
else
    echo "S3 bucket is not mounted"
fi


