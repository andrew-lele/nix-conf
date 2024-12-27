{
  config,
  pkgs,
  lib,
  ...
}:

let
  user = "le";
  xdg_configHome = "/home/${user}/.config";
  shared-programs = import ../shared/home-manager.nix { inherit config pkgs lib; };
  shared-files = import ../shared/files.nix { inherit user config pkgs; };

in
{
  home = {
    enableNixpkgsReleaseCheck = false;
    sessionVariables = {
      # KUBECONFIG = "/etc/rancher/k3s/k3s.yaml";
    };
    username = "${user}";
    homeDirectory = "/home/${user}";
    packages = pkgs.callPackage ./packages.nix { };
    file = shared-files // import ./files.nix { inherit user; };
    stateVersion = "24.05";
  };

  xdg.configFile."nvim/parser".source =
    let
      parsers = pkgs.symlinkJoin {
        name = "treesitter-parsers";
        paths =
          (pkgs.vimPlugins.nvim-treesitter.withPlugins (
            plugins: with plugins; [
              c
              lua
              rust
              go
              python
              javascript
              typescript
              markdown
              nix
              html
              bash
              yaml
              toml
              json
              jsonc
            ]
          )).dependencies;
      };
    in
    "${parsers}/parser";

  # Normal LazyVim config here, see https://github.com/LazyVim/starter/tree/main/lua
  xdg.configFile."nvim/lua".source = ../shared/nvim/lua;
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

  programs = shared-programs // {
    gpg.enable = true;
  };

}
