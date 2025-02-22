#!/bin/bash
set -eu


CURRENT_DIR=$(cd "$(dirname "${0}")"; pwd)
DOT_DIRECTORY=$(cd "${CURRENT_DIR}";cd ./../..; pwd)
SCRIPT_DIR="${DOT_DIRECTORY}/etc/scripts"
MKLINK_SCRIPT_DIR="${SCRIPT_DIR}/mklink"
DEPLOY_LIST_DIR="${DOT_DIRECTORY}/etc/deploylist"
OS_TYPE=""
SILENT_MODE=false

while (( $# > 0 ))
do
  case "${1}" in
    -s)
      SILENT_MODE=true
      ;;
    -*)
      echo "invalid option"
      exit 1
      ;;
  esac
  shift
done

main() {
  check_os_type
  create_link
  common_deploy
  feature_deploy
}

check_os_type() {
  local os
  os=$(uname -s)

  case "${os}" in
    Linux*)
      if command -v apt-get &> /dev/null; then
        OS_TYPE="Ubuntu"
      elif command -v pacman &> /dev/null; then
        OS_TYPE="ArchLinux"
      else
        echo "Unsupported distribution"
        return 1
      fi
      return 0
      ;;
    Darwin*)
      if [ "$(uname -m)" == "x86_64" ] ; then
        OS_TYPE="OSX(x64)"
      elif [ "$(uname -m)" == "arm64" ] ; then
        OS_TYPE="OSX(a64)"
      else
        echo "Unsupported Architecture"
        return 1
      fi
      return 0
      ;;
    *)
      echo "Command failed."
      return 1
      ;;
  esac
}

create_link() {
  case "${OS_TYPE}" in
    "OSX(x64)")
      if "${SILENT_MODE}"; then
        source "${MKLINK_SCRIPT_DIR}/mklink_osx_x64.sh" -s
      else
        echo "creating symlink for OSX(x64)"
        source "${MKLINK_SCRIPT_DIR}/mklink_osx_x64.sh"
      fi
      ;;
    "OSX(a64)")
      if "${SILENT_MODE}"; then
        source "${MKLINK_SCRIPT_DIR}/mklink_osx_a64.sh" -s
      else
        echo "creating symlink for OSX(arm64)"
        source "${MKLINK_SCRIPT_DIR}/mklink_osx_a64.sh"
      fi
      ;;
    "Ubuntu")
      if "${SILENT_MODE}"; then
        source "${MKLINK_SCRIPT_DIR}/mklink_ubuntu.sh" -s
      else
        echo "creating symlink for ubuntu"
        source "${MKLINK_SCRIPT_DIR}/mklink_ubuntu.sh"
      fi
      ;;
    "ArchLinux")
      if "${SILENT_MODE}"; then
        source "${MKLINK_SCRIPT_DIR}/mklink_archlinux.sh" -s
      else
        echo "creating symlink for Arch Linux"
        source "${MKLINK_SCRIPT_DIR}/mklink_archlinux.sh"
      fi
      ;;
    *)
      echo "Unsupported OS type"
      return 1
      ;;
  esac
  return 0
}

common_deploy() {
  COMMON_DEPLOY_LIST="${DEPLOY_LIST_DIR}/deploylist.common.txt"

  __remove_deploylist_comment() {(
    sed \
      -e 's/\s*#.*//' \
      -e '/^\s*$/d' \
      "${1}"
  )}

  tmp_file=$(mktemp)
  trap 'rm ${tmp_file}' 0

  if [ -f "${COMMON_DEPLOY_LIST}" ]; then
    __remove_deploylist_comment "${COMMON_DEPLOY_LIST}" > "${tmp_file}"
    while read -r line; do
      # ~ や環境変数を展開
      src=$(eval echo "$(cut -d ',' -f 1 <<<"${line}")")
      dst=$(eval echo "$(cut -d ',' -f 2 <<<"${line}")")

      dst_dir="${dst%/*}"
      # 空白を含むディレクトリの対応のためにダブルクウォーテーションを追加
      if [ ! -d "${dst_dir}" ]; then
        mkdir -p "${dst_dir}"
      fi
      if [ -d "${dst}" ] || [ -f "${dst}" ]; then
        rm -rf "${dst}"
      fi

      if "${SILENT_MODE}"; then
        ln -sf "${src}" "${dst}"
      else
        ln -sf "${src}" "${dst}" && \
          echo "$(tput setaf 2)✔︎$(tput sgr0)~${dst#"${HOME}"}"
      fi

    done < "${tmp_file}"
  else
    echo "No such file"
  fi
  return 0
}

feature_deploy() {
  case "${OS_TYPE}" in
    "OSX(x64)")
      echo "feature deploy for OSX(x64)"
      deploylist="${DEPLOY_LIST_DIR}/deploylist.Darwin.txt"
      ;;
    "OSX(a64)")
      echo "feature deploy for OSX(a64)"
      deploylist="${DEPLOY_LIST_DIR}/deploylist.Darwin.txt"
      ;;
    "Ubuntu")
      echo "feature deploy for ubuntu"
      deploylist="${DEPLOY_LIST_DIR}/deploylist.ubuntu.txt"
      ;;
    "ArchLinux")
      echo "feature deploy for ArchLinux"
      deploylist="${DEPLOY_LIST_DIR}/deploylist.ubuntu.txt"
      ;;
    *)
      echo "Unsupported OS type"
      return 1
      ;;
  esac

  __remove_deploylist_comment() {(
    sed \
      -e 's/\s*#.*//' \
      -e '/^\s*$/d' \
      "${1}"
  )}

  tmp_file=$(mktemp)
  trap 'rm ${tmp_file}' 0

  if [ -f "${deploylist}" ]; then
    __remove_deploylist_comment "${deploylist}" > "${tmp_file}"
    while read -r line; do
      # ~ や環境変数を展開
      src=$(eval echo "$(cut -d ',' -f 1 <<<"${line}")")
      dst=$(eval echo "$(cut -d ',' -f 2 <<<"${line}")")

      dst_dir="${dst%/*}"
      # 空白を含むディレクトリの対応のためにダブル区ウォーテーションを追加
      if [ ! -d "${dst_dir}" ]; then
        mkdir -p "${dst_dir}"
      fi

      if [ -d "${dst}" ] || [ -f "${dst}" ]; then
        rm -rf "${dst}"
      fi

      if "${SILENT_MODE}"; then
        ln -sf "${src}" "${dst}"
      else
        ln -sf "${src}" "${dst}"
        echo "$(tput setaf 2)✔︎$(tput sgr0)~${dst#"${HOME}"}"
      fi

    done < "${tmp_file}"
  else
    echo "No such file"
  fi
  return 0
}


# ShellSpec
${__SOURCED__:+return}
main
