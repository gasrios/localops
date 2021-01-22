#!/usr/bin/env sh

set -eux

export DEBIAN_FRONTEND=noninteractive

sudo apt update

sudo apt upgrade --assume-yes -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold"

if [ -z "$(which ansible)" ] # Is ansible already installed?
then
    if [ -z "$(which pip)" ] # Is pip already installed?
    then
        # Bootstrap pip using apt package "python3-pip"; later pip will manage itself
        sudo apt install --assume-yes python3-pip
        # This ensures that, during the bootstrap, PATH contains
        # "$HOME/.local/bin", which is where pip and Ansible are
        PATH=$HOME/.local/bin:$PATH
        pip3 install --force-reinstall --user pip
        sudo apt purge --assume-yes python3-pip
        sudo apt autoremove --assume-yes
    fi
    pip install setuptools
    pip install ansible
    ./localops-cli.sh create-user-bin.yaml
fi
