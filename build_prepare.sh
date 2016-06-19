#!/usr/bin/env bash
export PS4='+(${BASH_SOURCE}:${LINENO}): ${FUNCNAME[0]:+${FUNCNAME[0]}(): }'

# initialize and update the docker build environment

update_pkg="False"

while getopts ":hnu" opt; do
  case $opt in
    n)
      update_pkg="False"
      ;;
    u)
      update_pkg="True"
      ;;
    *)
      echo "usage: $0 [-n] [-u]
   -n  do not update git repos in docker build context (default)
   -u  update git repos in docker build context

   To update packages delivered as tar-balls just delete them from install/opt
   "
      exit 0
      ;;
  esac
done

shift $((OPTIND-1))


workdir=$(cd $(dirname $BASH_SOURCE[0]) && pwd)
cd $workdir
source ./conf${config_nr}.sh

get_or_update_repo() {
    if [ -e $repodir ] ; then
        if [ "$update_pkg" == "True" ]; then
            echo "updating $repodir"
            cd $repodir && git pull && cd $OLDPWD
        fi
    else
        echo "cloning $repodir" \
        mkdir -p $repodir
        git clone $repourl $repodir        # first time
    fi
}

get_from_tarball() {
    if [ ! -e $pkgroot/$pkgdir ]; then \
        if [ "$update_pkg" == "True" ]; then
            echo "downloading $pkgdir into $pkgroot"
            mkdir $pkgroot/$pkgdir
            curl -L $pkgurl | tar -xz -C $pkgroot
        fi
    fi
}


# --- PVZDpolman ---
repodir='install/opt/PVZDpolman'
repourl='https://github.com/rhoerbe/PVZDpolman'
get_or_update_repo

cd 'install/opt/PVZDpolman/dependent_pkg'
./download.sh $update_pkg

cd '../lib'
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

