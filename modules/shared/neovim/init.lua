-- Load core modules
require("core.options").setup()
require("core.keymaps").setup()
require("core.autocmds").setup()

-- Load plugins if nixCats available
local plugin_loader = require("core.plugin-loader")
plugin_loader.load_all()

vim.notify("NixCats Neovim ready", vim.log.levels.INFO)
