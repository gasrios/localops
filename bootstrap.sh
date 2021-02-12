#!/usr/bin/env sh

set -eux

if [ -z "$(which ansible)" ]
then
    PYTHON_VERSION=3.9.1

    if [ "$(whoami)" = root -o ! -z "$(groups | egrep sudo)" ]
    then
        DEBIAN_FRONTEND=noninteractive
        $(which sudo) apt update
        $(which sudo) apt upgrade --assume-yes -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold"
        $(which sudo) apt install curl direnv --assume-yes -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold"

        DISTRO=$(egrep '^ID=' /etc/os-release | sed 's/^ID="\?\([^"]*\)"\?/\1/')
        DISTRO_VERSION=$(egrep '^VERSION_ID=' /etc/os-release | sed 's/^VERSION_ID="\?\([^"]*\)"\?/\1/')

        curl --silent --output - https://raw.githubusercontent.com/gasrios/p4lo/main/repository/${DISTRO}-${DISTRO_VERSION}-${PYTHON_VERSION}.tbz \
        | $(which sudo) tar xvj --directory /
    fi

    if [ -e /opt/python-${PYTHON_VERSION}/bin/pip ]
    then
        export PATH=${HOME}/.local/bin:/opt/python-${PYTHON_VERSION}/bin:$PATH
    else
        echo "Ansible is not installed and cannot be installed by user $(whoami). Install it and try again."
        false
    fi

    pip install --no-cache-dir --upgrade pip
    pip install --no-cache-dir --upgrade wheel
    pip install --no-cache-dir --upgrade ansible
fi

./localops-cli.sh install.yaml
