require("lazy").setup({
  spec = {
    -- LazyVim core
    { "LazyVim/LazyVim", import = "lazyvim.plugins" },

    -- Import custom plugins
    { import = "plugins" },
  },
  defaults = {
    lazy = true,
    version = false,
  },
  install = { colorscheme = { "catppuccin", "habamax" } },
  checker = { enabled = true },
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})
