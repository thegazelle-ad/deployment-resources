# deployment-resources

The repo to apply source control to the resources we purely use for deployment


## Installation

No installation is needed

## Setup environment variables

While no installation is needed, we do need to setup some environment variables for some paths that are needed by the scripts. If you are doing this for development you can either do `export` in your current bash session, or prefix your running of the script you're testing with the needed environment variables like `ENV=SOME_VALUE ./script_to_test.sh`.

When deploying you're probably going to want to add these environment variables to your `.bashrc` file as follows:

```bash
export SLACK_DEPLOYMENT_BOT_DIRECTORY=~/path/to/slack-deployment-bot
export DEPLOYMENT_RESOURCES_DIRECTORY=~/path/to/deployment-resources
export SERVER_DIRECTORY=~/path/to/server
```

> NOTE: It is important that you don't add trailing forward slashes to your paths as it is assumed there aren't any
