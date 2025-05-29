local M = {}

function M.setup()
  local g   = vim.g   -- Global variables
  local opt = vim.opt -- Set options

  -- ──────────────────────────────────────────────────────────────────
  -- Global Variables (vim.g)
  -- ──────────────────────────────────────────────────────────────────
  g.mapleader         = " "
  g.maplocalleader    = " "
  g.have_nerd_fonts   = true -- Assume Nerd Fonts are managed by Nix

  -- ──────────────────────────────────────────────────────────────────
  -- Core Editor Behavior & File Handling
  -- ──────────────────────────────────────────────────────────────────
  opt.mouse           = "a"           -- Enable mouse support in all modes
  opt.clipboard       = "unnamedplus" -- Use system clipboard

  opt.swapfile        = false         -- Do not create swap files
  opt.backup          = false         -- Do not create backup files
  opt.undofile        = true          -- Enable persistent undo

  local undodir_path  = vim.fn.stdpath("data") .. "/undodir"
  opt.undodir         = undodir_path
  if vim.fn.isdirectory(vim.fn.expand(undodir_path)) == 0 then
    local ok, _ = pcall(vim.fn.mkdir, undodir_path, "p")
    if not ok then
      vim.notify("Failed to create undo directory: " .. undodir_path, vim.log.levels.WARN, { title = "Options Setup" })
    end
  end

  opt.confirm         = true          -- Prompt before discarding unsaved changes
  opt.autowriteall    = true          -- Automatically save on certain actions
  opt.hidden          = true          -- Allow switching buffers without saving
  opt.isfname:append("@-@")           -- Add '@', '-' to filename characters

  opt.updatetime      = 100           -- Interval for CursorHold, plugin updates (ms)
  opt.timeoutlen      = 300           -- Time to wait for a mapped sequence (ms)

  -- ──────────────────────────────────────────────────────────────────
  -- UI & Appearance
  -- ──────────────────────────────────────────────────────────────────
  opt.termguicolors   = true          -- Enable 24-bit RGB colors

  opt.number          = true          -- Show line numbers
  opt.relativenumber  = true          -- Show relative line numbers
  opt.numberwidth     = 2             -- Min columns for line number

  opt.signcolumn      = "yes:1"       -- Always show signcolumn, width 1
  opt.colorcolumn     = "80,100"      -- Highlight columns 80 and 100 (adjust as needed)

  opt.wrap            = true          -- Enable soft text wrapping
  opt.linebreak       = true          -- Wrap lines at word boundaries
  opt.breakindent     = true          -- Maintain indentation for wrapped lines
  opt.showbreak       = "↪ "          -- Character for wrapped lines

  opt.scrolloff       = 8             -- Keep 8 lines visible around cursor
  opt.sidescrolloff   = 8             -- Keep 8 columns visible around cursor

  opt.pumheight       = 10            -- Max items in popup menu
  opt.pumblend        = 10            -- Pseudo-transparency for popup menu

  opt.showmode        = false         -- Statusline handles mode display
  opt.showtabline     = 2             -- Always show the tabline
  opt.laststatus      = 3             -- Always show a global statusline
  opt.cmdheight       = 1             -- Height of command line (0 if noice.nvim manages it)
  opt.showcmd         = false         -- Statusline/noice handles partial command display

  opt.fillchars       = { eob = " ", diff = "╱", vert = "│", fold = " " }
  opt.shortmess:append("sIc")         -- s:no search count, I:no intro, c:completion msgs

  -- ──────────────────────────────────────────────────────────────────
  -- Editing & Search
  -- ──────────────────────────────────────────────────────────────────
  opt.ignorecase      = true          -- Ignore case in search
  opt.smartcase       = true          -- Override ignorecase if uppercase used
  opt.hlsearch        = true          -- Highlight all search matches
  opt.incsearch       = true          -- Show search results incrementally
  opt.inccommand      = "nosplit"     -- Live preview for :s (or 'split')

  opt.completeopt     = { "menuone", "noselect", "preview" } -- Autocomplete options

  opt.expandtab       = true          -- Use spaces instead of tabs
  opt.tabstop         = 2             -- Spaces for a TAB character
  opt.softtabstop     = 2             -- Spaces for TAB key in insert mode
  opt.shiftwidth      = 2             -- Spaces for auto/manual indent
  opt.autoindent      = true          -- Copy indent from current line
  opt.smartindent     = true          -- Smarter indenting for C-like languages

  opt.list            = true          -- Show invisible characters
  opt.listchars       = { tab = "󰌒 ", trail = "·", nbsp = "␣", extends = "⟩", precedes = "⟨" }
  -- Fallback: opt.listchars = { tab = '> ', trail = '·', nbsp = '_', extends = '>', precedes = '<' }

  -- ──────────────────────────────────────────────────────────────────
  -- Window Management & Navigation
  -- ──────────────────────────────────────────────────────────────────
  opt.splitbelow      = true          -- New horizontal splits go below
  opt.splitright      = true          -- New vertical splits go right
  opt.splitkeep       = "screen"      -- Stabilize view on window split/close
  opt.jumpoptions     = "view"        -- Restore view on jumps

  -- ──────────────────────────────────────────────────────────────────
  -- Folding 
  -- ──────────────────────────────────────────────────────────────────
  opt.foldmethod      = "expr"        -- Use expression for folding
  opt.foldexpr        = "nvim_treesitter#foldexpr()" -- Treesitter folding expression
  opt.foldlevel       = 99            -- Start with most folds open
  opt.foldlevelstart  = 99            -- Fold level for new buffers
  opt.foldenable      = true          -- Enable folding
  opt.foldcolumn      = "0"           -- '0' hides fold column, '1' shows it

  vim.notify("NixCats Neovim options loaded!", vim.log.levels.INFO, { title = "Neovim Setup" })
end

return M