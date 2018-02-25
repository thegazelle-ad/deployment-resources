#!/bin/bash

IS_NUM_REGEX="^[0-9]+$"

if ! [[ $# -eq 2 && $2 =~ $IS_NUM_REGEX ]];
then
  echo "Incorrect usage"
  echo "Correct usage: ./check_free_memory.sh <slack_channel_to_post_to> <memory_limit_to_check>"
  exit 1
fi

SLACK_CHANNEL=$1
MEMORY_LIMIT=$2

MEMORY_FREE=$(free -m | grep Mem | awk '{print $4}')

if [ "$MEMORY_FREE" -le "$MEMORY_LIMIT" ];
then
  TOP_MEMORY_CONSUMING_PROCESSES=$(ps -eo pid,ppid,cmd,%mem,%cpu --sort=-%mem | head)
  ALERT_MESSAGE="The ${GAZELLE_ENV} server only has ${MEMORY_FREE}MB free in main memory.
The top consuming processes are:
${TOP_MEMORY_CONSUMING_PROCESSES}"
  $NODE_PATH "$SLACK_DEPLOYMENT_BOT_DIRECTORY/index.js" "$SLACK_CHANNEL" "$ALERT_MESSAGE"
  if [[ $? -ne 0 ]];
  then
    echo "Slack Deployment Bot failed"
    exit 1
  fi
fi
