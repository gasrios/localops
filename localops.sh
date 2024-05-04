#!/usr/bin/env sh

set -eu

ANSIBLE_CONFIG="${HOME}/.localops/ansible.cfg"

while [ "$#" -gt 0 ]; do
  if [ ! -z "$(groups | egrep sudo)" ]; then
    # We can delegate prompting for a password to sudo, if the user is a member of the sudo group,
    # with the advantage that there will be no prompt if NOPASSWD is set.
    ANSIBLE_CONFIG="${ANSIBLE_CONFIG}" ansible-playbook -i localhost, -c local\
      -e "ansible_python_interpreter=$(which python3 || which python)" $1
  else
    # If the user is not a member of sudo, we have to prompt for a password here.
    # 
    # TODO: this will always prompt for a password, even if changes are only local.
    #
    # TODO: if a playbook needs to impersonate two users or more, it won't work.
    ANSIBLE_CONFIG="${ANSIBLE_CONFIG}" ansible-playbook -i localhost, -c local\
      -e "ansible_python_interpreter=$(which python3 || which python)" --ask-become-pass $1
  fi
  shift
done
