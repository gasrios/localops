#!/usr/bin/env sh

set -eu

ANSIBLE_CONFIG="${HOME}/.localops/ansible.cfg"
ASK_BECOME_PASS=''

main() {

  determine_su_strategy;

  while [ "$#" -gt 0 ]; do
    ANSIBLE_CONFIG="${ANSIBLE_CONFIG}" ansible-playbook\
      -i localhost,\
      -c local\
      -e "ansible_python_interpreter=$(which python3 || which python)"\
      ${ASK_BECOME_PASS}\
      $1
    shift
  done

}

# We are trying to account here for two different and incompatible scenarios:
#
# 1. The user can (or even must) use "sudo su" to escalate privileges.
#
# 2. The user can't sudo, and therefore must su.
#
# By checking if the user is in the "sudo" group, we can determine in which scenario we are.
#
# The default behavior in Ubuntu is (1), while Debian is (2), so we do need to support both.
determine_su_strategy() {

  if [ -z "$(groups | egrep sudo)" ]; then

    # If the user is not a member of the "sudo" group, we have to prompt for a password here,
    # otherwise we can delegate it to sudo, with the advantage that there will be no prompt
    # if NOPASSWD is set.
    # 
    # FIXME: this will always prompt for a password, even if changes are only local.
    #       (but in this case you can just proceed without entering a password)
    #
    # TODO: if a playbook needs to impersonate two users or more, it may not work.
    ASK_BECOME_PASS='--ask-become-pass'

  fi

}

main "${@}"
