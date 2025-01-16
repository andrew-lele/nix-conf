{
  inputs,
  self,
  withSystem,
  pkgs,
  config,
  ...
}:

let
  mkHome = import ../library/mk-system.nix {
    inherit inputs self withSystem;
    defaultSystem = "x86_64-linux";
    defaultModules = [
      (
        { lib, pkgs, ... }:
        {
          # news.display = "silent";
          # news.json = lib.mkForce { };
          # news.entries = lib.mkForce [ ];
          # set the same option as home-manager in nixos/nix-darwin, to generate the same derivation
          nix.package = pkgs.nix;
        }
      )
      ../common/home.nix
    ];
    applyFunction =
      args@{ ... }:
      args.inputs.home-manager.lib.homeManagerConfiguration {
        inherit (args) pkgs modules;
        extraSpecialArgs = {
          inherit (args) inputs inputs';
          lib = import (args.inputs.home-manager + "/modules/lib/stdlib-extended.nix") args.lib;
        };
      };
  };
in
{
  flake.homeConfigurations = {
    le = mkHome {
      modules = [
        {
          home.username = "le";
          home.homeDirectory = "/home/le";
          shell = pkgs.fish;
        }
      ];
    };

    "le@mac" = mkHome {
      system = "x86_64-darwin";
      modules = [
        {
          home.username = "le";
          home.homeDirectory = "/Users/le";
          extraGroups = [
            "wheel" # Enable ‘sudo’ for the user.
            "networkmanager"
          ];
          shell = pkgs.fish;
          openssh.authorizedKeys.keys = config.keys;
          #      openssh.authorizedKeys.keys  = [ "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCul+vpn+aybmohQMZ9IuRoZsqJHRyJ42UahkzwqQbgkNFnrnuXVx0vIXLW2il0jORFb+i5j337Ps7A+XkFUccH3UyqIWiUl62N5Bn37uLeP37lmtcAyTQ2avLG052lWY8h+yJUezRd9wCSHj7GBn0pyY8f8t7CbqwzUDLUbG4U1yQhXdnG/Agrcm7BZsa0GfqRqH+kqYVfESritBQpJvB6IkPP1dG8iFOrzMoTQvvmOC5937QHpUOIwO+4Vu9cldWBhtJT+XcW5SYw8KRyihwTUpvPIfqAzx/HjtxcuwJmN+JRBK5P/Vy36kK6ip882PnNvlsGrqUYxMM/d/lRZV23YsGHSAZPjK0pykJTB2NyTaJiNit6gCzj8za18ak4c7dTYsy8fhifZ7zh/u7H4e+a6XPG5KNHs0Hx3D+7qE1da4dWXXnvxksDwRIHRTCFmgHdxg7A3Q056T4bOzdGZDFcRHw2CmXW+uAD2kwKqbvP0sm35H36qbJBwBJI0Q0Ry7c= le@mac.self" ];
          initialHashedPassword = "$6$rrL.IYVFk5RgIrtt$uQQSVWYiuGIJucBM3yYWmY.94teIhiUNQ2inuFqPMfwGwZk2m32i7vhASG3sX6cVOqz/TrH9RPfp1O3vVbyLC/";
          # my.desktop.enable = true;
          # my.firefox.enable = true;
          # my.rime.enable = true;
          # my.emacs.enable = true;
        }
        ../darwin/home.nix
      ];
    };
  };

  perSystem =
    {
      self',
      inputs',
      pkgs,
      ...
    }:
    {
      packages.home-manager = inputs'.home-manager.packages.default;
      apps.init-home.program = pkgs.writeShellScriptBin "init-home" ''
        ${self'.packages.home-manager}/bin/home-manager --extra-experimental-features "nix-command flakes" switch --flake "${self}" "$@"
      '';
    };
}
