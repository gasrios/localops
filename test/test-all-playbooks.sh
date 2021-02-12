#!/usr/bin/env sh

set -eux

cd ..

for PLAYBOOK in $(cat test/playbooks | egrep -v '#')
do
  ./localops-cli.sh ${PLAYBOOK}
done
