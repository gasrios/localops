#!/usr/bin/env sh

set -eux

#
# Distribution dependent setup goes in this function
#
distro_dependent_setup() {
  DISTRO=$(egrep '^ID=' /etc/os-release | sed 's/^ID="\?\([^"]*\)"\?/\1/')

  case "${DISTRO}" in
  ubuntu)
    export DEBIAN_FRONTEND=noninteractive
    $(which sudo) apt update
    $(which sudo) apt upgrade --assume-yes -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold"
    $(which sudo) apt install --assume-yes python3-pip python-is-python3 git
  ;;
  *)
    echo "Unsupported distro ${DISTRO}"
    false
  ;;
  esac
}

BRANCH='master'

while [ "${1:-}" != "" ]; do
    case $1 in
        -b | --branch )   shift
            BRANCH=$1
            ;;
    esac
    shift
done

if [ -z "$(which ansible-playbook)" ]
then
  if [ -z "$(which pip3 || which pip)" ]
  then
    if [ "$(whoami)" != root -a -z "$(groups | egrep sudo)" ]
    then
      echo "Neither Ansible nor pip are installed, and cannot be installed by user $(whoami)."
      false
    else
      distro_dependent_setup
    fi
  fi
  export PATH=${HOME}/.local/bin:${PATH}
  $(which pip3 || which pip) install --no-cache-dir --upgrade --force-reinstall --user pip
  pip install --no-cache-dir --upgrade --force-reinstall --user wheel
  pip install --no-cache-dir --upgrade --force-reinstall --user ansible
fi

cd ~
rm -rf .localops

git clone https://github.com/gasrios/localops.git .localops

cd ~/.localops
git checkout $BRANCH
rm -rf .git*

if [ "$(whoami)" = root -o ! -z "$(groups | egrep sudo)" ]
then
  ./localops.sh root/install.yaml
fi

./localops.sh user/install.yaml
