-- Neovim Configuration Entry Point

-- Load core configuration
require('core.options')
require('core.keymaps')
require('core.autocmds')

-- Load plugin configurations
require('plugins.init')
require('plugins.completion')
require('plugins.lsp')
require('plugins.ui')
require('plugins.git')
require('plugins.editor')
