-- Neovim Options Configuration
-- Follows Google Lua Style Guide
-- Description: Core neovim options and settings

local M = {}

function M.setup()
  -- General settings
  vim.opt.undofile = true
  vim.opt.backup = false
  vim.opt.swapfile = false
  vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
  
  -- Appearance
  vim.opt.number = true
  vim.opt.relativenumber = true
  vim.opt.signcolumn = "yes"
  vim.opt.colorcolumn = "80"
  vim.opt.cursorline = true
  vim.opt.termguicolors = true
  vim.opt.showmode = false
  vim.opt.conceallevel = 0
  
  -- Behavior
  vim.opt.scrolloff = 8
  vim.opt.sidescrolloff = 8
  vim.opt.isfname:append("@-@")
  vim.opt.updatetime = 50
  vim.opt.timeoutlen = 300
  vim.opt.clipboard = "unnamedplus"
  vim.opt.mouse = "a"
  
  -- Search
  vim.opt.hlsearch = false
  vim.opt.incsearch = true
  vim.opt.ignorecase = true
  vim.opt.smartcase = true
  
  -- Indentation
  vim.opt.tabstop = 2
  vim.opt.softtabstop = 2
  vim.opt.shiftwidth = 2
  vim.opt.expandtab = true
  vim.opt.smartindent = true
  vim.opt.autoindent = true
  
  -- Completion
  vim.opt.completeopt = { "menuone", "noselect" }
  vim.opt.pumheight = 10
  vim.opt.pumblend = 10
  
  -- Splits
  vim.opt.splitbelow = true
  vim.opt.splitright = true
  
  -- Folding
  vim.opt.foldmethod = "indent"
  vim.opt.foldlevel = 20
  vim.opt.foldlevelstart = 20
  
  -- Netrw
  vim.g.netrw_browse_split = 0
  vim.g.netrw_banner = 0
  vim.g.netrw_winsize = 25
  
  -- Disable builtin plugins
  local DISABLED_BUILTIN_PLUGINS = {
    "netrw",
    "netrwPlugin",
    "netrwSettings",
    "netrwFileHandlers",
    "2html_plugin",
    "getscript",
    "getscriptPlugin",
    "gzip",
    "logipat",
    "matchit",
    "tar",
    "tarPlugin",
    "rrhelper",
    "spellfile_plugin",
    "vimball",
    "vimballPlugin",
    "zip",
    "zipPlugin",
  }
  
  for _, plugin in pairs(DISABLED_BUILTIN_PLUGINS) do
    vim.g["loaded_" .. plugin] = 1
  end
end

return M
