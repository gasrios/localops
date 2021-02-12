#!/usr/bin/env sh

set -eux

while [ "$#" -gt 0 ]
do
  ansible-playbook -i localhost, -c local -e "ansible_python_interpreter=$(which python3)" $1
  shift
done
