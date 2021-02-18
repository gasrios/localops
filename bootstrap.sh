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
    $(which sudo) apt install --assume-yes python3-pip direnv curl
  ;;
  *)
    echo "Unsupported distro ${DISTRO}"
    false
  ;;
  esac
}

if [ -z "$(which ansible-playbook)" ]
then
  if [ -z "$(which pip3 || which pip)" ]
  then
    if [ "$(whoami)" = root -o ! -z "$(groups | egrep sudo)" ]
    then
      distro_dependent_setup
    else
      echo "Neither Ansible nor pip are installed, and cannot be installed by user $(whoami)."
      false
    fi
  fi
  export PATH=${HOME}/.local/bin:${PATH}
  $(which pip3 || which pip) install --no-cache-dir --upgrade --force-reinstall --user pip
  $(which pip3 || which pip) install --no-cache-dir --upgrade --force-reinstall --user wheel
  $(which pip3 || which pip) install --no-cache-dir --upgrade --force-reinstall --user ansible
fi

./localops-cli.sh install.yaml
