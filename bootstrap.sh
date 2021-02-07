#!/usr/bin/env sh

set -eux

export PYTHON_VERSION=3.9.1
export DEBIAN_FRONTEND=noninteractive

sudo apt update || yes

sudo apt upgrade --assume-yes -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" || yes

sudo apt install direnv --assume-yes -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" || yes

if [ -z "$(which ansible)" ]
then
    DISTRO=$(egrep '^ID=' /etc/os-release | sed 's/^ID="\?\([^"]*\)"\?/\1/')
    DISTRO_VERSION=$(egrep '^VERSION_ID=' /etc/os-release | sed 's/^VERSION_ID="\?\([^"]*\)"\?/\1/')
    wget -SO- https://raw.githubusercontent.com/gasrios/p4lo/main/repository/${DISTRO}-${DISTRO_VERSION}-${PYTHON_VERSION}.tbz \
    | tar xvj --directory ${HOME}
    PATH=${HOME}/.local/bin:${HOME}/.python-${PYTHON_VERSION}/bin:$PATH
    pip install --no-cache-dir --upgrade pip
    pip install ansible
    ./localops-cli.sh install.yaml
fi
