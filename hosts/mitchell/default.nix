{
  config,
  inputs,
  pkgs,
  ...
}:

let
  user = "le";
  keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOk8iAnIaa1deoc7jw8YACPNVka1ZFJxhnU4G74TmS+p"
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCul+vpn+aybmohQMZ9IuRoZsqJHRyJ42UahkzwqQbgkNFnrnuXVx0vIXLW2il0jORFb+i5j337Ps7A+XkFUccH3UyqIWiUl62N5Bn37uLeP37lmtcAyTQ2avLG052lWY8h+yJUezRd9wCSHj7GBn0pyY8f8t7CbqwzUDLUbG4U1yQhXdnG/Agrcm7BZsa0GfqRqH+kqYVfESritBQpJvB6IkPP1dG8iFOrzMoTQvvmOC5937QHpUOIwO+4Vu9cldWBhtJT+XcW5SYw8KRyihwTUpvPIfqAzx/HjtxcuwJmN+JRBK5P/Vy36kK6ip882PnNvlsGrqUYxMM/d/lRZV23YsGHSAZPjK0pykJTB2NyTaJiNit6gCzj8za18ak4c7dTYsy8fhifZ7zh/u7H4e+a6XPG5KNHs0Hx3D+7qE1da4dWXXnvxksDwRIHRTCFmgHdxg7A3Q056T4bOzdGZDFcRHw2CmXW+uAD2kwKqbvP0sm35H36qbJBwBJI0Q0Ry7c= le@mac.self"

  ];
  kubernetes = {
    enable = true;
    role = "server";
    clusterInit = true;
    token = "init";
    extraFlags = toString [
      "--flannel-backend=none"
      "--disable-network-policy"
      "--kube-controller-manager-arg=--allocate-node-cidrs"
    ];
  };
in
{
  imports = [
    #    ../../modules/shared
    ./hardware-configuration.nix
  ];

  # Backup user is always good to have :)
  users.users = {
    andrew = {
      isNormalUser = true;
      home = "/home/andrew";
      description = "the HAND";
      extraGroups = [
        "wheel"
        "networkmanager"
      ];
      openssh.authorizedKeys.keys = [
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCul+vpn+aybmohQMZ9IuRoZsqJHRyJ42UahkzwqQbgkNFnrnuXVx0vIXLW2il0jORFb+i5j337Ps7A+XkFUccH3UyqIWiUl62N5Bn37uLeP37lmtcAyTQ2avLG052lWY8h+yJUezRd9wCSHj7GBn0pyY8f8t7CbqwzUDLUbG4U1yQhXdnG/Agrcm7BZsa0GfqRqH+kqYVfESritBQpJvB6IkPP1dG8iFOrzMoTQvvmOC5937QHpUOIwO+4Vu9cldWBhtJT+XcW5SYw8KRyihwTUpvPIfqAzx/HjtxcuwJmN+JRBK5P/Vy36kK6ip882PnNvlsGrqUYxMM/d/lRZV23YsGHSAZPjK0pykJTB2NyTaJiNit6gCzj8za18ak4c7dTYsy8fhifZ7zh/u7H4e+a6XPG5KNHs0Hx3D+7qE1da4dWXXnvxksDwRIHRTCFmgHdxg7A3Q056T4bOzdGZDFcRHw2CmXW+uAD2kwKqbvP0sm35H36qbJBwBJI0Q0Ry7c= le@mac.self"
      ];
      initialHashedPassword = "$6$rrL.IYVFk5RgIrtt$uQQSVWYiuGIJucBM3yYWmY.94teIhiUNQ2inuFqPMfwGwZk2m32i7vhASG3sX6cVOqz/TrH9RPfp1O3vVbyLC/";
    };
    ${user} = {
      isNormalUser = true;
      extraGroups = [
        "wheel" # Enable ‘sudo’ for the user.
        "networkmanager"
      ];
      shell = pkgs.fish;
      openssh.authorizedKeys.keys = keys;
      #      openssh.authorizedKeys.keys  = [ "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCul+vpn+aybmohQMZ9IuRoZsqJHRyJ42UahkzwqQbgkNFnrnuXVx0vIXLW2il0jORFb+i5j337Ps7A+XkFUccH3UyqIWiUl62N5Bn37uLeP37lmtcAyTQ2avLG052lWY8h+yJUezRd9wCSHj7GBn0pyY8f8t7CbqwzUDLUbG4U1yQhXdnG/Agrcm7BZsa0GfqRqH+kqYVfESritBQpJvB6IkPP1dG8iFOrzMoTQvvmOC5937QHpUOIwO+4Vu9cldWBhtJT+XcW5SYw8KRyihwTUpvPIfqAzx/HjtxcuwJmN+JRBK5P/Vy36kK6ip882PnNvlsGrqUYxMM/d/lRZV23YsGHSAZPjK0pykJTB2NyTaJiNit6gCzj8za18ak4c7dTYsy8fhifZ7zh/u7H4e+a6XPG5KNHs0Hx3D+7qE1da4dWXXnvxksDwRIHRTCFmgHdxg7A3Q056T4bOzdGZDFcRHw2CmXW+uAD2kwKqbvP0sm35H36qbJBwBJI0Q0Ry7c= le@mac.self" ];
      initialHashedPassword = "$6$rrL.IYVFk5RgIrtt$uQQSVWYiuGIJucBM3yYWmY.94teIhiUNQ2inuFqPMfwGwZk2m32i7vhASG3sX6cVOqz/TrH9RPfp1O3vVbyLC/";
    };
  };
  # explicitly define my user.. for now...

  # Set your time zone.
  time.timeZone = "America/New_York";

  networking = {
    hostName = "mitchell"; # Define your hostname.
    firewall.enable = false;
    firewall.allowedTCPPorts = [
      6443 # k3s: required so that pods can reach the API server (running on port 6443 by default)
      2379 # k3s, etcd clients: required if using a "High Availability Embedded etcd" configuration
      2380 # k3s, etcd peers: required if using a "High Availability Embedded etcd" configuration
      10250 # k3s, metrics
      4244 # k3s, cilium hubble
    ];
  };

  # Turn on flag for proprietary software
  nix = {
    nixPath = [ "nixos-config=/home/${user}/.local/share/src/nixos-config:/etc/nixos" ];
    settings.allowed-users = [
      "${user}"
      "le"
      "root"
    ];
    package = pkgs.nixVersions.git;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  # Manages keys and such
  programs = {
    gnupg.agent.enable = true;

    # Needed for anything GTK related
    dconf.enable = true;

    # My shell
    fish.enable = true;
  };

  services = {
    k3s = kubernetes;

    # Let's be able to SSH into this machine
    openssh.enable = true;
  };

  # Don't require password for users in `wheel` group for these commands
  security.sudo = {
    enable = true;
    extraRules = [
      {
        commands = [
          {
            command = "${pkgs.systemd}/bin/reboot";
            options = [ "NOPASSWD" ];
          }
        ];
        groups = [ "wheel" ];
      }
    ];
  };

  # fonts.packages = with pkgs; [
  #   dejavu_fonts
  #   emacs-all-the-icons-fonts
  #   feather-font # from overlay
  #   jetbrains-mono
  #   font-awesome
  #   noto-fonts
  #   noto-fonts-emoji
  # ];
  systemd.oomd.enable = false;
  environment.systemPackages = with pkgs; [
    vim
    gitAndTools.gitFull
    inetutils
  ];
  system.stateVersion = "24.05"; # Don't change this
}
