#!/usr/bin/env sh

set -eux

while [ "$#" -gt 0 ]
do
  ansible-playbook -i localhost, -c local $1
  shift
done
