#!/usr/bin/env bash

tools_has() {
  type "$1" > /dev/null 2>&1
}


tools_download() {
  if tools_has "curl"; then
    curl -q "$@"
  elif tools_has "wget"; then
    # Emulate curl with wget
    ARGS=$(echo "$*" | command sed -e 's/--progress-bar /--progress=bar /' \
                           -e 's/-L //' \
                           -e 's/-I /--server-response /' \
                           -e 's/-s /-q /' \
                           -e 's/-o /-O /' \
                           -e 's/-C - /-c /')
    # shellcheck disable=SC2086
    eval wget $ARGS
  fi
}

download_prerequired(){
 tools_download "https://raw.githubusercontent.com/vipinbonline/encfs/vipinbonline-patch-1/kde-service-menu-encfs.sh"
 tools_download "https://github.com/vipinbonline/encfs/blob/vipinbonline-patch-1/encfs.desktop"
}

