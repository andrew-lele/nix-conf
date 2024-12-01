{ pkgs }:

with pkgs;
[
  # General packages for development and system management
  act
  alacritty
  aspell
  bash-completion
  bat
  coreutils
  dig
  killall
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
  go
  hubble

  # Encryption and security tools
  age
  gnupg
  libfido2

  # dejavu_fonts
  fd
  # noto-fonts
  # noto-fonts-emoji
  meslo-lgs-nf
  (nerdfonts.override {
    fonts = [
      "JetBrainsMono"
    ];
  })
  powerline-symbols
  powerline-fonts
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
  (google-cloud-sdk.withExtraComponents (
    with google-cloud-sdk.components;
    [
      gke-gcloud-auth-plugin
    ]
  ))
  hugo
  crystal
  helm-docs
]
