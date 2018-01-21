#!/usr/bin/env bash

set -e

action=$1
mode=$2

stable="vipinbonline-patch-1"

trap cleanup EXIT

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
 tools_download "https://raw.githubusercontent.com/vipinbonline/encfs/$stable/kde-service-menu-encfs.sh"
 tools_download "https://raw.githubusercontent.com/vipinbonline/encfs/$stable/encfs.desktop"
 sudo apt-get install encfs -y -q
}

tools_reset() {
  unset -f tools_has tools_download download_prerequired isinstalled install uninstall main tools_reset cleanup
}



cleanup(){
 rm -f kde-service-menu-encfs.sh
 rm -f encfs.desktop
 tools_reset
}

install(){

 if [[ "$mode" = "local" ]]; then
   echo "Installing encfs plugin for the user $USER"
   download_prerequired
   mkdir -p ~/.local/share/kservices5/ServiceMenus/ 
   cp "encfs.desktop" ~/.local/share/kservices5/ServiceMenus/
 elif [[ "$mode" = "all" ]]; then
   echo "Installing encfs plugin for all users"
   download_prerequired
   sudo mkdir -p /usr/share/kservices5/ServiceMenus/ 
   sudo cp "encfs.desktop" /usr/share/kservices5/ServiceMenus/
 else
   echo "Unable to find the installation type $mode. Please specify all or local"
   exit 1
  fi 
 sudo cp "kde-service-menu-encfs.sh" /usr/bin
 sudo chmod 755 /usr/bin/kde-service-menu-encfs.sh
 kbuildsycoca5 2>&1 >/dev/null
 echo "Encfs dolphin plugin installed successfully"
}


isinstalled(){

 if [ -f ~/.local/share/kservices5/ServiceMenus/encfs.desktop ] || [ -f /usr/bin/kde-service-menu-encfs.sh ]; then
  echo "local"
 elif [ -f /usr/share/kservices5/ServiceMenus/encfs.desktop ] || [ -f /usr/bin/kde-service-menu-encfs.sh ]; then 
  echo "all"
 else
  echo "none"
 fi

}



uninstall(){
  if [[ "$(isinstalled)" = "local" ]]; then
    echo "Uninstalling encfs dolphin  plugin for $USER"
    rm -f ~/.local/share/kservices5/ServiceMenus/encfs.desktop 
  elif [[ "$(isinstalled)" = "all" ]]; then
    echo "Uninstalling encfs dolphin  plugin for all users"
    sudo rm -f /usr/share/kservices5/ServiceMenus/encfs.desktop
  else
    echo "Unable to find the installation location"
    exit 1
  fi
  sudo apt-get remove encfs -y -q
  sudo rm -f /usr/bin/kde-service-menu-encfs.sh
  kbuildsycoca5 2>&1 >/dev/null
  echo "Encfs dolphin plugin uninstalled successfully"
}




main(){
 if [ "$action" = "install"  ]; then
   if [[ "$(isinstalled)" != "none" ]]; then
    echo "encfs dolphin plugin already installed for the $(isinstalled) user  . Please uninstall to install again" 
   else
    install 
   fi
 elif  [ "$action" = "uninstall"  ]; then
   uninstall
 else
   echo "Unable to identify the action  $action specified please use install/uninstall"
 fi
}

main
