#!/bin/bash
 
#Get tatName values from aws instance

#INSTANCE_ID=$(ec2metadata --instance-id)

TAG_NAME=Role

INSTANCE_ID=$(curl -s http://169.254.169.254/latest/meta-data/instance-id/)

REGION=$(curl -s http://169.254.169.254/latest/dynamic/instance-identity/document | grep region | awk -F\" '{print $4}')

# Grab tag value
TAG_VALUE=$(aws ec2 describe-tags --filters "Name=resource-id,Values=$INSTANCE_ID" "Name=key,Values=$TAG_NAME" --region=$REGION --output=text | cut -f5)

echo "$TAG_VALUE"
export FACTER_ROLE="$TAG_VALUE"