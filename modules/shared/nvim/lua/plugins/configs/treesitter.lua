local options = {
  ensure_installed = {
    "lua",
    "nix",
    "rust",
    "typescript",
    "json",
    "html",
    "toml",
    "vim",
  },

  highlight = {
    enable = true,
    use_languagetree = true,
  },

  indent = { enable = true },
}

return options
