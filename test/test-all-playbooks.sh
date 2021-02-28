#!/usr/bin/env sh

set -eux

for PLAYBOOK in $(egrep -v '#' playbooks)
do
  ./test-playbook.sh $PLAYBOOK
done
