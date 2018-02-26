# deployment-resources

The repo to apply source control to the resources we purely use for deployment


## Installation

```bash
npm install
```

## Setup environment variables

We need to setup some environment variables for some paths and environment information that are needed by the scripts. If you are doing this for development you can either do `export` in your current bash session, or prefix your running of the script you're testing with the needed environment variables like `ENV=SOME_VALUE ./script_to_test.sh`.

When deploying you're probably going to want to add these environment variables to your `.bashrc` file as follows:

```bash
export SLACK_DEPLOYMENT_BOT_DIRECTORY=~/path/to/slack-deployment-bot
export DEPLOYMENT_RESOURCES_DIRECTORY=~/path/to/deployment-resources
export SERVER_DIRECTORY=~/path/to/server
# Replace ENVIRONMENT with "staging" if it's the staging server or "production" for the production server
export GAZELLE_ENV=ENVIRONMENT
# The value of this is probably root
export DATABASE_USER=<user_name>
export DATABASE_PASSWORD=<password>
# The value of this is probably 'the__gazelle'
export DATABASE_NAME=<name_of_gazelle_database>
```

> NOTE: It is important that you don't add trailing forward slashes to your paths as it is assumed there aren't any

If you're doing all the setup of a server in one go, remember to restart your bash session or resource your `.bashrc` for these environment variables to actually be exported.

## Setup automatic database backups

To backup the database, a script has been written that will automatically dump the database and upload it to the "Timestamped Ghost Dumps" folder in the [Gazelle Engineering Google Drive](https://drive.google.com/drive/u/1/folders/0B5ceCeOuBd1tVWNSX2k2RVUtOFk). To set it up, you first have to get the credentials that give you the rights to programatically access the drive. This is very simple as you just run

`./scripts/getGoogleApiOAuthToken.sh`

and follow the instructions given in the terminal to get and store an OAuth token on your computer. It will be stored in ~/.credentials. You should now be ready to backup the database. First check that it runs correctly by running

`./scripts/backupDatabase.sh`

and if everything works you should now be able to setup Cron to regularly update the database automatically.

To setup Cron run

`crontab -e`

and open it in your favourite editor.
Below all the comments you can now add in the line

`0 2 * * Thu /bin/bash -ic '/path/to/deployment-resources/scripts/backup_database.sh'`

And Cron should be setup to update your database every Thursday morning at 2 AM. Remember to check it actually does this. You can also test it by temporarily setting the time fields to `* * * * *` to have it backup once a minute for temporary testing.
And remember to change the `/path/to/deployment-resources` to your actual path to the repository.

## Setup memory monitoring

Very similarly to above, we setup a cron job, as long as you have setup the environment variables as described at the top it should be as easy as adding the following to your crontab

```
* * * * * /bin/bash -ic "/path/to/server/deployment-resources/scripts/check_free_memory.sh error-logging 250"
```

Where you can replace `error-logging` (the channel to post to) and `250` (the memory limit to check for) with whatever values suit you, but those are our current ones as this README is being written.
