{ pkgs }:

with pkgs; [
  # General packages for development and system management
  alacritty
  bat
  killall
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

  # dejavu_fonts
  # noto-fonts
  # noto-fonts-emoji
  (nerdfonts.override { fonts = [ 
    "JetBrainsMono"
  ];})
  powerline-symbols
  powerline-fonts
  # Text and terminal utilities
  htop
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
