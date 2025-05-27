local utils = require("utils")
local M = {}

function M.setup()
  -- Normal mode
  
  -- Better up/down
  utils.keymap({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { expr = true })
  utils.keymap({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { expr = true })
  
  -- Move to window using the <ctrl> hjkl keys
  utils.keymap("n", "<C-h>", "<C-w>h", { desc = "Go to left window" })
  utils.keymap("n", "<C-j>", "<C-w>j", { desc = "Go to lower window" })
  utils.keymap("n", "<C-k>", "<C-w>k", { desc = "Go to upper window" })
  utils.keymap("n", "<C-l>", "<C-w>l", { desc = "Go to right window" })
  
  -- Resize window using <ctrl> arrow keys
  utils.keymap("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase window height" })
  utils.keymap("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease window height" })
  utils.keymap("n", "<C-Left>", "<cmd>vertical resize -2<cr>", 
    { desc = "Decrease window width" })
  utils.keymap("n", "<C-Right>", "<cmd>vertical resize +2<cr>", 
    { desc = "Increase window width" })
  
  -- Move Lines
  utils.keymap("n", "<A-j>", "<cmd>m .+1<cr>==", { desc = "Move down" })
  utils.keymap("n", "<A-k>", "<cmd>m .-2<cr>==", { desc = "Move up" })
  
  -- buffers
  utils.keymap("n", "<leader>bb", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })
  
  -- Clear search with <esc>
  utils.keymap({ "i", "n" }, "<esc>", "<cmd>noh<cr><esc>", { desc = "Escape and clear hlsearch" })
  
  -- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
  utils.keymap("n", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" })
  utils.keymap("x", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" })
  utils.keymap("o", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" })
  utils.keymap("n", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev search result" })
  utils.keymap("x", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev search result" })
  utils.keymap("o", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev search result" })
  
  -- Add undo break-points
  utils.keymap("i", ",", ",<c-g>u")
  utils.keymap("i", ".", ".<c-g>u")
  utils.keymap("i", ";", ";<c-g>u")
  
  -- better indenting
  utils.keymap("v", "<", "<gv")
  utils.keymap("v", ">", ">gv")
  
  -- Insert mode
  utils.keymap("i", "<C-h>", "<Left>", { desc = "Move left" })
  utils.keymap("i", "<C-l>", "<Right>", { desc = "Move right" })
  utils.keymap("i", "<C-j>", "<Down>", { desc = "Move down" })
  utils.keymap("i", "<C-k>", "<Up>", { desc = "Move up" })
  
  -- Visual mode
  utils.keymap("v", "<A-j>", ":m '>+1<cr>gv=gv", { desc = "Move down" })
  utils.keymap("v", "<A-k>", ":m '<-2<cr>gv=gv", { desc = "Move up" })
  
  -- Terminal mode
  utils.keymap("t", "<esc><esc>", "<c-\\><c-n>", { desc = "Enter Normal Mode" })
  utils.keymap("t", "<C-h>", "<cmd>wincmd h<cr>", { desc = "Go to left window" })
  utils.keymap("t", "<C-j>", "<cmd>wincmd j<cr>", { desc = "Go to lower window" })
  utils.keymap("t", "<C-k>", "<cmd>wincmd k<cr>", { desc = "Go to upper window" })
  utils.keymap("t", "<C-l>", "<cmd>wincmd l<cr>", { desc = "Go to right window" })
  
  -- Windows
  utils.keymap("n", "<leader>ww", "<C-W>p", { desc = "Other window" })
  utils.keymap("n", "<leader>wd", "<C-W>c", { desc = "Delete window" })
  utils.keymap("n", "<leader>w-", "<C-W>s", { desc = "Split window below" })
  utils.keymap("n", "<leader>w|", "<C-W>v", { desc = "Split window right" })
  utils.keymap("n", "<leader>-", "<C-W>s", { desc = "Split window below" })
  utils.keymap("n", "<leader>|", "<C-W>v", { desc = "Split window right" })
  
  -- Tabs
  utils.keymap("n", "<leader><tab>l", "<cmd>tablast<cr>", { desc = "Last Tab" })
  utils.keymap("n", "<leader><tab>f", "<cmd>tabfirst<cr>", { desc = "First Tab" })
  utils.keymap("n", "<leader><tab><tab>", "<cmd>tabnew<cr>", { desc = "New Tab" })
  utils.keymap("n", "<leader><tab>]", "<cmd>tabnext<cr>", { desc = "Next Tab" })
  utils.keymap("n", "<leader><tab>d", "<cmd>tabclose<cr>", { desc = "Close Tab" })
  utils.keymap("n", "<leader><tab>[", "<cmd>tabprevious<cr>", { desc = "Previous Tab" })
  
  -- Quit
  utils.keymap("n", "<leader>qq", "<cmd>qa<cr>", { desc = "Quit all" })
  
  -- Diagnostic keymaps
  utils.keymap("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to previous diagnostic" })
  utils.keymap("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next diagnostic" })
  utils.keymap("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Open floating diagnostic" })
  utils.keymap("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic quickfix" })
  
  -- Plugin-specific keymaps (when plugins are available)
  if utils.nixcats("general") then
    -- Telescope
    utils.keymap("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Find Files" })
    utils.keymap("n", "<leader>fg", "<cmd>Telescope live_grep<cr>", { desc = "Live Grep" })
    utils.keymap("n", "<leader>fb", "<cmd>Telescope buffers<cr>", { desc = "Buffers" })
    utils.keymap("n", "<leader>fh", "<cmd>Telescope help_tags<cr>", { desc = "Help Tags" })
    utils.keymap("n", "<leader>fr", "<cmd>Telescope oldfiles<cr>", { desc = "Recent Files" })
    utils.keymap("n", "<leader>fc", "<cmd>Telescope colorscheme<cr>", { desc = "Colorscheme" })
    utils.keymap("n", "<leader>fs", "<cmd>Telescope lsp_document_symbols<cr>", { desc = "Document Symbols" })
    utils.keymap("n", "<leader>fS", "<cmd>Telescope lsp_workspace_symbols<cr>", { desc = "Workspace Symbols" })
    
    -- Neo-tree
    utils.keymap("n", "<leader>e", "<cmd>Neotree toggle<cr>", { desc = "Toggle file explorer" })
    utils.keymap("n", "<leader>o", function()
      if vim.bo.filetype == "neo-tree" then
        vim.cmd.wincmd("p")
      else
        vim.cmd.Neotree("focus")
      end
    end, { desc = "Focus file explorer" })
    
    -- LazyGit
    utils.keymap("n", "<leader>gg", "<cmd>LazyGit<cr>", { desc = "LazyGit" })
    
    -- Flash
    utils.keymap({ "n", "x", "o" }, "s", function() require("flash").jump() end, { desc = "Flash" })
    utils.keymap({ "n", "x", "o" }, "S", function() require("flash").treesitter() end, { desc = "Flash Treesitter" })
    utils.keymap("o", "r", function() require("flash").remote() end, { desc = "Remote Flash" })
    utils.keymap({ "o", "x" }, "R", function() require("flash").treesitter_search() end, { desc = "Treesitter Search" })
    utils.keymap("c", "<c-s>", function() require("flash").toggle() end, { desc = "Toggle Flash Search" })
    
    -- Trouble
    utils.keymap("n", "<leader>xx", "<cmd>TroubleToggle<cr>", { desc = "Toggle Trouble" })
    utils.keymap("n", "<leader>xw", "<cmd>TroubleToggle workspace_diagnostics<cr>", { desc = "Workspace Diagnostics" })
    utils.keymap("n", "<leader>xd", "<cmd>TroubleToggle document_diagnostics<cr>", { desc = "Document Diagnostics" })
    utils.keymap("n", "gR", "<cmd>TroubleToggle lsp_references<cr>", { desc = "LSP References" })
    
    -- TODO Comments
    utils.keymap("n", "]t", function() require("todo-comments").jump_next() end, { desc = "Next todo comment" })
    utils.keymap("n", "[t", function() require("todo-comments").jump_prev() end, { desc = "Previous todo comment" })
    utils.keymap("n", "<leader>ft", "<cmd>TodoTelescope<cr>", { desc = "Find TODOs" })
    
    -- Buffer management (these will be overridden by bufferline if it loads)
    utils.keymap("n", "[b", "<cmd>bprevious<cr>", { desc = "Prev buffer" })
    utils.keymap("n", "]b", "<cmd>bnext<cr>", { desc = "Next buffer" })
    
    -- Save file
    utils.keymap({ "i", "x", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save file" })
    
    -- New file
    utils.keymap("n", "<leader>fn", "<cmd>enew<cr>", { desc = "New File" })
    
    -- Highlights under cursor
    utils.keymap("n", "<leader>ui", vim.show_pos, { desc = "Inspect Pos" })
  end
end

return M
