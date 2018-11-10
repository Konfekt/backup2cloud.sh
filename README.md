This is a (`POSIX` compliant) shell script for `UNIX` based operating systems, such as `Linux`, `Free BSD` and `MacOS`, that backs up

- all those files and folders in the home folder `~/` that are listed in `./bkpHome2Cloud.files`,
- except those listed in `./bkpHome2Cloud.exclude`

via `rsync` to a remote server.

# Installation

1. Clone this repository, for example into `~/Downloads`
    ```sh
    cd ~/Downloads/
    git clone https://github.com/konfekt/backup2cloud.sh
    ````
0. Copy `backup2cloud.sh` into a convenient folder, for example, `~/bin`
    ```sh
    cp ~/Downloads/backup2cloud.sh/backup2cloud.sh ~/bin/
    ```
0. Copy `./bkpHome2Cloud.files` and  `./bkpHome2Cloud.exclude` to `$XDG_CONFIG_HOME/backups/cloud` by
    ```sh
    cd ~/Downloads/backup2cloud.sh
    mkdir ${XDG_CONFIG_HOME:-${HOME}/.config}/backups/cloud/
    cp ./bkpHome2Cloud.files ./bkpHome2Cloud.exclude ${XDG_CONFIG_HOME:-${HOME}/.config}/backups/cloud/
    ```
    and adapt the files and folders listed in them to those that suit you!
0. Inside `backup2cloud.sh`, replace

    - `REMOTE_USER` by your user name to log in to the `rsync` server
    - `SERVER` by the address of the `rsync` server, and
    - `REMOTE_PATH` by the path of your folder on the `rsync` server.

# Suggestions

The script supposes that the configuration files `./bkpHome2Cloud.files` and  `./bkpHome2Cloud.exclude` reside in `$XDG_CONFIG_HOME/backups/cloud`.
If you choose another path, adapt accordingly.

Have a look at <https://konfekt.github.io/blog/2016/12/11/sane-cron-setup> how to schedule a daily backup ensuring that it is only run when the computer is online.
