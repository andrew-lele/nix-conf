{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = ./.;
  nix.optimise.automatic = lib.mkDefault true;
  nix.settings = {
    extra-experimental-features = [
      "flakes"
      "nix-command"
    ];
    trusted-users = [
      "root"
      config.my.user
    ];
  };
  nix.package = pkgs.lix;
  programs = {
    gnupg.agent.enable = true;
    # Needed for anything GTK related
    dconf.enable = true;
    # My shell
    fish.enable = true;
    neovim.enable = true;
  };
  environment.systemPackages = with pkgs; [
    vim
    gitAndTools.gitFull
    inetutils
  ];
  time.timeZone = "America/New_York";
}
