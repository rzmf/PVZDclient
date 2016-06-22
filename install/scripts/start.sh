#!/bin/bash
# startup script used in entrypoint of the docker container

# format debug output if using bash -x
export PS4='+(${BASH_SOURCE}:${LINENO}): ${FUNCNAME[0]:+${FUNCNAME[0]}(): }'

if [ $(id -u) -eq 0 ]; then
    echo "do not run this script as root"
    exit 1
else
    sudo="sudo"
fi

logger -p local0.info "Starting Smartcard Service"
$sudo /usr/sbin/pcscd

# start mocca and wait a bit for it to come up
/start_mocca.sh &
sleep 10

cd /opt/PVZDpolman/PolicyManager/bin
logger -p local0.info "Starting PAtoolGui"
./PAtoolGui.sh
