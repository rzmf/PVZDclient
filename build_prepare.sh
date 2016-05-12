#!/usr/bin/env bash

# initialize and update the docker build environment

workdir=$(dirname $BASH_SOURCE[0])
cd $workdir

get_or_update_repo() {
    if [ -e $repodir ] ; then
        cd $repodir && git pull && cd -    # already cloned
    else
        mkdir -p $repodir
        git clone $repourl $repodir        # first time
    fi
}


# --- PVZDpolman ---
repodir='install/opt/PVZDpolman'
repourl='https://github.com/rhoerbe/PVZDpolman'
get_or_update_repo

cd 'install/opt/PVZDpolman/lib'

# --- PVZDjava ---
# fetch/update when zip archive not found
if [ ! -e 'pvzdjava_1.0.zip' ]; then
    curl -LO https://github.com/rhoerbe/PVZDjava/files/260806/pvzdjava_1.0.zip
    unzip -j pvzdjava_1.0.zip
fi

# --- MOA-SPSS ---
# fetch/update when zip archive not found
if [ ! -e 'moa-spss-lib-2.0.3.zip' ]; then
    curl -LO https://joinup.ec.europa.eu/system/files/project/moa-spss-lib-2.0.3.zip
    unzip moa-spss-lib-2.0.3.zip
    ln -s moa-spss-lib-2.0.3 moa-spss-lib
fi

