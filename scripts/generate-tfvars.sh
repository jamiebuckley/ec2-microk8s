#!/bin/bash

export MY_IP=$(curl inet-ip.info)
export ACCOUNT_ID=$(aws sts get-caller-identity --query 'Account' --output text)
export AMI_ID=$( aws ec2 describe-images --owners $ACCOUNT_ID --filters 'Name=name,Values=ubuntu-microk8s-*' --query 'Images | reverse(sort_by(@, &CreationDate)) | [0].ImageId' --output text)
export SUBNET_ID=$(aws ec2 describe-subnets --filters "Name=tag:Name,Values=default-subnet" --query "Subnets[0].SubnetId" --output text)
cat terraform.tfvars.temp | envsubst > terraform.tfvars