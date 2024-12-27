{ pkgs }:

with pkgs;
let
  shared-packages = import ../shared/packages.nix { inherit pkgs; };
in
shared-packages
++ [

  # App and package management
  home-manager

  # Media and design tools
  fontconfig
  font-manager

  # Testing and development tools
  direnv
  rofi
  rofi-calc

  # Screenshot and recording tools
  flameshot
  simplescreenrecorder

  # Text and terminal utilities
  tree
  unixtools.ifconfig
  unixtools.netstat

  # File and system utilities
  inotify-tools # inotifywait, inotifywatch - For file system events
  libnotify
  pinentry-curses
  pcmanfm # Our file browser
  xdg-utils

  # K8s
  cilium-cli

  #Networking
  unifi
]
