#!/bin/bash

cd /home/gazelle/gazelle-production
if [ $? -ne 0 ]
  then
    echo "couldn't find folder" >&2
    exit 1
fi
node ../slack-deployment-bot/index.js "Starting deployment to www.thegazelle.org, and admin.thegazelle.org"
if [ $? -ne 0 ]
  then
    echo "Error posting to slack" >&2
    exit 1
fi
git pull
if [ $? -ne 0 ]
  then
    echo "Git pull failed" >&2
    exit 1
fi
npm install
if [ $? -ne 0 ]
  then
    echo "npm install failed" >&2
    exit 1
fi
npm run build-production
if [ $? -ne 0 ]
  then
    echo "build failed" >&2
    exit 1
fi
forever restart prod
if [ $? -ne 0 ]
  then
    echo "server restart failed" >&2
    exit 1
fi
cd ..
node ./slack-deployment-bot/index.js "The production sites www.thegazelle.org and admin.thegazelle.org were deployed successfully!"
if [ $? -ne 0 ]
  then
    echo "Error posting to slack" >&2
    exit 1
fi
echo "www.thegazelle.org and admin.thegazelle.org updated successfully"
