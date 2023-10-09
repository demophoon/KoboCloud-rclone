#!/bin/bash

KC_HOME=$(dirname $0)
ConfigFile=$KC_HOME/kobocloudrc.tmpl

# Kobo Configs
Logs=/mnt/onboard/.add/kobocloud
Lib=/mnt/onboard/.add/kobocloud/Library
SD=/mnt/sd/kobocloud
UserConfig=/mnt/onboard/.add/kobocloud/kobocloudrc
RCloneConfig=/mnt/onboard/.add/kobocloud/rclone.conf
Dt="date +%Y-%m-%d_%H:%M:%S"
RCLONEDIR="/mnt/onboard/.add/kobocloud/bin/"
RCLONE="${RCLONEDIR}rclone"
PLATFORM=Kobo

# PC Configs
if [ ${DEBUG:-0} = 1 ]; then
    Logs=/tmp/KoboCloud
    Lib=/tmp/KoboCloud/Library
    SD=/tmp/KoboCloud/sd
    UserConfig=./kobocloudrc.tmpl
    RCloneConfig=~/.config/rclone/rclone.conf
    Dt="date +%Y-%m-%d_%H:%M:%S"
    RCLONEDIR="/usr/bin/"
    RCLONE="$(which rclone)"
    PLATFORM=PC
fi
