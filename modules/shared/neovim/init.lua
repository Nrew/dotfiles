-- Load core configuration
require("core.options").setup()
require("core.keymaps").setup()
require("core.autocmds").setup()

-- Load plugins using nixCats deferred loading
local plugin_loader = require("core.plugin-loader")
plugin_loader.load_all()

print("Neovim configuration with nixCats loaded!")