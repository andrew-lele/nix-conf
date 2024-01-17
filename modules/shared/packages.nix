{ pkgs }:

with pkgs; [
  # General packages for development and system management
  act
  alacritty
  aspell
  bash-completion
  bat
  coreutils
  killall
  neofetch
  openssh
  pandoc
  sqlite
  wget
  zip
  fish

  # Encryption and security tools
  age
  gnupg
  libfido2

  # Media-related packages
  dejavu_fonts
  ffmpeg
  fd
  font-awesome
  hack-font
  noto-fonts
  noto-fonts-emoji
  meslo-lgs-nf
  nerdfonts

  # Text and terminal utilities
  htop
  hunspell
  iftop
  jetbrains-mono
  jq
  ripgrep
  tree
  unzip
]
