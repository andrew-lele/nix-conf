local options = {
  lsp_fallback = true,
  formatters_by_ft = {
    lua = { "stylua" },
    sh = { "shfmt" },
    rust = { "rust-analyzer" },
    nix = { "nixpkgs-fmt" },
    yaml = { "yamlfmt" },
  },
  format_on_save = {
    -- These options will be passed to conform.format()
    timeout_ms = 500,
    lsp_fallback = true,
  },
}
-- require("conform").setup(options)
return options
