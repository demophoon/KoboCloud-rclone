#!/bin/bash

KC_HOME=$(dirname $0)
ConfigFile=$KC_HOME/kobocloudrc.tmpl

case ${DEBUG:-0} in
    1)
        . $KC_HOME/config_pc.sh
        ;;
    *)
        . $KC_HOME/config_kobo.sh
        ;;
esac
