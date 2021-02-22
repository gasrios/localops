#!/usr/bin/env sh

set -eu

export PLAYBOOK=$(echo $1 | sed 's|^\.\./||')

cd ..

if [ $(ansible-lint $PLAYBOOK; echo $?) -eq 0 ]
then
  echo 'Static code check found no errors'
fi

for DISTRO in ubuntu-18.04 ubuntu-20.04
do
  echo Testing $DISTRO
  docker run \
    --rm \
    -it \
    -u test \
    -v $(pwd):/home/test/localops \
    -w /home/test/localops \
    localops:${DISTRO} \
    "''. ~/.profile && ./localops-cli.sh $PLAYBOOK $PLAYBOOK''"
done
