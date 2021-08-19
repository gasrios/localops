#!/usr/bin/env sh

# ansible_become_pass=yourPassword

set -eu

PASSWORD=''
PLAYBOOKS=''

while [ "${1:-}" != "" ]; do
  case $1 in
    -d | --debug)
      set -x
      ;;
    -p | --password)
      shift
      PASSWORD="--extra-vars 'ansible_become_password=$1'"
      ;;
    *.yaml | *.yml)
      PLAYBOOKS=${PLAYBOOKS}' '$1
      ;;
    *)
      echo "Unkown parameter: $1"
      exit 1
      ;;
  esac
  shift
done

for PLAYBOOK in ${PLAYBOOKS}
do
ANSIBLE_CONFIG='~/.localops/ansible.cfg' ansible-playbook\
    -i localhost,\
    -c local\
    --extra-vars "'ansible_python_interpreter=$(which python3 || which python)'"\
    ${PASSWORD}\
    ${PLAYBOOK}
done
