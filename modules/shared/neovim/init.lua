-- Load core configuration
require("core.options")
require("core.keymaps")
require("core.autocmds")

-- Setup lazy.nvim
require("lazy").setup({
  -- Theme & UI
  {
    "nvim-telescope/telescope.nvim",
    -- Use Nix-installed version
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
    -- Use Nix-installed version
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function() require("plugins.lualine").setup() end,
    event = "VeryLazy",
  },
  
  {
    "akinsho/bufferline.nvim",
    -- Use Nix-installed version
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function() require("plugins.bufferline").setup() end,
    event = "VeryLazy",
  },
  
  -- File management & navigation
  {
    "nvim-neo-tree/neo-tree.nvim",
    -- Use Nix-installed version
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
    -- Use Nix-installed version
    config = function() require("plugins.which-key").setup() end,
    event = "VeryLazy",
  },
  
  -- LSP & completion
  {
    "neovim/nvim-lspconfig",
    -- Use Nix-installed version
    dependencies = { "saghen/blink.cmp" },
    config = function() require("plugins.lsp").setup() end,
    event = { "BufReadPre", "BufNewFile" },
  },
  
  {
    "saghen/blink.cmp",
    -- Use Nix-installed version
    dependencies = { "L3MON4D3/LuaSnip", "rafamadriz/friendly-snippets" },
    config = function() require("plugins.completion").setup() end,
    event = "InsertEnter",
  },
  
  {
    "folke/trouble.nvim",
    -- Use Nix-installed version
    config = function() require("plugins.trouble").setup() end,
    cmd = "Trouble",
  },
  
  { "L3MON4D3/LuaSnip", config = function() require("plugins.luasnip").setup() end },
  { "rafamadriz/friendly-snippets" },
  
  -- Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    -- Use Nix-installed version
    dependencies = {
      "nvim-treesitter/nvim-treesitter-context",
      "windwp/nvim-ts-autotag",
      "nvim-treesitter/nvim-treesitter-textobjects",
    },
    config = function() require("plugins.treesitter").setup() end,
    event = { "BufReadPost", "BufNewFile" },
  },
  
  -- Editing enhancements
  { "numToStr/Comment.nvim", config = function() require("plugins.comment").setup() end, event = "VeryLazy" },
  { "kylechui/nvim-surround", config = function() require("plugins.surround").setup() end, event = "VeryLazy" },
  { "folke/flash.nvim", config = function() require("plugins.flash").setup() end, event = "VeryLazy" },
  { "echasnovski/mini.pairs", config = function() require("plugins.mini-pairs").setup() end, event = "InsertEnter" },
  { "gbprod/yanky.nvim", config = function() require("plugins.yanky").setup() end, event = "VeryLazy" },
  
  -- Visual improvements
  { "lukas-reineke/indent-blankline.nvim", config = function() require("plugins.indent-blankline").setup() end, event = "BufReadPost" },
  {
    "folke/noice.nvim",
    -- Use Nix-installed version
    dependencies = { "MunifTanjim/nui.nvim", "rcarriga/nvim-notify" },
    config = function() require("plugins.noice").setup() end,
    event = "VeryLazy",
  },
  { "stevearc/dressing.nvim", event = "VeryLazy" },
  
  -- Git integration
  { "lewis6991/gitsigns.nvim", config = function() require("plugins.gitsigns").setup() end, event = "BufReadPre" },
  { "kdheepak/lazygit.nvim", config = function() require("plugins.lazygit").setup() end, cmd = "LazyGit" },
  
  -- Development tools
  { "folke/todo-comments.nvim", config = function() require("plugins.todo-comments").setup() end, event = "BufReadPost" },
  
  -- Session & project management
  { "folke/persistence.nvim", config = function() require("plugins.persistence").setup() end, event = "VimEnter" },
  { "ahmedkhalf/project.nvim", config = function() require("plugins.project").setup() end, event = "VeryLazy" },
  
  -- File browser
  {
    "mikavilpas/yazi.nvim",
    -- Use Nix-installed version
    config = function() require("plugins.yazi").setup() end,
    keys = {
      { "<leader>-", "<cmd>Yazi<cr>", desc = "Open Yazi" },
    },
  },
  
  -- Utils
  { "nvim-lua/plenary.nvim" },
  { "MunifTanjim/nui.nvim" },
  { "echasnovski/mini.icons", config = function() require("plugins.mini-icons").setup() end, event = "VeryLazy" },
  { "luukvbaal/stabilize.nvim", config = function() require("plugins.stabilize").setup() end, event = "VeryLazy" },
}, {
  -- Lazy.nvim configuration
  pkg = {
    enabled = true,  -- Re-enable but configure for Nix
    sources = {
      "lazy",  -- Only use lazy source (runtimepath)
    },
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
    reset_packpath = false,  -- Don't reset packpath - Nix plugins are in runtimepath
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
