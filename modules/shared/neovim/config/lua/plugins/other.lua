-- Other Plugin Configurations

-- Auto pairs
require('nvim-autopairs').setup({})

-- Surround
require('nvim-surround').setup({})

-- Comment
require('Comment').setup({})

-- Colorizer (for colors in css, etc)
require('colorizer').setup()

-- Guess indent
require('guess-indent').setup({})

-- UFO (better folding)
require('ufo').setup({
  provider_selector = function(bufnr, filetype, buftype)
    return {'treesitter', 'indent'}
  end
})

-- Stabilize (better scrolling)
require("stabilize").setup()

-- Persistence (session management)
require('persistence').setup({
  dir = vim.fn.expand(vim.fn.stdpath("state") .. "/sessions/"),
  options = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp" },
  pre_save = nil,
})

-- Session commands
vim.api.nvim_create_user_command("SessionRestore", function()
  require("persistence").load()
end, {})

vim.api.nvim_create_user_command("SessionLast", function()
  require("persistence").load({ last = true })
end, {})

vim.api.nvim_create_user_command("SessionStop", function()
  require("persistence").stop()
end, {})

-- vim.bbye plugin (better buffer closing)
-- This requires vim-bbye to be installed
