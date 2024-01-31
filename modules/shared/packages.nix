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
  zsh
  kubectl
  kubernetes-helm
  kubernetes-helmPlugins.helm-unittest
  rustup
  starship
  lazygit
  devspace
  direnv
  podman
  qemu

  # Encryption and security tools
  age
  gnupg
  libfido2

  # dejavu_fonts
  fd
  # noto-fonts
  # noto-fonts-emoji
  meslo-lgs-nf
<<<<<<< HEAD
  (nerdfonts.override { fonts = [ 
    "JetBrainsMono"
  ];})
  powerline-symbols
  powerline-fonts
=======

>>>>>>> 24eaa36 (fix: alacritty, add some gitsigns. remove nerd fonts)
  # Text and terminal utilities
  htop
  hunspell
  iftop
  jq
  ripgrep
  tree
  unzip

#work
  # google-cloud-sdk
  (google-cloud-sdk.withExtraComponents( with google-cloud-sdk.components; [
    gke-gcloud-auth-plugin
  ]))
  hugo
  crystal
  helm-docs
]
