#!/usr/bin/env sh

set -eux

docker build -t localops:ubuntu-18.04-test -f Dockerfile-ubuntu-18.04 .
docker build -t localops:ubuntu-20.04-test -f Dockerfile-ubuntu-20.04 .
