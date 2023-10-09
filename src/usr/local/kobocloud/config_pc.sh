#!/bin/sh
Logs=/tmp/KoboCloud
Lib=/tmp/KoboCloud/Library
SD=/tmp/KoboCloud/sd
UserConfig=./kobocloudrc.tmpl
RCloneConfig=~/.config/rclone/rclone.conf
Dt="date +%Y-%m-%d_%H:%M:%S"
RCLONEDIR="/usr/bin/"
RCLONE="$(which rclone)"
PLATFORM=PC
