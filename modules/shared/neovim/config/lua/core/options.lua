local opt = vim.opt

-- General
opt.number = true
opt.relativenumber = true
opt.mouse = 'a'
opt.clipboard = 'unnamedplus'
opt.wrap = true
opt.ruler = true
opt.hidden = true

-- Indentation
opt.expandtab = true
opt.shiftwidth = 2
opt.tabstop = 2
opt.softtabstop = 2
opt.autoindent = true
opt.smartindent = true

-- Search
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = true
opt.incsearch = true

-- Splits
opt.splitright = true
opt.splitbelow = true

-- Visual
opt.termguicolors = true
opt.updatetime = 300
opt.timeoutlen = 500
opt.signcolumn = 'yes'
opt.cursorline = true
opt.scrolloff = 10
opt.sidescrolloff = 10
opt.showmode = true
opt.showtabline = 2
opt.laststatus = 3
opt.cmdheight = 1
opt.conceallevel = 0
opt.fileencoding = 'utf-8'

-- Completion
opt.completeopt = 'menu,menuone,noselect'
opt.pumheight = 10

-- Folding
opt.foldmethod = 'expr'
opt.foldexpr = 'nvim_treesitter#foldexpr()'
opt.foldenable = false
opt.foldlevel = 99
opt.foldcolumn = '1'
opt.foldlevelstart = 99

-- File handling
opt.undofile = true
opt.undodir = os.getenv("HOME") .. "/.local/share/nvim/undo"
opt.backup = true
opt.backupdir = os.getenv("HOME") .. "/.local/share/nvim/backup"
opt.directory = os.getenv("HOME") .. "/.local/share/nvim/swap"

-- Other
opt.backspace = 'indent,eol,start'
opt.guifont = 'Maple Mono NF:h14'

-- Set leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "
