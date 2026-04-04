return {
  {
    "stevearc/conform.nvim",
    opts = {
      -- Map filetypes to formatter lists (tried in order, first available wins)
      formatters_by_ft = {
        lua             = { "stylua" },
        nix             = { "nixfmt" },
        python          = { "ruff_format", "black" },
        typescript      = { "prettierd", "prettier" },
        typescriptreact = { "prettierd", "prettier" },
        javascript      = { "prettierd", "prettier" },
        javascriptreact = { "prettierd", "prettier" },
        rust            = { "rustfmt" },
        json            = { "prettierd", "prettier" },
        jsonc           = { "prettierd", "prettier" },
        yaml            = { "prettierd", "prettier" },
        markdown        = { "prettierd", "prettier" },
        ["markdown.mdx"] = { "prettierd", "prettier" },
        css             = { "prettierd", "prettier" },
        html            = { "prettierd", "prettier" },
      },
      -- Format on save; fall back to LSP if no formatter is configured
      format_on_save = {
        timeout_ms = 2000,
        lsp_format = "fallback",
      },
    },
  },
}
