{
  inputs,
  withSystem,
  ...
}:

let
  mkNixos = import ../library/mk-system.nix {
    inherit inputs withSystem;
    defaultSystem = "x86_64-linux";
    defaultModules = [ ../nixos ];
    applyFunction =
      args@{ ... }:
      args.nixpkgs.lib.nixosSystem {
        inherit (args) system modules;
        specialArgs = {
          inherit (args)
            inputs
            inputs'
            lib
            pkgs
            ;
        };
      };
  };
in
{
  flake.nixosConfigurations = {
    jihun = mkNixos { modules = [ ../hosts/jihun.nix ]; };
    mitchell = mkNixos { modules = [ ../hosts/mitchell.nix ]; };
  };
}
