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

if [ -e "$$POLMAN_AODS" ]; then
    echo "Ein Policy Store wurde in $$POLMAN_AODS gefunden. Es braucht im CLI nicht über -a übergeben werden."
fi
    echo "Das Policy Store wurde unter $AODS nicht gefunden. Ein neues kann wie folgt erstellt werden:"
    echo "./PMP.sh create"

sudo -u user bash