-- Set leader keys before anything else
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Load core configuration
require("config.options")
require("config.keymaps")
require("config.autocmds")

-- Load plugins using nixCats deferred loading
vim.schedule(function()
  require("plugins")
end)
