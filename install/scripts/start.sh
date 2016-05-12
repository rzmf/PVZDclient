#!/bin/sh
# startup script used in entrypoint of the docker container


cd /opt/PVZDpolman/PolicyManager/bin
source /opt/pyvenv/py34/bin/activate
./PAtool.sh --help
bash