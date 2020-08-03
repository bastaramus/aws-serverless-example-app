#!/bin/bash

if [ ! -z $1 ]
then
	echo $1
	profile_name="$1"
	pfarg="--profile ${profile_name}"
fi

export AWS_ACCESS_KEY_ID=$(aws configure ${pfarg} get aws_access_key_id)
export AWS_SECRET_ACCESS_KEY=$(aws configure ${pfarg} get aws_secret_access_key)
export AWS_DEFAULT_REGION=eu-central-1

_PS1="[${profile_name}] ${PS1}"
PS1="${_PS1}"

exec $SHELL -i