{ config, pkgs, lib, ... }:

let
  user = "le";
  xdg_configHome  = "/home/${user}/.config";
  shared-programs = import ../shared/home-manager.nix { inherit config pkgs lib; };
  shared-files = import ../shared/files.nix { inherit config pkgs; };

in
{
  home = {
    enableNixpkgsReleaseCheck = false;
    username = "${user}";
    homeDirectory = "/home/${user}";
    packages = pkgs.callPackage ./packages.nix {};
    file = shared-files // import ./files.nix { inherit user; };
    stateVersion = "24.05";
  };

  # Use a dark theme
  # gtk = {
  #   enable = true;
  #   iconTheme = {
  #     name = "Adwaita-dark";
  #     package = pkgs.gnome.adwaita-icon-theme;
  #   };
  #   theme = {
  #     name = "Adwaita-dark";
  #     package = pkgs.gnome.adwaita-icon-theme;
  #   };
  # };

  # Screen lock
  services = {
    # Auto mount devices
    udiskie.enable = true;

  };

  programs = shared-programs // { gpg.enable = true; };

}
