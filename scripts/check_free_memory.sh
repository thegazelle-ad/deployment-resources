#!/bin/bash

MEMORY_LIMIT=$1

MEMORY_FREE=$(free -m | grep Mem | awk '{print $4}')

if [ "$MEMORY_FREE" -le "$MEMORY_LIMIT" ];
then
  TOP_MEMORY_CONSUMING_PROCESSES=$(ps -eo pid,ppid,cmd,%mem,%cpu --sort=-%mem | head)
  ALERT_MESSAGE="The ${GAZELLE_ENV} server only has ${MEMORY_FREE}MB free in main memory.
The top consuming processes are:
${TOP_MEMORY_CONSUMING_PROCESSES}"
  node "$SLACK_DEPLOYMENT_BOT_DIRECTORY/index.js" error-logging "$ALERT_MESSAGE"
fi;
