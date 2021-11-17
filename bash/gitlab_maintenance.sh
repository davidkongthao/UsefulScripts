#!/bin/bash

sudo cp -f /etc/gitlab/gitlab-secrets.json ~/gitlab_backups
GITLAB_SECRETS_FILE=~/gitlab_backups/gitlab-secrets.json
if test -f $GITLAB_SECRETS_FILE; 
then
        echo "Successfully backed up current gitlab-secrets.json file to ~/gitlab_backups."
        secrets_backed_up=1
else
        echo "Secrets file was not successfully backed up."
        secrets_backed_up=0
fi
sudo cp -f /etc/gitlab/gitlab.rb ~/gitlab_backups
GITLAB_RB_FILE=~/gitlab_backups/gitlab.rb
if test -f $GITLAB_RB_FILE; 
then
        echo "Successfully backed up current gitlab.rb file to ~/gitlab_backups."
        rb_backed_up=1
else
        echo "Ruby file was not successfully backed up."
        rb_backed_up=0
fi

if (( $rb_backed_up == 1 && $secrets_backed_up == 1))
then
        sudo gitlab-rake gitlab:check
        sudo gitlab-rake gitlab:doctor:secrets
        sudo apt-get upgrade gitlab-ee -y
        echo "Upgrade successful."
        sudo cp -f ~/gitlab_backups/gitlab-secrets.json /etc/gitlab
        echo "Copied gitlab-secrets.json over to /etc/gitlab."
        sudo cp -f ~/gitlab_backups/gitlab.rb /etc/gitlab
        echo "Copied gitlab.rb over to /etc/gitlab."
        sudo gitlab-ctl reconfigure
        sudo gitlab-ctl restart
else
        echo "Backup of gitlab-secrets.json and ruby file not successful. Exiting."
fi
