local opt, g = vim.opt, vim.g

-- Leaders
g.mapleader = " "
g.maplocalleader = " "
g.have_nerd_fonts = true

-- Core behavior
opt.mouse = "a"
opt.clipboard = "unnamedplus"
opt.swapfile = false
opt.backup = false
opt.undofile = true
opt.undodir = vim.fn.stdpath("data") .. "/undodir"
opt.confirm = true
opt.autowriteall = true
opt.updatetime = 100
opt.timeoutlen = 300

-- UI
opt.termguicolors = true
opt.number = true
opt.relativenumber = true
opt.signcolumn = "yes:1"
opt.scrolloff = 8
opt.sidescrolloff = 8
opt.pumheight = 10
opt.showmode = false
opt.laststatus = 3
opt.fillchars = { eob = " ", diff = "╱", vert = "│" }

-- Search
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = true
opt.inccommand = "nosplit"

-- Editing
opt.expandtab = true
opt.tabstop = 2
opt.shiftwidth = 2
opt.autoindent = true
opt.smartindent = true
opt.wrap = true
opt.linebreak = true
opt.breakindent = true
opt.list = true
opt.listchars = { tab = "󰌒 ", trail = "·", extends = "⟩", precedes = "⟨" }

-- Windows
opt.splitbelow = true
opt.splitright = true
opt.splitkeep = "screen"
opt.winblend = 10  -- Pseudo-transparency for floating windows

-- Completion
opt.completeopt = { "menuone", "noselect" }
opt.pumblend = 10  -- Pseudo-transparency for popup menu

-- Folding
opt.foldmethod = "expr"
opt.foldexpr = "nvim_treesitter#foldexpr()"
opt.foldlevel = 99
opt.foldenable = true

-- Misc
opt.isfname:append("@-@")
opt.shortmess:append("sIc")