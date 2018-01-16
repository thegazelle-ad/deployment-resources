#!/bin/bash

# Go to the main repo
cd "$HOME/server"
if [ $? -ne 0 ]
then
  echo "couldn't find folder" >&2
  exit 1
fi

# Tell Slack that we're starting deployment
if [ "$GAZELLE_ENV" == "staging" ]
then
  node "$HOME/slack-deployment-bot/index.js" "Starting deployment to staging.thegazelle.org, and staging.admin.thegazelle.org"
fi
if [ "$GAZELLE_ENV" == "production" ]
then
  node "$HOME/slack-deployment-bot/index.js" "Starting deployment to www.thegazelle.org, and admin.thegazelle.org"
fi
if [ $? -ne 0 ]
  then
    echo "Error posting to slack" >&2
    exit 1
fi

# Pull the latest source
git pull
if [ $? -ne 0 ]
then
  echo "Git pull failed" >&2
  node "$HOME/slack-deployment-bot/index.js" "Deployment failed during git pull"
  exit 1
fi

# Install the latest dependencies
npm install
if [ $? -ne 0 ]
then
  echo "npm install failed" >&2
  node "$HOME/slack-deployment-bot/index.js" "Deployment failed during npm install"
  exit 1
fi

# Build the new source
if [ "$GAZELLE_ENV" == "staging" ]
then
  npm run build:staging
fi
if [ "$GAZELLE_ENV" == "production" ]
then
  npm run build:production
fi
if [ $? -ne 0 ]
then
  echo "build failed" >&2
  node "$HOME/slack-deployment-bot/index.js" "Deployment failed during build"
  exit 1
fi

# Restart the server so it runs the new code
forever restart server
if [ $? -ne 0 ]
then
  echo "server restart failed" >&2
  node "$HOME/slack-deployment-bot/index.js" "Deployment failed during server restart"
  exit 1
fi

# Announce the deployment success
cd ..
if [ "$GAZELLE_ENV" == "staging" ]
then
  node "$HOME/slack-deployment-bot/index.js" "staging.thegazelle.org and staging.admin.thegazelle.org were deployed successfully!"
fi
if [ "$GAZELLE_ENV" == "production" ]
then
  node "$HOME/slack-deployment-bot/index.js" "www.thegazelle.org and admin.thegazelle.org were deployed successfully!"
fi
if [ $? -ne 0 ]
  then
    echo "Error posting to slack" >&2
    exit 1
fi
echo "Deployed successfully"
