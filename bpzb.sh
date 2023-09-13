#!/bin/bash
# For use this script you need to install jq "sudo apt install jq -y"
read -p "Enter your profile " aws_profile
read -p "Enter your mfa name " mfa_name
read -p "Enter your mfa token-code " mfa_token_code

credentials=$(aws sts assume-role --role-arn arn:aws:iam::546240550610:role/Admins --role-session-name tf --serial-number arn:aws:iam::546240550610:mfa/$mfa_name --token-code $mfa_token_code --profile $aws_profile)
#export AWS_PROFILE=$aws_profile
export AWS_ACCESS_KEY_ID=$(echo $credentials | jq '.Credentials.AccessKeyId')
export AWS_SECRET_ACCESS_KEY=$(echo $credentials | jq '.Credentials.SecretAccessKey')
export AWS_SESSION_TOKEN=$(echo $credentials | jq '.Credentials.SessionToken')


