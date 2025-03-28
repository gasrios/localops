#!/usr/bin/env sh

set -eu

# Git branch to install localops from. Change with -b | --branch $OTHER_BRANCH
BRANCH='master'

# In Debian 12, pip will only install user packages with '--break-system-packages' set
ALLOW_USER_PACKAGES=''

# Dry run mode. Enable with -r | --dry-run
DRY_RUN=''

LOCALOPS_HOME="${HOME}/.localops"

# Run steps that need superuser privileges. Disable with -s | --superuser false.
SUPERUSER=true

# Install dependencies. Disable with -w | --with-deps false.
WITH_DEPS=true

main() {

  parse_arguments "${@}"

  check_overwrite_previous_install

  if [ "${WITH_DEPS}" = false ]; then
    echo 'WARNING: skipping dependency installation.'
  else
    install_dependencies
  fi

  install_localops

}

parse_arguments() {
  while [ "${1:-}" != "" ]; do
    case ${1} in
    -b | --branch)
      shift
      BRANCH=${1}
      ;;
    -d | --debug)
      set -x
      ;;
    -r | --dry-run)
      DRY_RUN='echo'
      ;;
    -s | --superuser)
      shift
      SUPERUSER=${1}
      ;;
    -w | --with-deps)
      shift
      WITH_DEPS=${1}
      ;;
    esac
    shift
  done
}

check_overwrite_previous_install() {

  if [ -e "${LOCALOPS_HOME}" ]; then

    # redirecting input from /dev/tty allows interactive input to work when script is piped from curl
    read -p "${LOCALOPS_HOME} already exists and will be deleted. Proceed? [y/N] " CONTINUE </dev/tty

    if [ "${CONTINUE}" != 'y' -a "${CONTINUE}" != 'Y' ]; then
      echo 'Exiting.'
      exit 1
    fi

  fi

}

install_dependencies() {

  # See https://0pointer.de/blog/projects/os-release
  #
  # Sources /etc/os-release, which sets an "ID" variable to a string identifying
  # the distro
  if [ ! -f '/etc/os-release' ]; then
    echo '/etc/os-release not found. Exiting.'
    exit 1
  fi

  . /etc/os-release

  distro_dependent_setup

  if ! command -v git >/dev/null; then
    echo 'git not found, installing...'
    install_package git
  fi

  if ! command -v pip >/dev/null; then
    echo 'pip not found, installing...'
    install_package pip
  fi

  if ! command -v ansible-playbook >/dev/null; then
    echo 'ansible-playbook not found, installing...'
    pip_install ansible
  fi

  if ! command -v ansible-lint >/dev/null; then
    echo 'ansible-lint not found, installing...'
    pip_install ansible-lint
  fi

  if ! echo "${PATH}" | grep -q "${HOME}/.local/bin"; then
    export PATH=${HOME}/.local/bin:${PATH}
  fi

}

distro_dependent_setup() {
  case ${ID} in
  debian)
    ALLOW_USER_PACKAGES='--break-system-packages'
    ;;
  ubuntu)
    ALLOW_USER_PACKAGES='--break-system-packages'
    ;;
  *)
    echo "Unsupported distribution \"${ID}\". Exiting."
    exit 1
    ;;
  esac
}

install_package() {

  if [ "${SUPERUSER}" = false ]; then
    echo "WARNING: skipping installation of package \"${1}\" (no superuser)."
    return
  fi

  case ${ID} in
  ubuntu | debian)
    COMMAND="${DRY_RUN} apt install --assume-yes ${1}"
    ;;
  *)
    echo "Unsupported distribution \"${ID}\". Exiting."
    exit 1
    ;;
  esac

  execute_command "${COMMAND}"

}

# redirecting input from /dev/tty allows interactive input to work when script is piped from curl
execute_command() {

  if [ "$(whoami)" = root ]; then
    ${1} </dev/tty
    return
  fi

  if [ ! -z "$(groups | egrep sudo)" ]; then
    # Tests fail without "|| sudo ${1}," as they do not run from within a terminal
    sudo ${1} </dev/tty || sudo ${1}
    return
  fi

  su -c "${1}" </dev/tty

}

pip_install() {

    ${DRY_RUN} pip install --no-cache-dir --upgrade --force-reinstall ${ALLOW_USER_PACKAGES} --user ${1}

}

install_localops() {

  ${DRY_RUN} rm -rf "${LOCALOPS_HOME}"
  ${DRY_RUN} git clone https://github.com/gasrios/localops.git "${LOCALOPS_HOME}"
  ${DRY_RUN} cd "${LOCALOPS_HOME}"
  ${DRY_RUN} git checkout ${BRANCH}
  ${DRY_RUN} rm -rf .git*
  ${DRY_RUN} ./localops.sh ./install.yaml

}

main "${@}"
