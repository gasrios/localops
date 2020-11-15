#!/usr/bin/env bash

# From https://ss64.com/bash/set.html
#
# errexit: Exit immediately if a simple command exits with a non-zero
#          status, unless the command that fails is part of an until or
#          while loop, part of an if statement, part of a && or || list,
#          or if the command's return status is being inverted using !.
#
# nounset: Treat unset variables as an error when performing parameter
#          expansion. An error message will be written to the standard
#          error, and a non-interactive shell will exit.
#
# pipefail: If set, the return value of a pipeline is the value of the
#           last (rightmost) command to exit with a non-zero status, or
#           zero if all commands in the pipeline exit successfully. By
#           default, pipelines only return a failure if the last command
#           errors.
#
# xtrace: Print a trace of simple commands and their arguments after they
#         are expanded and before they are executed.

set -o errexit -o nounset -o pipefail -o xtrace

sudo apt update

# See http://www.microhowto.info/howto/perform_an_unattended_installation_of_a_debian_package.html
sudo DEBIAN_FRONTEND=noninteractive apt upgrade --assume-yes -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold"

if [ "$(ansible -h 2>&1>/dev/null || false; echo $?)" != "0" ] # Is ansible already installed?
then
 if [ "$(pip 2>&1>/dev/null || false; echo $?)" != "0" ] # Is pip already installed?
 then
  # Bootstrap pip using apt package "python3-pip"; later pip will manage itself
  sudo DEBIAN_FRONTEND=noninteractive apt install --assume-yes python3-pip
  pip3 install --force-reinstall --user pip
  # This ensures that, during the bootstrap, PATH contains "$HOME/.local/bin:$PATH",
  # which is where pip and Ansible are
  . ~/.profile
  sudo DEBIAN_FRONTEND=noninteractive apt purge --assume-yes python3-pip
  sudo DEBIAN_FRONTEND=noninteractive apt autoremove --assume-yes
 fi
 pip install setuptools
 pip install ansible
fi

./localops-cli.sh create-user-bin.yaml
