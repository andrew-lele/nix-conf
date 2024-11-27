{
  description = "Example nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    alacritty-theme.url = "github:alexghr/alacritty-theme.nix";
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      alacritty-theme,
      ...
    }:
    {
      nixosConfigurations = {
        # Define the configuration for the hostname
        mitchell = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            # Ensure your host module is present
            ./hosts/mitchell
            (
              { config, pkgs, ... }:
              {
                nixpkgs.overlays = [ alacritty-theme.overlays.default ];
              }
            )

            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.le = import ./home/users/le;
              home-manager.backupFileExtension = "hm-bak";
              # Optionally, add more user definitions if needed
            }
          ];
        };
      };

      # Define Home Manager outputs
      homeManagerConfigurations = {
        le = home-manager.lib.homeManagerConfiguration {
          username = "le";
          homeDirectory = "/home/le";
          configuration = import ./home/users/le;
        };
        k8s = home-manager.lib.homeManagerConfiguration {
          username = "k8s";
          homeDirectory = "/home/k8s";
          configuration = import ./home/users/k8s.nix;
        };
      };
    };
}
