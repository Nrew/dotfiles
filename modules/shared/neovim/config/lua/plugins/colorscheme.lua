return {
  -- nier-automata is a local colors/theme.lua file — no plugin spec needed.
  -- Catppuccin is simply gone from this file; lazy.nvim will stop managing it.

  -- Tell LazyVim to use the local NieR:Automata colorscheme
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "theme",
    },
  },

  -- Wire the lualine theme defined in colors/theme.lua
  {
    "nvim-lualine/lualine.nvim",
    opts = function(_, opts)
      -- vim.g.nier_lualine_theme is set when colors/theme.lua loads
      opts.options = opts.options or {}
      opts.options.theme = vim.g.nier_lualine_theme or "auto"
      return opts
    end,
  },
}
