{
  description = "Example nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nix-homebrew = {
      url = "github:zhaofengli-wip/nix-homebrew";
    };
    homebrew-bundle = {
      url = "github:homebrew/homebrew-bundle";
      flake = false;
    };
    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };
    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };
    mac-app-util.url = "github:hraban/mac-app-util";
  };

  outputs =
    inputs@{
      self,
      nix-darwin,
      nixpkgs,
      home-manager,
      nix-homebrew,
      homebrew-bundle,
      homebrew-core,
      homebrew-cask,
      mac-app-util,
    }:
    let
      user = "andle";
      configuration =
        { pkgs, ... }:
        {

          # List packages installed in system profile. To search by name, run:
          # $ nix-env -qaP | grep wget
          environment.systemPackages = [
            pkgs.vim
          ];
          # Auto upgrade nix package and the daemon service.
          services.nix-daemon.enable = true;
          # nix.package = pkgs.nix;

          # Necessary for using flakes on this system.
          nix.settings.experimental-features = "nix-command flakes";
          nix.settings.trusted-users = [
            "root"
            "andle"
          ];
          nix.settings.ssl-cert-file = "/opt/nix-panw.crt";
          nix.gc = {
            user = "root";
            automatic = true;
            interval = {
              Weekday = 0;
              Hour = 2;
              Minute = 0;
            };
            options = "--delete-older-than 30d";
          };

          # Enable alternative shell support in nix-darwin.
          # programs.fish.enable = true;
          # Set Git commit hash for darwin-version.
          system.configurationRevision = self.rev or self.dirtyRev or null;

          # Used for backwards compatibility, please read the changelog before changing.
          # $ darwin-rebuild changelog

          # The platform the configuration will be used on.
          nixpkgs.hostPlatform = "aarch64-darwin";

        };
    in
    {
      # Build darwin flake using:
      # $ darwin-rebuild build --flake .#M-TDL0Y9H4T5
      darwinConfigurations."M-TDL0Y9H4T5" = nix-darwin.lib.darwinSystem {
        modules = [
          configuration
          home-manager.darwinModules.home-manager
          nix-homebrew.darwinModules.nix-homebrew
          mac-app-util.darwinModules.default
          {
            nix-homebrew = {
              inherit user;
              enable = true;
              taps = {
                "homebrew/homebrew-core" = homebrew-core;
                "homebrew/homebrew-cask" = homebrew-cask;
                "homebrew/homebrew-bundle" = homebrew-bundle;
              };
              mutableTaps = false;
              autoMigrate = true;
            };
          }
          ./darwin.nix

        ];
      };

      # Expose the package set, including overlays, for convenience.
      darwinPackages = self.darwinConfigurations."M-TDL0Y9H4T5".pkgs;

      users.users.andle = {
        name = "andle";
        home = "/Users/andle";
      };
      home-manager.users.andle =
        { pkgs, ... }:
        {
          home.packages = [
            pkgs.atool
            pkgs.httpie
          ];
          programs.bash.enable = true;

          # The state version is required and should stay at the version you
          # originally installed.
          home.stateVersion = "24.05";
        };
    };
}
