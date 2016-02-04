#!/bin/bash
# Prepare the build environment for docker build


## unused !!!!!


dir=$(dirname `which $0`)  #absolute dirname of script
cd ${dir}

repodir='PVZD'
repourl='https://github.com/rhoerbe/PVZD.git'
get_repo

cd $repodir/dependent_pkg
repodir='ordereddict-1.1'   # TODO: use wildcard to remove version
repourl='https://pypi.python.org/pypi/ordereddict'
get_repo

get_repo() {
    # get PVZD from master (release branch)
    if [-e $repodir ] then
        cd $repodir && git pull && cd .. # already cloned
    else
        git clone $repourl # first time
    fi
}