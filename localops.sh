#!/usr/bin/env sh

set -eu

while [ "$#" -gt 0 ]
do
  ansible-playbook -i localhost, -c local -e "ansible_python_interpreter=$(which python3 || which python)" $1
  shift
done

ANSIBLE_CONFIG='~/localops/ansible.cfg' ansible-playbook -i localhost, -c local $1
