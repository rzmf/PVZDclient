#!/usr/bin/env bash

# configure container
export IMAGENAME="rhoerbe/pvzd-client-app"
export CONTAINERNAME="pvzd-client"
export CONTAINERUSER='user'
export CONTAINERUID=7000
export BUILDARGS="
"
export ENVSETTINGS="
    -e DISPLAY=$DISPLAY
"
export NETWORKSETTINGS="
"
export VOLROOT="/tmp"  # container volumes on docker host
# mounting var/lock/.., var/run to get around permission problems when starting non-root
export VOLMAPPING="
    -v $VOLROOT/var/log/:/var/log:Z
    -v $VOLROOT/var/data/:/var/data:Z
    -v /tmp/.X11-unix/:/tmp/.X11-unix
"
export STARTCMD='/start.sh'

# first start: create user/group/host directories
if ! id -u $CONTAINERUSER &>/dev/null; then
    groupadd -g $CONTAINERUID $CONTAINERUSER
    adduser -M -g $CONTAINERUSER -u $CONTAINERUID $CONTAINERUSER
fi
