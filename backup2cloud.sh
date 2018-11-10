#!/bin/bash

# Setup keychain to pass passphrase to ssh in cron jobs
[ -z "$HOSTNAME" ] && HOSTNAME="$(uname -n)"
[ -f ~/.keychain/"$HOSTNAME"-sh ] && . ~/.keychain/"$HOSTNAME"-sh

# CONFIG {{{
FROM_FOLDER=$HOME
TO_FOLDER="REMOTE_USER@SERVER:REMOTE_PATH/$HOSTNAME/home/$USER"

FILES_FILE=$XDG_CONFIG_HOME/backups/cloud/bkpHome2Cloud.files
INCLUDE_FILE=$XDG_CONFIG_HOME/backups/cloud/bkpHome2Cloud.include
EXCLUDE_FILE=$XDG_CONFIG_HOME/backups/cloud/bkpHome2Cloud.exclude

LOG_FILE=$XDG_CACHE_HOME/backups/cloud/bkpHome2Cloud.log
# CONFIG }}}

LOG_FILE_DIR=$(dirname "${LOG_FILE}")
mkdir --parents "$LOG_FILE_DIR"

# Because --files-from disables --recursive in --archive it must enable explicitly.
# --ignore-errors => can preserve permissions and owner and group. Otherwise, if no permission (such as a file owned by root), then rsync aborts and --no-owner --no-group --no-perms necessary.
RSYNC_BKP_ARGS="--recursive --archive --hard-links --ignore-errors --modify-window=1 --delete --compress --partial --human-readable --info=progress2 "
SSH_ARGS="-v -P"

# Skip files without read access
cd "$FROM_FOLDER" || exit
exclude_unreadable=$(mktemp)
find . ! -readable -o -type d ! -executable |
sed --expression='s:^\./:/:' --expression='s:[?*\\[]:\\1:g' >> "$exclude_unreadable"

# Backup Local -> Cloud:
rsync $RSYNC_BKP_ARGS --rsh="ssh $SSH_ARGS" --log-file="$LOG_FILE" --include-from="$INCLUDE_FILE" --files-from="$FILES_FILE" --exclude-from="$EXCLUDE_FILE" --exclude-from="$exclude_unreadable" "$FROM_FOLDER" "$TO_FOLDER"

rm "$exclude_unreadable"

exit

#  ex: set foldmethod=marker: 
