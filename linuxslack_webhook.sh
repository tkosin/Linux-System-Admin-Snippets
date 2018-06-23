#!/bin/bash

# Author: Yod (theerayooth.k@facgure.com)
# This script is to monitor and capture the data from login user 
# and notify to Slack channel from /etc/bash.bashrc or /etc/bashprofile

SLACK_CHANNEL_WEBHOOK=https://hooks.slack.com/services/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FaMqQ3STysp
SLACK_CHANNEL_NAME="#fg-erp"
HOSTNAME=`hostname`
CWD=`pwd`
LOGIN_DATETIME=$(date +%d/%m/%Y" "%H:%M:%S)

# Default slack color and reactions
SLACK_COLOR="#36a64f"
SLACK_ICON=":grinning:"

if [ $(id -u) == 0 ]; then
	SLACK_COLOR="#dd4b39"
	SLACK_ICON=":face_with_monocle:"
fi

# Create Slack's payload 
slack_post() {
	cat <<EOF
payload={
	"channel": "$SLACK_CHANNEL_NAME", 
	"username": "System Watchdog", 
	"text": "Hey guys! `whoami` logged in to $HOSTNAME and try to do something $SLACK_ICON",
	"attachments": [
		{
			"author_name": "Captured by Facgure Developer",
			"title": "Login information for the server",
			"title_link": "https://erpdev.facgure.com",
			"color": "$SLACK_COLOR",
			"fields": [
			{
				"title": "User",
                "value": "`whoami`",
                "short": true
            }, {
               "title": "Datetime",
               "value": "$LOGIN_DATETIME",
               "short": true
            }, {
               "title": "Landing path",
               "value": "$CWD",
               "short": true
            }, {
               "title": "Server Name",
               "value": "$HOSTNAME",
               "short": true
            }, {
				"title": "Current Session(s)",
				"value": "`w`",
				"short": false
	 		}]
		}
	]
}
EOF
}

# Notify to Slack
curl -X POST --data-urlencode "$(slack_post)" $SLACK_CHANNEL_WEBHOOK >> /dev/null 2>> /dev/null 
