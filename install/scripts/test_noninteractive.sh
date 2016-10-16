#!/bin/bash
# run non-interactive unit tests

if [ $(id -u) -eq 0 ]; then
    echo "do not run this script as root"
    exit 1
fi

cd /opt/PVZDpolman/PolicyManager/tests

./testAll.sh -s noninteractive