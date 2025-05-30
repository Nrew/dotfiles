local utils = require("core.utils")

-- Load core modules
require("core.options").setup()
require("core.keymaps").setup()
require("core.autocmds").setup()

-- Load plugins if nixCats available
if utils.get_nixcats() then
  utils.defer(function()
    require("core.plugin-loader").load_all()
  end, 10)
else
  vim.notify("nixCats not available, minimal configuration loaded", vim.log.levels.WARN)
end

vim.notify("NixCats Neovim ready", vim.log.levels.INFO)
