#!/bin/bash
# Prepare the build environment for docker build


get_or_update_repo() {
    # get PVZD from master (release branch)
    if [ -e $repodir ] ; then
        cd $repodir && git pull && cd .. # already cloned
    else
        git clone $repourl # first time
    fi
}

dir=$(dirname `which $0`)  #absolute dirname of script
cd ${dir}/opt


repodir=PVZDjava
repourl=https://github.com/rhoerbe/${repodir}.git
get_or_update_repo

repodir=PVZDpolman
repourl=https://github.com/rhoerbe/${repodir}.git
get_or_update_repo

# PVZDpolman dependent_pkg
cd PVZDpolman/dependent_pkg

repodir='json2html'   # TODO: use wildcard to remove version
repourl='https://github.com/YAmikep/json2html.git'
get_or_update_repo

repodir='pyjnius'   # TODO: use wildcard to remove version
repourl='https://github.com/benson-basis/pyjnius.git'
#repourl=https://github.com/kivy/pyjnius.git  # upstream
get_or_update_repo

if [ ! -e ordereddict-1.1 ] ; then
    echo "downloading ordereddict-1.1"
	curl -O https://pypi.python.org/packages/source/o/ordereddict/ordereddict-1.1.tar.gz
	tar -xzf ordereddict-1.1.tar.gz
	rm ordereddict-1.1.tar.gz
fi
