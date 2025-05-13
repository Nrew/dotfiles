-- Keymaps Configuration
-- Follows Google Lua Style Guide
-- Description: Key mappings for neovim

local M = {}

-- Helper function for setting keymaps
local function map(mode, lhs, rhs, opts)
  local options = { noremap = true, silent = true }
  if opts then
    options = vim.tbl_extend("force", options, opts)
  end
  vim.keymap.set(mode, lhs, rhs, options)
end

function M.setup()
  -- Normal mode
  
  -- Better up/down
  map({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { expr = true })
  map({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { expr = true })
  
  -- Move to window using the <ctrl> hjkl keys
  map("n", "<C-h>", "<C-w>h", { desc = "Go to left window" })
  map("n", "<C-j>", "<C-w>j", { desc = "Go to lower window" })
  map("n", "<C-k>", "<C-w>k", { desc = "Go to upper window" })
  map("n", "<C-l>", "<C-w>l", { desc = "Go to right window" })
  
  -- Resize window using <ctrl> arrow keys
  map("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase window height" })
  map("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease window height" })
  map("n", "<C-Left>", "<cmd>vertical resize -2<cr>", 
    { desc = "Decrease window width" })
  map("n", "<C-Right>", "<cmd>vertical resize +2<cr>", 
    { desc = "Increase window width" })
  
  -- Move Lines
  map("n", "<A-j>", "<cmd>m .+1<cr>==", { desc = "Move down" })
  map("n", "<A-k>", "<cmd>m .-2<cr>==", { desc = "Move up" })
  
  -- buffers
  map("n", "<leader>bb", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })
  
  -- Clear search with <esc>
  map({ "i", "n" }, "<esc>", "<cmd>noh<cr><esc>", { desc = "Escape and clear hlsearch" })
  
  -- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
  map("n", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" })
  map("x", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" })
  map("o", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" })
  map("n", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev search result" })
  map("x", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev search result" })
  map("o", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev search result" })
  
  -- Add undo break-points
  map("i", ",", ",<c-g>u")
  map("i", ".", ".<c-g>u")
  map("i", ";", ";<c-g>u")
  
  -- better indenting
  map("v", "<", "<gv")
  map("v", ">", ">gv")
  
  -- Insert mode
  map("i", "<C-h>", "<Left>", { desc = "Move left" })
  map("i", "<C-l>", "<Right>", { desc = "Move right" })
  map("i", "<C-j>", "<Down>", { desc = "Move down" })
  map("i", "<C-k>", "<Up>", { desc = "Move up" })
  
  -- Visual mode
  map("v", "<A-j>", ":m '>+1<cr>gv=gv", { desc = "Move down" })
  map("v", "<A-k>", ":m '<-2<cr>gv=gv", { desc = "Move up" })
  
  -- Terminal mode
  map("t", "<esc><esc>", "<c-\\><c-n>", { desc = "Enter Normal Mode" })
  map("t", "<C-h>", "<cmd>wincmd h<cr>", { desc = "Go to left window" })
  map("t", "<C-j>", "<cmd>wincmd j<cr>", { desc = "Go to lower window" })
  map("t", "<C-k>", "<cmd>wincmd k<cr>", { desc = "Go to upper window" })
  map("t", "<C-l>", "<cmd>wincmd l<cr>", { desc = "Go to right window" })
  
  -- Windows
  map("n", "<leader>ww", "<C-W>p", { desc = "Other window" })
  map("n", "<leader>wd", "<C-W>c", { desc = "Delete window" })
  map("n", "<leader>w-", "<C-W>s", { desc = "Split window below" })
  map("n", "<leader>w|", "<C-W>v", { desc = "Split window right" })
  map("n", "<leader>-", "<C-W>s", { desc = "Split window below" })
  map("n", "<leader>|", "<C-W>v", { desc = "Split window right" })
  
  -- Tabs
  map("n", "<leader><tab>l", "<cmd>tablast<cr>", { desc = "Last Tab" })
  map("n", "<leader><tab>f", "<cmd>tabfirst<cr>", { desc = "First Tab" })
  map("n", "<leader><tab><tab>", "<cmd>tabnew<cr>", { desc = "New Tab" })
  map("n", "<leader><tab>]", "<cmd>tabnext<cr>", { desc = "Next Tab" })
  map("n", "<leader><tab>d", "<cmd>tabclose<cr>", { desc = "Close Tab" })
  map("n", "<leader><tab>[", "<cmd>tabprevious<cr>", { desc = "Previous Tab" })
  
  -- Quit
  map("n", "<leader>qq", "<cmd>qa<cr>", { desc = "Quit all" })
  
  -- Diagnostic keymaps
  map("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to previous diagnostic" })
  map("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next diagnostic" })
  map("n", "<leader>e", vim.diagnostic.open_float, { desc = "Open floating diagnostic" })
  map("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic quickfix" })
end

return M
