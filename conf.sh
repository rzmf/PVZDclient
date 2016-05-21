#!/usr/bin/env bash

# configure container
export IMAGENAME="rhoerbe/pvzd-client-app"
export CONTAINERNAME="pvzd-client"
export CONTAINERUSER='user'  # but must start container with root to get pcscd started!
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
# --privileged mapping of usb devices allows a generic configreation without knowing the
# USB device name. Alternativel, devices can be mapped using '--device'
export VOLMAPPING="
    --privileged -v /dev/bus/usb:/dev/bus/usb
    -v $VOLROOT/var/log/:/var/log:Z
    -v $VOLROOT/var/data/:/var/data:Z
    -v /tmp/.X11-unix/:/tmp/.X11-unix:Z
"
export STARTCMD='/start.sh'

# first start: create user/group/host directories
if [ $(id -u) -ne 0 ]; then
    sudo="sudo"
fi
if ! id -u $CONTAINERUSER &>/dev/null; then
    $sudo groupadd -g $CONTAINERUID $CONTAINERUSER
    $sudo adduser -M -g $CONTAINERUSER -u $CONTAINERUID $CONTAINERUSER
fi
