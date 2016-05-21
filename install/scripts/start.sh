#!/bin/sh
# startup script used in entrypoint of the docker container

if [ $(id -u) -ne 0 ]; then
    echo "need to be root to start pcscd. No smartcard service available now."
    ./PAtool.sh --help
    bash
fi
pcscd

sudo -u user javaws "http://webstart.buergerkarte.at/mocca/webstart/mocca.jnlp" &
sleep 2

cd /opt/PVZDpolman/PolicyManager/bin
sudo -u user ./PAtool.sh --help
sudo -u user ./PAtoolGui.sh &
bash