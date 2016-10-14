#!/usr/bin/env bash

DOCKERVOL_ROOT='/docker_volumes'

# configure container
export IMAGENAME="rhoerbe/pvzd-client-app"
export CONTAINERNAME="pvzd-client"
#if [[ "$HOSTNAME" == "kalypso" ]]; then
#    export CONTAINERUSER='r2h2'  # devl
#else
#    export CONTAINERUSER='liveuser'  # livecd; but must start container with root to get pcscd started!
#fi
export CONTAINERUSER='liveuser'  # livecd; but must start container with root to get pcscd started!
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
export VOLROOT="$DOCKERVOL_ROOT/$CONTAINERNAME"  # test env; use different value on LiveCD

# mounting var/lock/.., var/run to get around permission problems when starting non-root
# --privileged mapping of usb devices allows a generic configuration without knowing the
# USB device name. Alternatively, specific devices can be mapped using '--device'
export VOLMAPPING="
    --privileged -v /dev/bus/usb:/dev/bus/usb
    -v /tmp/.X11-unix/:/tmp/.X11-unix:Z
    -v $VOLROOT/home/liveuser/:/home/liveuser:Z
"
export STARTCMD='/start.sh'

# first start: create user/group/host directories
if [ $(id -u) -ne 0 ]; then
    sudo="sudo"
fi
if ! id -u $CONTAINERUSER &>/dev/null; then
    case ${OSTYPE//[0-9.]/} in
        darwin) # OSX
            $sudo sudo dseditgroup -o create -i $CONTAINERUID $CONTAINERUSER
            $sudo dscl . create /Users/$CONTAINERUSER UniqueID $CONTAINERUID
            $sudo dscl . create /Users/$CONTAINERUSER PrimaryGroupID $CONTAINERUID
            ;;
        linux-gnu) #CentOs
            $sudo groupadd -g $CONTAINERUID $CONTAINERUSER
            $sudo adduser -M --gid $CONTAINERUID --comment "" --uid $CONTAINERUID $CONTAINERUSER
            ;;
        linux)  #Debian
            $sudo groupadd -g $CONTAINERUID $CONTAINERUSER
            $sudo adduser --gid $CONTAINERUID --no-create-home --disabled-password --gecos "" --uid $CONTAINERUID $CONTAINERUSER
            ;;
        *)
            echo "do not know how to add user/group for OS ${OSTYPE}"
            ;;
    esac
fi
