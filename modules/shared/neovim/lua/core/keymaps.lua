local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Better navigation
map({"n", "x"}, "j", "v:count == 0 ? 'gj' : 'j'", { expr = true })
map({"n", "x"}, "k", "v:count == 0 ? 'gk' : 'k'", { expr = true })

-- Window navigation
map("n", "<C-h>", "<C-w>h", opts)
map("n", "<C-j>", "<C-w>j", opts)
map("n", "<C-k>", "<C-w>k", opts)
map("n", "<C-l>", "<C-w>l", opts)

-- Window resizing
map("n", "<C-Up>", "<cmd>resize +2<cr>", opts)
map("n", "<C-Down>", "<cmd>resize -2<cr>", opts)
map("n", "<C-Left>", "<cmd>vertical resize -2<cr>", opts)
map("n", "<C-Right>", "<cmd>vertical resize +2<cr>", opts)

-- Move lines
map("n", "<A-j>", "<cmd>m .+1<cr>==", opts)
map("n", "<A-k>", "<cmd>m .-2<cr>==", opts)
map("v", "<A-j>", ":m '>+1<cr>gv=gv", opts)
map("v", "<A-k>", ":m '<-2<cr>gv=gv", opts)

-- Clear search
map({"i", "n"}, "<esc>", "<cmd>noh<cr><esc>", opts)

-- Better search
map("n", "n", "'Nn'[v:searchforward]", { expr = true })
map("n", "N", "'nN'[v:searchforward]", { expr = true })

-- Indenting
map("v", "<", "<gv")
map("v", ">", ">gv")

-- Save file
map({"i", "x", "n"}, "<C-s>", "<cmd>w<cr><esc>", opts)

-- Window splits
map("n", "<leader>-", "<C-W>s", { desc = "Split below" })
map("n", "<leader>|", "<C-W>v", { desc = "Split right" })

-- Buffers
map("n", "<leader>bb", "<cmd>e #<cr>", { desc = "Switch to other buffer" })

-- Diagnostics
map("n", "[d", vim.diagnostic.goto_prev, { desc = "Prev diagnostic" })
map("n", "]d", vim.diagnostic.goto_next, { desc = "Next diagnostic" })
map("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Show diagnostic" })

-- Quit
map("n", "<leader>qq", "<cmd>qa<cr>", { desc = "Quit all" })

-- File explorer
map("n", "<leader>e", "<cmd>Neotree toggle<cr>", { desc = "Toggle file explorer" })
map("n", "<leader>E", "<cmd>Neotree focus<cr>", { desc = "Reveal file in explorer" })

-- Telescope
map("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Find files" })
map("n", "<leader>fg", "<cmd>Telescope live_grep<cr>", { desc = "Live grep" })
map("n", "<leader>fb", "<cmd>Telescope buffers<cr>", { desc = "Find buffers" })
map("n", "<leader>fr", "<cmd>Telescope oldfiles<cr>", { desc = "Recent files" })

-- Git
map("n", "<leader>gg", "<cmd>LazyGit<cr>", { desc = "LazyGit" })