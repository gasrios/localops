#!/usr/bin/env bash

# From https://ss64.com/bash/set.html
#
# errexit: Exit immediately if a simple command exits with a non-zero
#          status, unless the command that fails is part of an until or
#          while loop, part of an if statement, part of a && or || list,
#          or if the command's return status is being inverted using !.
#
# nounset: Treat unset variables as an error when performing parameter
#          expansion. An error message will be written to the standard
#          error, and a non-interactive shell will exit.
#
# pipefail: If set, the return value of a pipeline is the value of the
#           last (rightmost) command to exit with a non-zero status, or
#           zero if all commands in the pipeline exit successfully. By
#           default, pipelines only return a failure if the last command
#           errors.

set -o errexit -o nounset -o pipefail

while [ "$#" -gt 0 ]
do
  ansible-playbook -i localhost, -c local $1
  shift
done
