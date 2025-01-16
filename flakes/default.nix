# { inputs, ... }:

{
  imports = [
    # inputs.devshell.flakeModule
    ../library/mk-modules.nix
    # ./overlays.nix
    ./darwin.nix
    ./nixos.nix
    ./home-manager.nix
  ];
}
