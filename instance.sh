#!/bin/bash

# Variables
KEY_PAIR_NAME="rohit"
SECURITY_GROUP_NAME="EC2-sg"
INSTANCE_NAME="ubuntuinstance"
AMI_ID="ami-0fc5d935ebf8bc3bc"
INSTANCE_TYPE="t2.micro"

# Create Key Pair
echo "Creating Key Pair..."
aws ec2 create-key-pair --key-name "$KEY_PAIR_NAME" --query 'KeyMaterial' --output text > "$KEY_PAIR_NAME.pem"
chmod 400 "$KEY_PAIR_NAME.pem"
echo "Key Pair created: $KEY_PAIR_NAME.pem"

# Create Security Group
echo "Creating Security Group..."
GROUP_ID=$(aws ec2 create-security-group --group-name "$SECURITY_GROUP_NAME" --description "Security Group for RDS Connect Instance" --query 'GroupId' --output text)
echo "Security Group created: $SECURITY_GROUP_NAME (Group ID: $GROUP_ID)"

# Add Inbound and Outbound Rules to Security Group
aws ec2 authorize-security-group-ingress --group-id "$GROUP_ID" --protocol tcp --port 22 --cidr 0.0.0.0/0
aws ec2 authorize-security-group-egress --group-id "$GROUP_ID" --protocol all --cidr 0.0.0.0/0


# Launch EC2 Instance with User Data
echo "Creating EC2 Instance..."
INSTANCE_ID=$(aws ec2 run-instances \
  --image-id "$AMI_ID" \
  --instance-type "$INSTANCE_TYPE" \
  --key-name "$KEY_PAIR_NAME" \
  --security-group-ids "$GROUP_ID" \
  --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$INSTANCE_NAME}]" \
  --query 'Instances[0].InstanceId' \
  --output text)

# Wait for the instance to be in a running state
echo "Waiting for the instance to be in a running state..."
aws ec2 wait instance-running --instance-ids "$INSTANCE_ID"

# Get the public IP address of the instance
PUBLIC_IP=$(aws ec2 describe-instances --instance-ids "$INSTANCE_ID" --query 'Reservations[0].Instances[0].PublicIpAddress' --output text)
echo "EC2 Instance created: $INSTANCE_ID"
echo "Public IP address: $PUBLIC_IP"

echo "Setup complete!"