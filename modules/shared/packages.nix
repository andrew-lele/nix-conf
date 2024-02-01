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
  kubectl
  kubernetes-helm
  rustup
  starship
  

  # Encryption and security tools
  age
  gnupg
  libfido2

  # dejavu_fonts
  fd
  # noto-fonts
  # noto-fonts-emoji
  meslo-lgs-nf
  (nerdfonts.override { fonts = [ 
    "JetBrainsMono"
  ];})
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
  (google-cloud-sdk.withExtraComponents( with google-cloud-sdk.components; [
    gke-gcloud-auth-plugin
  ]))
]
