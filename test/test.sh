#!/usr/bin/env sh

set -eux

for DISTRO in localops:ubuntu-18.04-test localops:ubuntu-20.04-test
do
    docker run --rm -itv $(pwd)/..:/home/test/localops -w /home/test/localops ${DISTRO}
done
