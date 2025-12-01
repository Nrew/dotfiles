local opt = vim.opt

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
opt.signcolumn = "yes"
opt.scrolloff = 8
opt.sidescrolloff = 8
opt.pumheight = 10
opt.showmode = false
opt.laststatus = 3
opt.fillchars = { eob = " ", diff = "╱" }

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
opt.wrap = false
opt.linebreak = true
opt.breakindent = true
opt.list = true
opt.listchars = { tab = "󰌒 ", trail = "·", extends = "⟩", precedes = "⟨" }

-- Windows
opt.splitbelow = true
opt.splitright = true
opt.splitkeep = "screen"
opt.winblend = 10

-- Completion
opt.completeopt = "menu,menuone,noselect"
opt.pumblend = 10

-- Folding
opt.foldlevel = 99
opt.foldenable = true
