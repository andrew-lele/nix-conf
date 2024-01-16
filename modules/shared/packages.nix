{ pkgs }:

with pkgs; [
  # General packages for development and system management
  act
  alacritty
  aspell
  bash-completion
  bat
  btop
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
  age-plugin-yubikey
  gnupg
  libfido2
  pinentry
  yubikey-manager

  # Media-related packages
  dejavu_fonts
  ffmpeg
  fd
  font-awesome
  hack-font
  noto-fonts
  noto-fonts-emoji
  meslo-lgs-nf

  # Text and terminal utilities
  htop
  hunspell
  iftop
  jetbrains-mono
  jq
  ripgrep
  tree
  unrar
  unzip
]
