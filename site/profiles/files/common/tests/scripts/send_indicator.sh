#!/bin/bash
IS_BOOTSTRAP=$1
GO_USERNAME=$2
GO_PASSWORD=$3
GO_SERVER_URL=$4
GO_PIPELINE_NAME=$5
GO_PIPELINE_COUNTER=$6
GO_STAGE_NAME=$7
GO_STAGE_COUNTER=$8
GO_JOB_NAME=$9

if [ $IS_BOOTSTRAP == 'true' ]; then
  exit 0
else
  echo 'indicator.txt content:'
  cat /usr/local/serverspec/indicator.txt
  curl --insecure "${GO_SERVER_URL}properties/$GO_PIPELINE_NAME/$GO_PIPELINE_COUNTER/$GO_STAGE_NAME/$GO_STAGE_COUNTER/$GO_JOB_NAME/indicator" -u "$GO_USERNAME:$GO_PASSWORD" -X POST -d "value=$(head -1 /usr/local/serverspec/indicator.txt)"
fi
