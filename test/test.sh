#!/usr/bin/env sh

set -eux

./bootstrap.sh

for PLAYBOOK in $(ls *.yaml)
do
    sh -c "export PATH=$HOME/.local/bin:/opt/python-3.9.1/bin:$PATH && ./localops-cli.sh $PLAYBOOK"
done
