{
  config,
  pkgs,
  lib,
  ...
}:

let
  name = "andrew";
  user = "le";
  email = "andle@paloaltonetworks.com";
in
{

  # Shared shell configuration
  git = {
    enable = true;
    ignores = [ "*.swp" ];
    userName = "andle";
    userEmail = email;
    extraConfig = {
      init.defaultBranch = "main";
      core = {
        editor = "vim";
        autocrlf = "input";
      };
      commit.gpgsign = false;
      pull.rebase = true;
      rebase.autoStash = true;

    };
    lfs = {
      enable = true;
    };
  };

  zsh = {
    enable = true;
    autosuggestion.enable = true;
    enableCompletion = true;
    #    initExtraBeforeCompInit = ''
    #exec fish
    #    '';
  };
  fish = {
    enable = false;
    plugins = with pkgs.fishPlugins; [
      {
        name = "autopair";
        src = autopair.src;
      }
    ];
    shellInit = '''';
    interactiveShellInit = ''
      set fish_greeting # Disable greeting

      alias n="nvim"
      alias hms="home-manager switch"
      alias nhm="n $HOME/.config/home-manager/"
      alias drb="darwin-rebuild switch --flake ~/.config/nix-darwin"
      alias dnsr="sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder"
      alias nrb="cd $HOME/nix-conf/ && nix run .#build-switch"
      alias k="kubectl"
      alias untt="helm dep update && ~/.nix-profile/helm-unittest/untt ."
      alias mfa="~/scripts/mfa.sh"

      ssh-add ~/.ssh/id_github

      # Goes at the end:
      starship init fish | source
      direnv hook fish | source

    '';

  };
  neovim = import ./nvim/lazy.nix { inherit config lib pkgs; };
  vim = {
    enable = true;
    plugins = with pkgs.vimPlugins; [
      vim-airline
      vim-airline-themes
      vim-startify
      vim-tmux-navigator
    ];
    settings = {
      ignorecase = true;
    };
    extraConfig = ''
      "" General
      set number
      set history=1000
      set nocompatible
      set modelines=0
      set encoding=utf-8
      set scrolloff=3
      set showmode
      set showcmd
      set hidden
      set wildmenu
      set wildmode=list:longest
      set cursorline
      set ttyfast
      set nowrap
      set ruler
      set backspace=indent,eol,start
      set laststatus=2
      set clipboard=autoselect

      " Dir stuff
      set nobackup
      set nowritebackup
      set noswapfile
      set backupdir=~/.config/vim/backups
      set directory=~/.config/vim/swap

      " Relative line numbers for easy movement
      set relativenumber
      set rnu

      "" Whitespace rules
      set tabstop=8
      set shiftwidth=2
      set softtabstop=2
      set expandtab

      "" Searching
      set incsearch
      set gdefault

      "" Statusbar
      set nocompatible " Disable vi-compatibility
      set laststatus=2 " Always show the statusline
      let g:airline_theme='bubblegum'
      let g:airline_powerline_fonts = 1

      "" Local keys and such
      let mapleader=","
      let maplocalleader=" "

      "" Change cursor on mode
      :autocmd InsertEnter * set cul
      :autocmd InsertLeave * set nocul

      "" File-type highlighting and configuration
      syntax on
      filetype on
      filetype plugin on
      filetype indent on

      "" Paste from clipboard
      nnoremap <Leader>, "+gP

      "" Copy from clipboard
      xnoremap <Leader>. "+y

      "" Move cursor by display lines when wrapping
      nnoremap j gj
      nnoremap k gk

      "" Map leader-q to quit out of window
      nnoremap <leader>q :q<cr>

      "" Move around split
      nnoremap <C-h> <C-w>h
      nnoremap <C-j> <C-w>j
      nnoremap <C-k> <C-w>k
      nnoremap <C-l> <C-w>l

      "" Easier to yank entire line
      nnoremap Y y$

      "" Move buffers
      nnoremap <tab> :bnext<cr>
      nnoremap <S-tab> :bprev<cr>

      "" Like a boss, sudo AFTER opening the file to write
      cmap w!! w !sudo tee % >/dev/null

      let g:startify_lists = [
        \ { 'type': 'dir',       'header': ['   Current Directory '. getcwd()] },
        \ { 'type': 'sessions',  'header': ['   Sessions']       },
        \ { 'type': 'bookmarks', 'header': ['   Bookmarks']      }
        \ ]

      let g:startify_bookmarks = [
        \ '~/.local/share/src',
        \ ]

      let g:airline_theme='bubblegum'
      let g:airline_powerline_fonts = 1
    '';
  };

  alacritty = {
    enable = true;
    settings = {
      cursor = {
        style = "Block";
      };

      font = {
        normal = {
          family = "JetBrainsMono Nerd Font";
          style = "Regular";
        };
        size = lib.mkMerge [
          (lib.mkIf pkgs.stdenv.hostPlatform.isLinux 10)
          (lib.mkIf pkgs.stdenv.hostPlatform.isDarwin 14.5)
        ];
      };

      # title = "Terminal";
      general = {
        import = [ "${builtins.toString ./.}/alacritty-theme/themes/everforest_dark.toml" ];
      };
      terminal = {
        shell = {
          program = "zsh";
        };

      };
      window = {
        option_as_alt = "OnlyLeft";
      };
    };
  };

  ssh = {
    enable = true;

    extraConfig = lib.mkMerge [
      ''
        Host github.com
          Hostname github.com
          IdentitiesOnly yes
      ''
      (lib.mkIf pkgs.stdenv.hostPlatform.isLinux ''
        IdentityFile /home/${user}/.ssh/id_github
      '')
      (lib.mkIf pkgs.stdenv.hostPlatform.isDarwin ''
        IdentityFile /Users/${user}/.ssh/id_github
      '')
    ];
  };
  starship = {
    enable = true;
    # Configuration written to ~/.config/starship.toml
    settings = {
      add_newline = false;
      format = ''
        󰶞 $directory$nix_shell$git_status$kubernetes$helm$rust$battery
        󱅾   
      '';
      directory = {
        disabled = false;
        format = " ~ [$path]($style)[$read_only]($read_only_style) ";
      };
      git_status = {
        disabled = false;
        ahead = "⇕⇡$\{ahead_count}⇣$\{behind_count}";
        behind = "⇣$\{count}";
      };
      kubernetes = {
        disabled = false;
        format = "[󱃾 $context/\($namespace\)](bold red) ";
      };
      nix_shell = {
        disabled = false;
        impure_msg = "[impure shell](bold red)";
        pure_msg = "[pure shell](bold green)";
        unknown_msg = "[unknown shell](bold yellow)";
        format = " [   $state( \($name\))](bold blue) ";
      };
      rust = {
        disabled = false;
        format = "[ $version](red bold)";
      };
      helm = {
        disabled = false;
        format = "[⎈ $version](bold white) ";
      };
      battery = {
        disabled = false;
        format = "[$percentage$symbol]($style) ";
      };
    };
  };
}
