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

if [ $(id -u) -ne 0 ]; then
    logger -p local0.info  "Need to be root to start pcscd. No smartcard service available now."
    ./PAtool.sh --help
fi

logger -p local0.info "Starting Smartcard Service"
$sudo /usr/sbin/pcscd

# start mocca and wait a bit for it to come up
/start_mocca.sh &
sleep 7

cd /opt/PVZDpolman/PolicyManager/bin
./PAtool.sh --help
logger -p local0.info "Starting PAtoolGui"
./PAtoolGui.sh
echo "bash: exit to terminate container; scripts in local directory to start pvzd tools."
bash