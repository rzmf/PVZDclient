#!/bin/sh
# startup script used in entrypoint of the docker container


cd /opt/PVZDpolman/PolicyManager/bin
./PAtool.sh --help
bash