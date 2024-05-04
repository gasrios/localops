#!/usr/bin/env sh

set -eu

BRANCH='main'
DRY_RUN=''
LOCALOPS_HOME="${HOME}/.localops"
SUPERUSER=true
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

    read -p "${LOCALOPS_HOME} already exists and will be deleted. Proceed? [y/N] " CONTINUE

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
  else
    . /etc/os-release
  fi

  if ! command -v git >/dev/null; then
    echo 'git not found, installing...'
    install_package git
  fi

  if ! command -v ansible-playbook >/dev/null; then

    echo 'ansible-playbook not found, installing...'

    if ! command -v pip >/dev/null; then
      echo 'pip not found, installing...'
      install_package pip
    fi

    ${DRY_RUN} pip install --no-cache-dir --upgrade --force-reinstall --user --break-system-packages ansible

    if ! echo "${PATH}" | grep -q "${HOME}/.local/bin"; then
      export PATH=${HOME}/.local/bin:${PATH}
    fi

  fi

}

install_package() {

  if [ "${SUPERUSER}" = false ]; then
    echo "WARNING: skipping installation of package \"${1}\" (no superuser)."
  else
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
  fi

}

execute_command() {

  if [ "$(whoami)" = root ]; then
    ${1}
    exit 0
  fi

  if [ ! -z "$(groups | egrep sudo)" ]; then
    sudo ${1}
    exit 0
  fi

  su -c "${1}"

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
