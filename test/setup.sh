#!/usr/bin/env sh

set -eux

cd ..

for DISTRO in debian-bookworm debian-trixie ubuntu-22.04 ubuntu-24.04
do
  docker image rm localops:${DISTRO} || true
  docker build -t localops:${DISTRO} -f test/Dockerfile-${DISTRO} .
done

docker builder prune
