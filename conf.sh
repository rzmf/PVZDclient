#!/usr/bin/env bash

# configure container
export IMAGENAME="rhoerbe/pvzd-client-app"
export CONTAINERNAME="pvzd-client"
if [[ "$HOSTNAME" == "kalypso" ]]; then
    export CONTAINERUSER='r2h2'  # devl
else
    export CONTAINERUSER='liveuser'  # livecd; but must start container with root to get pcscd started!
fi
export CONTAINERUID=1000  # same uid as liver user on docker host
export BUILDARGS="
    --build-arg USERNAME=$CONTAINERUSER
    --build-arg UID=$CONTAINERUID
"
export ENVSETTINGS="
    -e DISPLAY=$DISPLAY
"
export NETWORKSETTINGS="
"
export VOLROOT="/tmp"  # container volumes on docker host

# mounting var/lock/.., var/run to get around permission problems when starting non-root
# --privileged mapping of usb devices allows a generic configuration without knowing the
# USB device name. Alternatively, specific devices can be mapped using '--device'
export VOLMAPPING="
    --privileged -v /dev/bus/usb:/dev/bus/usb
    -v /tmp/.X11-unix/:/tmp/.X11-unix:Z
    -v $VOLROOT/home/liveuser/:/home/liveuser:Z
    -v $VOLROOT/tmp/pvzd-client-status/:/var/status:Z
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
