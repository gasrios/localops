#!/usr/bin/env sh

set -eux

while [ "$#" -gt 0 ]
do
  ansible-playbook -vvv -i localhost, -c local $1
  shift
done
