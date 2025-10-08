-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Load core configuration
require("core.options")
require("core.keymaps")
require("core.autocmds")

-- Setup lazy.nvim
require("lazy").setup({
  -- Theme & UI
  {
    "nvim-telescope/telescope.nvim",
    dev = true,  -- Use Nix-installed version
    dependencies = { "nvim-lua/plenary.nvim", "nvim-telescope/telescope-fzf-native.nvim" },
    config = function() require("plugins.telescope").setup() end,
    cmd = "Telescope",
    keys = {
      { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find Files" },
      { "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Live Grep" },
      { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Buffers" },
    },
  },
  
  {
    "nvim-lualine/lualine.nvim",
    dev = true,  -- Use Nix-installed version
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function() require("plugins.lualine").setup() end,
    event = "VeryLazy",
  },
  
  {
    "akinsho/bufferline.nvim",
    dev = true,  -- Use Nix-installed version
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function() require("plugins.bufferline").setup() end,
    event = "VeryLazy",
  },
  
  -- File management & navigation
  {
    "nvim-neo-tree/neo-tree.nvim",
    dev = true,  -- Use Nix-installed version
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
      "s1n7ax/nvim-window-picker",
    },
    config = function() require("plugins.neo-tree").setup() end,
    cmd = "Neotree",
    keys = {
      { "<leader>e", "<cmd>Neotree toggle<cr>", desc = "Toggle Neotree" },
    },
  },
  
  {
    "folke/which-key.nvim",
    dev = true,  -- Use Nix-installed version
    config = function() require("plugins.which-key").setup() end,
    event = "VeryLazy",
  },
  
  -- LSP & completion
  {
    "neovim/nvim-lspconfig",
    dev = true,  -- Use Nix-installed version
    dependencies = { "saghen/blink.cmp" },
    config = function() require("plugins.lsp").setup() end,
    event = { "BufReadPre", "BufNewFile" },
  },
  
  {
    "saghen/blink.cmp",
    dev = true,  -- Use Nix-installed version
    dependencies = { "L3MON4D3/LuaSnip", "rafamadriz/friendly-snippets" },
    config = function() require("plugins.completion").setup() end,
    event = "InsertEnter",
  },
  
  {
    "folke/trouble.nvim",
    dev = true,  -- Use Nix-installed version
    config = function() require("plugins.trouble").setup() end,
    cmd = "Trouble",
  },
  
  { "L3MON4D3/LuaSnip", dev = true, config = function() require("plugins.luasnip").setup() end },
  { "rafamadriz/friendly-snippets", dev = true },
  
  -- Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    dev = true,  -- Use Nix-installed version
    dependencies = {
      "nvim-treesitter/nvim-treesitter-context",
      "windwp/nvim-ts-autotag",
      "nvim-treesitter/nvim-treesitter-textobjects",
    },
    config = function() require("plugins.treesitter").setup() end,
    event = { "BufReadPost", "BufNewFile" },
  },
  
  -- Editing enhancements
  { "numToStr/Comment.nvim", dev = true, config = function() require("plugins.comment").setup() end, event = "VeryLazy" },
  { "kylechui/nvim-surround", dev = true, config = function() require("plugins.surround").setup() end, event = "VeryLazy" },
  { "folke/flash.nvim", dev = true, config = function() require("plugins.flash").setup() end, event = "VeryLazy" },
  { "echasnovski/mini.pairs", dev = true, config = function() require("plugins.mini-pairs").setup() end, event = "InsertEnter" },
  { "gbprod/yanky.nvim", dev = true, config = function() require("plugins.yanky").setup() end, event = "VeryLazy" },
  
  -- Visual improvements
  { "lukas-reineke/indent-blankline.nvim", dev = true, config = function() require("plugins.indent-blankline").setup() end, event = "BufReadPost" },
  {
    "folke/noice.nvim",
    dev = true,  -- Use Nix-installed version
    dependencies = { "MunifTanjim/nui.nvim", "rcarriga/nvim-notify" },
    config = function() require("plugins.noice").setup() end,
    event = "VeryLazy",
  },
  { "stevearc/dressing.nvim", dev = true, event = "VeryLazy" },
  
  -- Git integration
  { "lewis6991/gitsigns.nvim", dev = true, config = function() require("plugins.gitsigns").setup() end, event = "BufReadPre" },
  { "kdheepak/lazygit.nvim", dev = true, config = function() require("plugins.lazygit").setup() end, cmd = "LazyGit" },
  
  -- Development tools
  { "folke/todo-comments.nvim", dev = true, config = function() require("plugins.todo-comments").setup() end, event = "BufReadPost" },
  
  -- Session & project management
  { "folke/persistence.nvim", dev = true, config = function() require("plugins.persistence").setup() end, event = "VimEnter" },
  { "ahmedkhalf/project.nvim", dev = true, config = function() require("plugins.project").setup() end, event = "VeryLazy" },
  
  -- File browser
  {
    "mikavilpas/yazi.nvim",
    dev = true,  -- Use Nix-installed version
    config = function() require("plugins.yazi").setup() end,
    keys = {
      { "<leader>-", "<cmd>Yazi<cr>", desc = "Open Yazi" },
    },
  },
  
  -- Utils
  { "nvim-lua/plenary.nvim", dev = true },
  { "MunifTanjim/nui.nvim", dev = true },
  { "echasnovski/mini.icons", dev = true, config = function() require("plugins.mini-icons").setup() end, event = "VeryLazy" },
  { "luukvbaal/stabilize.nvim", dev = true, config = function() require("plugins.stabilize").setup() end, event = "VeryLazy" },
}, {
  -- Lazy.nvim configuration
  dev = {
    -- Use plugins from runtimepath (Nix-installed)
    -- Don't set a custom path - let lazy.nvim find plugins in runtimepath
    fallback = true,
  },
  install = {
    -- Don't install plugins, they're managed by Nix
    missing = false,
  },
  checker = {
    -- Don't check for updates, Nix manages versions
    enabled = false,
  },
  rocks = {
    -- Disable luarocks support, not needed with Nix-managed plugins
    enabled = false,
  },
  ui = {
    border = "rounded",
  },
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})

-- Load theme after lazy.nvim setup
local theme_ok, theme = pcall(require, "plugins.theme")
if theme_ok and type(theme.setup) == "function" then
  local setup_ok, setup_err = pcall(theme.setup)
  if not setup_ok then
    vim.notify("Failed to setup theme: " .. tostring(setup_err), vim.log.levels.WARN)
  end
else
  vim.notify("Theme module not found or invalid", vim.log.levels.WARN)
end

vim.notify("Lazy.nvim Neovim initialized", vim.log.levels.INFO)
