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
    # TODO We need python-is-python3, but should python3-pip be uninstalled?
    $(which sudo) apt install --assume-yes python-is-python3 python3-pip
  ;;
  *)
    echo "Unsupported distro ${DISTRO}"
    false
  ;;
  esac
}

if [ -z "$(which ansible-playbook)" ]
then
  if [ -z "$(which pip || which pip3)" ]
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
  $(which pip || which pip3) install --no-cache-dir --upgrade --force-reinstall --user pip
  $(which pip || which pip3) install --no-cache-dir --upgrade --force-reinstall --user wheel
  $(which pip || which pip3) install --no-cache-dir --upgrade --force-reinstall --user ansible
fi

./localops-cli.sh install.yaml
