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
  map("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Open floating diagnostic" })
  map("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic quickfix" })
  
  -- Plugin-specific keymaps (when plugins are available)
  if nixCats("general") then
    -- Telescope
    map("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Find Files" })
    map("n", "<leader>fg", "<cmd>Telescope live_grep<cr>", { desc = "Live Grep" })
    map("n", "<leader>fb", "<cmd>Telescope buffers<cr>", { desc = "Buffers" })
    map("n", "<leader>fh", "<cmd>Telescope help_tags<cr>", { desc = "Help Tags" })
    map("n", "<leader>fr", "<cmd>Telescope oldfiles<cr>", { desc = "Recent Files" })
    map("n", "<leader>fc", "<cmd>Telescope colorscheme<cr>", { desc = "Colorscheme" })
    map("n", "<leader>fs", "<cmd>Telescope lsp_document_symbols<cr>", { desc = "Document Symbols" })
    map("n", "<leader>fS", "<cmd>Telescope lsp_workspace_symbols<cr>", { desc = "Workspace Symbols" })
    
    -- Neo-tree
    map("n", "<leader>e", "<cmd>Neotree toggle<cr>", { desc = "Toggle file explorer" })
    map("n", "<leader>o", function()
      if vim.bo.filetype == "neo-tree" then
        vim.cmd.wincmd("p")
      else
        vim.cmd.Neotree("focus")
      end
    end, { desc = "Focus file explorer" })
    
    -- LazyGit
    map("n", "<leader>gg", "<cmd>LazyGit<cr>", { desc = "LazyGit" })
    
    -- Flash
    map({ "n", "x", "o" }, "s", function() require("flash").jump() end, { desc = "Flash" })
    map({ "n", "x", "o" }, "S", function() require("flash").treesitter() end, { desc = "Flash Treesitter" })
    map("o", "r", function() require("flash").remote() end, { desc = "Remote Flash" })
    map({ "o", "x" }, "R", function() require("flash").treesitter_search() end, { desc = "Treesitter Search" })
    map("c", "<c-s>", function() require("flash").toggle() end, { desc = "Toggle Flash Search" })
    
    -- Trouble
    map("n", "<leader>xx", "<cmd>TroubleToggle<cr>", { desc = "Toggle Trouble" })
    map("n", "<leader>xw", "<cmd>TroubleToggle workspace_diagnostics<cr>", { desc = "Workspace Diagnostics" })
    map("n", "<leader>xd", "<cmd>TroubleToggle document_diagnostics<cr>", { desc = "Document Diagnostics" })
    map("n", "gR", "<cmd>TroubleToggle lsp_references<cr>", { desc = "LSP References" })
    
    -- TODO Comments
    map("n", "]t", function() require("todo-comments").jump_next() end, { desc = "Next todo comment" })
    map("n", "[t", function() require("todo-comments").jump_prev() end, { desc = "Previous todo comment" })
    map("n", "<leader>ft", "<cmd>TodoTelescope<cr>", { desc = "Find TODOs" })
    
    -- Buffer management
    map("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Prev buffer" })
    map("n", "<S-l>", "<cmd>bnext<cr>", { desc = "Next buffer" })
    map("n", "[b", "<cmd>bprevious<cr>", { desc = "Prev buffer" })
    map("n", "]b", "<cmd>bnext<cr>", { desc = "Next buffer" })
    
    -- Save file
    map({ "i", "x", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save file" })
    
    -- New file
    map("n", "<leader>fn", "<cmd>enew<cr>", { desc = "New File" })
    
    -- Highlights under cursor
    map("n", "<leader>ui", vim.show_pos, { desc = "Inspect Pos" })
  end
end

return M
