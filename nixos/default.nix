{
  inputs,
  pkgs,
  ...
}:

{
  imports = [
    inputs.agenix.nixosModules.default
    inputs.home-manager.nixosModules.home-manager
    ../any
  ] ++ ./system;

  hm.imports = ./home;

  environment.systemPackages = [ pkgs.agenix ];
}
