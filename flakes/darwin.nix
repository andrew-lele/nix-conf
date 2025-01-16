{
  inputs,
  withSystem,
  ...
}:

let
  mkDarwin = import ../library/mk-system.nix {
    inherit inputs withSystem;
    defaultSystem = "aarch64-darwin";
    defaultModules = [ ../darwin ];
    applyFunction =
      args@{ ... }:
      args.inputs.darwin.lib.darwinSystem {
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
  flake.darwinConfigurations = {
    mac = mkDarwin { modules = [ ../hosts/mac.nix ]; };
  };
}
