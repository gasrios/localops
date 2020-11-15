#!/usr/bin/env bash

# test.sh
#
# Create a test image with the latest version of localops, and use it to test
# script "bootstrap.sh"

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
#
# xtrace: Print a trace of simple commands and their arguments after they
#         are expanded and before they are executed.

set -o errexit -o nounset -o pipefail -o xtrace

# TODO mount at runtime instead of copying and creating a new image?
docker build -t localops:ubuntu-20.04 -f test/Dockerfile-ubuntu-20.04 .
docker run -it localops:ubuntu-20.04

# TODO mount at runtime instead of copying and creating a new image?
docker build -t localops:ubuntu-18.04 -f test/Dockerfile-ubuntu-18.04 .
docker run localops:ubuntu-18.04
