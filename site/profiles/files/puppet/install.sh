#!/bin/bash
 
rpm -ivh http://yum.puppetlabs.com/puppetlabs-release-el-7.noarch.rpm
yum --enablerepo=puppetlabs-devel install puppet -y

yum install ntp -y
service ntpd start
chkconfig ntpd on

puppet config set server puppet.gcio.cloud --section agent
puppet config set environment production --section agent

service puppet start

chkconfig puppet on

yum update -y

#install awscli 
curl -O https://bootstrap.pypa.io/get-pip.py
python2.7 get-pip.py
pip install awscli

#this scripts gets Role and source it as fact

TAG_NAME=server_role

INSTANCE_ID=$(curl -s http://169.254.169.254/latest/meta-data/instance-id/)

REGION=$(curl -s http://169.254.169.254/latest/dynamic/instance-identity/document | grep region | awk -F\" '{print $4}')

# Grab tag value
TAG_VALUE=$(aws ec2 describe-tags --filters "Name=resource-id,Values=$INSTANCE_ID" "Name=key,Values=$TAG_NAME" --region=$REGION --output=text | cut -f5)

export FACTER_SERVER_ROLE="$TAG_VALUE"

#echo "sleeping for two minutes to prapare for puppet agent run"
sleep 2m

puppet agent -t

