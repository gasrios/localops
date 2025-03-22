#!/usr/bin/env sh

set -eux

cd ..

for DISTRO in ubuntu-20.04
do
  docker build -t localops:${DISTRO} -f test/Dockerfile-${DISTRO} .
done
