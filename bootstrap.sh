#!/usr/bin/env sh

set -eux

export PYTHON_VERSION=3.9.1
export DEBIAN_FRONTEND=noninteractive

sudo apt update

sudo apt upgrade --assume-yes -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold"

if [ -z "$(which ansible)" ]
then
    DISTRO=$(egrep '^ID=' /etc/os-release | sed 's/^ID="\?\([^"]*\)"\?/\1/')
    DISTRO_VERSION=$(egrep '^VERSION_ID=' /etc/os-release | sed 's/^VERSION_ID="\?\([^"]*\)"\?/\1/')
    wget -SO- https://raw.githubusercontent.com/gasrios/p4lo/main/repository/${DISTRO}-${DISTRO_VERSION}-${PYTHON_VERSION}.tbz \
    | sudo tar xvj --directory /
    sudo /opt/python-${PYTHON_VERSION}/bin/pip install --no-cache-dir --upgrade pip
    PATH=~/.local/bin:/opt/python-${PYTHON_VERSION}/bin:$PATH
    pip install ansible
    ./localops-cli.sh install.yaml
fi
