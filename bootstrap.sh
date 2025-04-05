#!/usr/bin/env sh

set -eu

# Git branch to install localops from. Change with -b | --branch $OTHER_BRANCH.
BRANCH='master'

# In Debian “bookworm” and Ubuntu 24.04, pip will only install user packages with '--break-system-packages'.
ALLOW_USER_PACKAGES=''

# Dry run mode. Enable with -r | --dry-run.
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

  while [ "${1:-}" != '' ]; do

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

    # redirecting input from /dev/tty allows interactive input to work when script is piped from curl.
    read -p "${LOCALOPS_HOME} already exists and will be deleted. Proceed? [y/N] " CONTINUE </dev/tty

    if [ "${CONTINUE}" != 'y' -a "${CONTINUE}" != 'Y' ]; then
      echo 'Exiting.'
      exit 1
    fi

  fi

}

install_dependencies() {

  distro_dependent_setup

  # localops does not use curl, bur several playbooks in localops-playbooks do.
  if ! command -v curl >/dev/null; then
    echo 'curl not found, installing...'
    install_package curl
  fi

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

  # See https://0pointer.de/blog/projects/os-release
  #
  # Sources /etc/os-release, which sets variables  "ID," "VERSION_ID" and "VERSION_CODENAME."
  if [ ! -f '/etc/os-release' ]; then
    echo '/etc/os-release not found. Exiting.'
    exit 1
  fi

  . /etc/os-release

  install_package python3-debian

  case ${ID} in

  'debian')

    ALLOW_USER_PACKAGES='--break-system-packages'

    case ${VERSION_CODENAME} in

    'trixie')
      # No additional setup needed for Debian "trixie"
      ;;

    'bookworm')
      # No additional setup needed for Debian "bookworm"
      ;;

    *)
      echo "WARNING: unsupported Debian version \"${VERSION_CODENAME}\". You are on your own."
      ;;

    esac
    ;;

  'ubuntu')

    case ${VERSION_ID} in

    '24.04')
      ALLOW_USER_PACKAGES='--break-system-packages'
      ;;

    '22.04')
      # No additional setup needed for Ubuntu 22.04
      ;;

    *)
      echo "WARNING: unsupported Ubuntu version \"${VERSION_ID}\". You are on your own."
      ;;

    esac
    ;;

  *)
    echo "Unsupported distribution \"${ID}\". You are on your own."
    ;;

  esac

}

install_package() {

  if [ "${SUPERUSER}" = false ]; then
    echo "WARNING: skipping installation of package \"${1}\" (no superuser)."
    return
  fi

  case ${ID} in
  'ubuntu' | 'debian')
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
    "${1}" </dev/tty
    return
  fi

  if [ ! -z "$(groups | egrep sudo)" ]; then
    # Tests fail without "|| sudo ${1}," as they do not run from within a terminal
    sudo ${1} </dev/tty || sudo ${1}
    return
  fi

  # Same thing, prevents tests from failing
  su -c "${1}" </dev/tty || su -c "${1}" 

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
