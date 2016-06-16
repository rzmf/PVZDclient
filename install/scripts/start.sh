#!/bin/sh
# startup script used in entrypoint of the docker container

echo "start" > /var/status/$(date +%T)-pcscd
if [ $(id -u) -ne 0 ]; then
    echo "failed (not root)" > /var/status/$(date +%T)-pcscd
    echo "need to be root to start pcscd. No smartcard service available now."
    ./PAtool.sh --help
    bash
fi
logger -p local0.info "Starting Smartcard Service"
pcscd
echo "done" > /var/status$(date +%T)-pcscd

echo "start" > /var/status/$(date +%T)-mocca
logger -p local0.info "MOCCA Webstart (lokale Bürgerkartenumgebung)"
gnome-terminal --hide-menubar -e "javaws http://webstart.buergerkarte.at/mocca/webstart/mocca.jnlp"
sleep 5

cd /opt/PVZDpolman/PolicyManager/bin
sudo -u liveuser ./PAtool.sh --help
echo "starting" > /var/status/$(date +%T)-PAtoolGui
logger -p local0.info "Starting PAtoolGui"
sudo -u liveuser ./PAtoolGui.sh
echo "bash: exit to terminate container; scripts in local directory to start pvzd tools."
sudo -u user bash