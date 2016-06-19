#!/bin/bash
# startup script used in entrypoint of the docker container

# format debug output if using bash -x
export PS4='+(${BASH_SOURCE}:${LINENO}): ${FUNCNAME[0]:+${FUNCNAME[0]}(): }'

if [ $(id -u) -ne 0 ]; then
    logger -p local0.info  "Need to be root to start pcscd. No smartcard service available now."
    ./PAtool.sh --help
    bash
fi
logger -p local0.info "Starting Smartcard Service"
pcscd

logger -p local0.info "MOCCA Webstart (lokale Bürgerkartenumgebung)"
gnome-terminal --title="MOCCA BKU" --zoom=0.7 --geometry=80x10 --hide-menubar -e "javaws http://webstart.buergerkarte.at/mocca/webstart/mocca.jnlp"
sleep 5

cd /opt/PVZDpolman/PolicyManager/bin
sudo -u liveuser ./PAtool.sh --help
logger -p local0.info "Starting PAtoolGui"
sudo -u liveuser ./PAtoolGui.sh
echo "bash: exit to terminate container; scripts in local directory to start pvzd tools."
sudo -u liveuser bash