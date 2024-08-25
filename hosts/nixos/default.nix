{ config, inputs, pkgs, agenix, ... }:

let user = "le";
    keys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINFIYMrKpYQnWTnYdRj1TssL+otUWu8358ZcbbTJItbt le@mac.self
"]; in
{
  imports = [
    ../../modules/nixos/secrets.nix
    ../../modules/shared
    ../../modules/shared/cachix

    ./hardware-config-reference.nix 
    ./zfs.nix
    agenix.nixosModules.default
  ];

  # Backup user is always good to have :)
  users.users.andrew = {
    isNormalUser  = true;
    home  = "/home/andrew";
    description  = "the HAND";
    extraGroups  = [ "wheel" "networkmanager" ];
    openssh.authorizedKeys.keys  = [ "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCul+vpn+aybmohQMZ9IuRoZsqJHRyJ42UahkzwqQbgkNFnrnuXVx0vIXLW2il0jORFb+i5j337Ps7A+XkFUccH3UyqIWiUl62N5Bn37uLeP37lmtcAyTQ2avLG052lWY8h+yJUezRd9wCSHj7GBn0pyY8f8t7CbqwzUDLUbG4U1yQhXdnG/Agrcm7BZsa0GfqRqH+kqYVfESritBQpJvB6IkPP1dG8iFOrzMoTQvvmOC5937QHpUOIwO+4Vu9cldWBhtJT+XcW5SYw8KRyihwTUpvPIfqAzx/HjtxcuwJmN+JRBK5P/Vy36kK6ip882PnNvlsGrqUYxMM/d/lRZV23YsGHSAZPjK0pykJTB2NyTaJiNit6gCzj8za18ak4c7dTYsy8fhifZ7zh/u7H4e+a6XPG5KNHs0Hx3D+7qE1da4dWXXnvxksDwRIHRTCFmgHdxg7A3Q056T4bOzdGZDFcRHw2CmXW+uAD2kwKqbvP0sm35H36qbJBwBJI0Q0Ry7c= le@mac.self" ];
  };

  # Set your time zone.
  time.timeZone = "America/New_York";

  networking.hostName = "nixos"; # Define your hostname.

  # Turn on flag for proprietary software
  nix = {
    nixPath = [ "nixos-config=/home/${user}/.local/share/src/nixos-config:/etc/nixos" ];
    settings.allowed-users = [ "${user}", le, root ];
    package = pkgs.nixUnstable;
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
    # xserver = {
    #   enable = true;
    #
    #   # Uncomment these for AMD or Nvidia GPU
    #   # boot.initrd.kernelModules = [ "amdgpu" ];
    #   # services.xserver.videoDrivers = [ "amdgpu" ];
    #   # services.xserver.videoDrivers = [ "nvidia" ];
    #
    #   # Comment this for AMD GPU
    #   # This helps fix tearing of windows for Nvidia cards
    #   # services.xserver.screenSection = ''
    #   #   Option       "metamodes" "nvidia-auto-select +0+0 {ForceFullCompositionPipeline=On}"
    #   #   Option       "AllowIndirectGLXProtocol" "off"
    #   #   Option       "TripleBuffer" "on"
    #   # '';
    #
    #   # LightDM Display Manager
    #
    #   # Turn Caps Lock into Ctrl
    #   layout = "us";
    #   xkbOptions = "ctrl:nocaps";
    #
    #   # Better support for general peripherals
    #   libinput.enable = true;
    # };

    # Let's be able to SSH into this machine
    openssh.enable = true;
    networking.firewall.enable = false;
  

    # Sync state between machines
    # Sync state between machines
    # syncthing = {
    #   enable = true;
    #   openDefaultPorts = true;
    #   dataDir = "/home/${user}/.local/share/syncthing";
    #   configDir = "/home/${user}/.config/syncthing";
    #   user = "${user}";
    #   group = "users";
    #   guiAddress = "127.0.0.1:8384";
    #   overrideFolders = true;
    #   overrideDevices = true;
    #
    #   settings = {
    #     devices = {};
    #     options.globalAnnounceEnabled = false; # Only sync on LAN
    #   };
    # };

    # gvfs.enable = true; # Mount, trash, and other functionalities
  };


  # explicitly define my user.. for now...
  users.users = {
    ${user} = {
      isNormalUser = true;
      extraGroups = [
        "wheel" # Enable ‘sudo’ for the user.
        "networkmanager"
      ];
      shell = pkgs.fish;
      openssh.authorizedKeys.keys = keys;
    };
  };

  # Don't require password for users in `wheel` group for these commands
  security.sudo = {
    enable = true;
    extraRules = [{
      commands = [
       {
         command = "${pkgs.systemd}/bin/reboot";
         options = [ "NOPASSWD" ];
        }
      ];
      groups = [ "wheel" ];
    }];
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

  environment.systemPackages = with pkgs; [
    agenix.packages."${pkgs.system}".default # "x86_64-linux"
    vim
    gitAndTools.gitFull
    inetutils
  ];

  system.stateVersion = "24.05"; # Don't change this
}
