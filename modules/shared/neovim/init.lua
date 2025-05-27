-- Set leader keys before anything else
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Load core configuration
require("core.options").setup()
require("core.keymaps").setup()
require("core.autocmds").setup()

-- Load plugins using nixCats deferred loading
vim.schedule(function()
  require("plugins")
end)