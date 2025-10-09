if vim.loader then
  vim.loader.enable()
end

require("core.options")
require("core.keymaps")
require("core.autocmds")

-- Initialize plugins using the setup module
require("nvim_setup").setup()

