{ pkgs }:

with pkgs;
[
  # General packages for development and system management
  alacritty
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
  difftastic
  oh-my-zsh
  thefuck
  podman
  kind
  go
  python313
  yq
  zsh-vi-mode

  fd
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
  helm-docs
  kubectx
  cilium-cli
  hubble
  (writeShellScriptBin "helmSetup" ''
    echo "Setting up helm! !"
    helm upgrade cilium --install /home/le/workspaces/lab/k8s/cilium --namespace kube-system
  '')
]
