{
  config,
  pkgs,
  lib,
  ...
}:

let
  user = "le";
  xdg_configHome = "/home/${user}/.config";
  #  shared-programs = import ../shared/home-manager.nix { inherit config pkgs lib; };
  #  shared-files = import ../shared/files.nix { inherit user config pkgs; };

in
{
  home = {
    enableNixpkgsReleaseCheck = false;
    sessionVariables = {
      # KUBECONFIG = "/etc/rancher/k3s/k3s.yaml";
    };
    username = "${user}";
    homeDirectory = "/home/${user}";
    packages = pkgs.callPackage ../../packages.nix { };
    #    file = shared-files // import ./files.nix { inherit user; };
    stateVersion = "24.11";
    #          activation = {
    #            copyKubeConf = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    #              if [ ! -f "${config.home.homeDirectory}/.kube/config" ]; then
    #                run --quiet cp -L ${config.home.homeDirectory}/.kube/nix.config ${config.home.homeDirectory}/.kube/config
    #                run --quiet chmod u+w ${config.home.homeDirectory}/.kube/config
    #              fi
    #            '';
    #          };
    shellAliases = {
      n = "nvim";
      nrb = "sudo nixos-rebuild switch --flake ~/nix-conf";
      k = "kubectl";
      docker = "podman";
    };
  };

  programs = { } // import ../../programs.nix { inherit config pkgs lib; };
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
  xdg.configFile."nvim/lua".source = ../../../nvim/lua;

}
