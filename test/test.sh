#!/usr/bin/env sh

set -eu

export PLAYBOOK=$(echo $1 | sed 's/\.\.\///')

cd ..

for DISTRO in localops:ubuntu-18.04 localops:ubuntu-20.04
do
    docker run \
        --rm \
        -it \
        -v $(pwd):/home/test/localops \
        -w /home/test/localops \
        ${DISTRO} \
        "''. ~/.profile && ./localops-cli.sh $PLAYBOOK && ./localops-cli.sh $PLAYBOOK''"
done
