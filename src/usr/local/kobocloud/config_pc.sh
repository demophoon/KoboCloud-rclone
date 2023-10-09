#!/bin/sh
Logs=/tmp/KoboCloud
Lib=/tmp/KoboCloud/Library
SD=/tmp/KoboCloud/sd
UserConfig=/tmp/KoboCloud/kobocloudrc
UserConfig=./kobocloudrc.tmpl
RCloneConfig=~/.config/rclone/rclone.conf
Dt="date +%Y-%m-%d_%H:%M:%S"
RCLONEDIR="/usr/bin/"
RCLONE="${RCLONEDIR}rclone"
PLATFORM=PC
