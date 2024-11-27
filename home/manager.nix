{
  config,
  pkgs,
  lib,
  home-manager,
  ...
}:

let
  user = "andle";
  additionalFiles = import ./files.nix { inherit user config pkgs; };
in
{
  #  imports = [
  #   ./dock.nix
  #  ];

  # It me
  users.users.${user} = {
    name = "${user}";
    home = "/Users/${user}";
    isHidden = false;
    shell = pkgs.zsh;
  };

  homebrew = {
    enable = true;
    casks = pkgs.callPackage ./casks.nix { };

    # These app IDs are from using the mas CLI app
    # mas = mac app store
    # https://github.com/mas-cli/mas
    #
    # $ nix shell nixpkgs#mas
    # $ mas search <app name>
    #
    masApps = {
      # "1password" = 1333542190;
      # "wireguard" = 1451685025;
    };
  };

  # Enable home-manager
  home-manager = {
    # https://github.com/nvim-treesitter/nvim-treesitter#i-get-query-error-invalid-node-type-at-position
    useGlobalPkgs = true;
    users.${user} =
      {
        pkgs,
        config,
        lib,
        ...
      }:
      {
        home = {
          activation = {
            copyKubeConf = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
              if [ ! -f "${config.home.homeDirectory}/.kube/config" ]; then
                run --quiet cp -L ${config.home.homeDirectory}/.kube/nix.config ${config.home.homeDirectory}/.kube/config 
                run --quiet chmod u+w ${config.home.homeDirectory}/.kube/config
              fi
            '';
          };
          shellAliases = {
            n = "nvim";
            nrb = "sudo nixos-rebuild switch --flake ~/nix-conf";
            k = "kubectl";
            docker = "podman";
          };
          enableNixpkgsReleaseCheck = false;
          packages = pkgs.callPackage ./packages.nix { };
          file = lib.mkMerge [
            #          sharedFiles
            additionalFiles
            #          # { "emacs-launcher.command".source = myEmacsLauncher; }
          ];
          stateVersion = "24.11";
          sessionVariables = {
            USE_GKE_GCLOUD_AUTH_PLUGIN = "true";
            USER_CODE_PATH = "${config.home.homeDirectory}/workspaces/u42-eng";
          };
        };
        xdg.configFile."amethyst/amethyst.yml".source = ./files/amethyst.yaml;
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
        xdg.configFile."nvim/lua".source = ../nvim/lua;

        programs = { } // import ./programs.nix { inherit config pkgs lib; };

      };
  };

  # Fully declarative dock using the latest from Nix Store
  #  local = { 
  #    dock = {
  #      enable = true;
  #      entries = [
  #        { path = "${pkgs.alacritty}/Applications/Alacritty.app/"; }
  #        {
  #          path = "${config.users.users.${user}.home}/.local/share/";
  #          section = "others";
  #          options = "--sort name --view grid --display folder";
  #        }
  ##        {
  ##          path = "${config.users.users.${user}.home}/.local/share/downloads";
  ##          section = "others";
  ##          options = "--sort name --view grid --display stack";
  ##        }
  #      ];
  #    };
  #  };
}
