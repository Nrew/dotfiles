return {
  -- Mason is disabled — all LSP binaries come from nix extraPackages
  { "mason-org/mason.nvim", enabled = false },
  { "mason-org/mason-lspconfig.nvim", enabled = false },
  { "WhoIsSethDaniel/mason-tool-installer.nvim", enabled = false },

  -- Configure LSP servers (binaries are on PATH via nix)
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        lua_ls = {},
        nixd = {},
        ts_ls = {},        -- TypeScript (formerly tsserver)
        pyright = {},
        rust_analyzer = {},
        clangd = {},
      },
    },
  },
}
