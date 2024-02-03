{ config, lib, pkgs, ... }:

{
  enable = true;
  extraPackages = with pkgs; [
    lua-language-server
    stylua
    nil
    rust-analyzer
    helm-ls
    yaml-language-server
    # Telescope
    ripgrep
    yamlfmt
    yamllint
    yaml-language-server
    golangci-lint
    golangci-lint-langserver
    shellcheck
    nixpkgs-fmt
  ];

  plugins = with pkgs.vimPlugins; [
    lazy-nvim
  ];

  extraLuaConfig =
    let
      plugins = with pkgs.vimPlugins; [
        bufferline-nvim
        cmp-buffer
        cmp-nvim-lsp
        cmp-path
        cmp_luasnip
        conform-nvim
        dashboard-nvim
        dressing-nvim
        flash-nvim
        friendly-snippets
        gitsigns-nvim
        indent-blankline-nvim
        lualine-nvim
        neo-tree-nvim
        neoconf-nvim
        neodev-nvim
        noice-nvim
        nui-nvim
        nvim-cmp
        nvim-lint
        nvim-lspconfig
        nvim-notify
        nvim-spectre
        nvim-treesitter
        nvim-treesitter-context
        nvim-treesitter-textobjects
        nvim-ts-autotag
        nvim-ts-context-commentstring
        nvim-web-devicons
        persistence-nvim
        plenary-nvim
        telescope-fzf-native-nvim
        telescope-nvim
        todo-comments-nvim
        tokyonight-nvim
        trouble-nvim
        vim-illuminate
        vim-startuptime
        which-key-nvim
        vim-fugitive
        vim-helm
        { name = "LuaSnip"; path = luasnip; }
        { name = "catppuccin"; path = catppuccin-nvim; }
        { name = "mini.ai"; path = mini-nvim; }
        { name = "mini.bufremove"; path = mini-nvim; }
        { name = "mini.comment"; path = mini-nvim; }
        { name = "mini.indentscope"; path = mini-nvim; }
        { name = "mini.pairs"; path = mini-nvim; }
        { name = "mini.surround"; path = mini-nvim; }
      ];
      mkEntryFromDrv = drv:
        if lib.isDerivation drv then
          { name = "${lib.getName drv}"; path = drv; }
        else
          drv;
      lazyPath = pkgs.linkFarm "lazy-plugins" (builtins.map mkEntryFromDrv plugins);
      in
      ''
require "core"

local custom_init_path = vim.api.nvim_get_runtime_file("lua/custom/init.lua", false)[1]

if custom_init_path then
  dofile(custom_init_path)
end

require("core.utils").load_mappings()

dofile(vim.g.base46_cache .. "defaults")
vim.opt.rtp:prepend("${lazyPath}")
require "plugins"
      '';
}
