#!/bin/bash
# Prepare the build environment for docker build


get_repo() {
    # get PVZD from master (release branch)
    if [-e $repodir ] ; then
        cd $repodir && git pull && cd .. # already cloned
    else
        git clone $repourl # first time
    fi
}

dir=$(dirname `which $0`)  #absolute dirname of script
cd ${dir}/opt


repodir=PVZDjava
repourl=https://github.com/rhoerbe/${repodir}.git
get_repo

repodir=PVZDpolman
repourl=https://github.com/rhoerbe/${repodir}.git
#get_repo

cd $repodir/dependent_pkg
repodir='ordereddict-1.1'   # TODO: use wildcard to remove version
repourl='https://pypi.python.org/pypi/ordereddict'
#get_repo

