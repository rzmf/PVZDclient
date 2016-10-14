#!/bin/sh
# startup script for CLI app with docker exec (container already started)


if [ -z "${$POLMAN_AODS+x}" ]; then
    echo "Environment Variable POLMAN_AODS ist nicht gesetzt"
    exit 1
else
    PMP_HOME=$(cd $(dirname $$POLMAN_AODS) && pwd)
    mkdir -p $PMP_HOME

fi

cd /opt/PVZDpolman/PolicyManager/bin
sudo -u liveuser ./PMP.sh --help

if [ -z ${POLMAN_AODS+x} ]; then
    echo "Das Policy Store wurde unter $AODS nicht gefunden. Ein neues kann wie folgt erstellt werden:"
    echo "./PMP.sh create"
else
    echo "Ein Policy Store wurde in $$POLMAN_AODS gefunden und wird von PMP automatisch erkannt. Z.B.:"
    echo "./PMP.sh append /home/liveuser/pmp_input.json"
fi

sudo -u user bash