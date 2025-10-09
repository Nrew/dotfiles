-- Load core configuration
require("core.options")
require("core.keymaps")
require("core.autocmds")

-- Get Nix-generated plugin paths
local nix_plugins = vim.g.nix_lazy_plugins or {}

-- Create a lookup table for plugin paths
-- Convert Nix package names (with-dashes) to match GitHub-style names (with.dots)
local plugin_paths = {}
for _, plugin in ipairs(nix_plugins) do
  -- Store with original name
  plugin_paths[plugin.name] = plugin.dir
  -- Also store with dots instead of dashes for matching
  local name_with_dots = plugin.name:gsub("%-", ".")
  plugin_paths[name_with_dots] = plugin.dir
end

-- Helper to add dir to plugin spec
local function with_dir(spec)
  if type(spec) == "string" then
    local name = spec:match("([^/]+)$") or spec
    if plugin_paths[name] then
      return { dir = plugin_paths[name], name = name }
    end
  elseif type(spec) == "table" and spec[1] then
    local name = spec[1]:match("([^/]+)$") or spec[1]
    if plugin_paths[name] then
      spec.dir = plugin_paths[name]
      spec.name = name
      spec[1] = nil  -- Remove the GitHub URL
    end
  end
  return spec
end

-- Setup lazy.nvim
require("lazy").setup({
  -- Theme & UI
  with_dir({
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
  }),
  
  with_dir({
    "nvim-lualine/lualine.nvim",
    -- Use Nix-installed version
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function() require("plugins.lualine").setup() end,
    event = "VeryLazy",
  }),
  
  with_dir({
    "akinsho/bufferline.nvim",
    -- Use Nix-installed version
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function() require("plugins.bufferline").setup() end,
    event = "VeryLazy",
  }),
  
  -- File management & navigation
  with_dir({
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
  }),
  
  with_dir({
    "folke/which-key.nvim",
    -- Use Nix-installed version
    config = function() require("plugins.which-key").setup() end,
    event = "VeryLazy",
  }),
  
  -- LSP & completion
  with_dir({
    "neovim/nvim-lspconfig",
    -- Use Nix-installed version
    dependencies = { "saghen/blink.cmp" },
    config = function() require("plugins.lsp").setup() end,
    event = { "BufReadPre", "BufNewFile" },
  }),
  
  with_dir({
    "saghen/blink.cmp",
    -- Use Nix-installed version
    dependencies = { "L3MON4D3/LuaSnip", "rafamadriz/friendly-snippets" },
    config = function() require("plugins.completion").setup() end,
    event = "InsertEnter",
  }),
  
  with_dir({
    "folke/trouble.nvim",
    -- Use Nix-installed version
    config = function() require("plugins.trouble").setup() end,
    cmd = "Trouble",
  }),
  
  with_dir({ "L3MON4D3/LuaSnip", config = function() require("plugins.luasnip").setup() end }),
  with_dir({ "rafamadriz/friendly-snippets" }),
  
  -- Treesitter
  with_dir({
    "nvim-treesitter/nvim-treesitter",
    -- Use Nix-installed version
    dependencies = {
      "nvim-treesitter/nvim-treesitter-context",
      "windwp/nvim-ts-autotag",
      "nvim-treesitter/nvim-treesitter-textobjects",
    },
    config = function() require("plugins.treesitter").setup() end,
    event = { "BufReadPost", "BufNewFile" },
  }),
  
  -- Editing enhancements
  with_dir({ "numToStr/Comment.nvim", config = function() require("plugins.comment").setup() end, event = "VeryLazy" }),
  with_dir({ "kylechui/nvim-surround", config = function() require("plugins.surround").setup() end, event = "VeryLazy" }),
  with_dir({ "folke/flash.nvim", config = function() require("plugins.flash").setup() end, event = "VeryLazy" }),
  with_dir({ "echasnovski/mini.pairs", config = function() require("plugins.mini-pairs").setup() end, event = "InsertEnter" }),
  with_dir({ "gbprod/yanky.nvim", config = function() require("plugins.yanky").setup() end, event = "VeryLazy" }),
  
  -- Visual improvements
  with_dir({ "lukas-reineke/indent-blankline.nvim", config = function() require("plugins.indent-blankline").setup() end, event = "BufReadPost" }),
  with_dir({
    "folke/noice.nvim",
    -- Use Nix-installed version
    dependencies = { "MunifTanjim/nui.nvim", "rcarriga/nvim-notify" },
    config = function() require("plugins.noice").setup() end,
    event = "VeryLazy",
  }),
  with_dir({ "stevearc/dressing.nvim", event = "VeryLazy" }),
  
  -- Git integration
  with_dir({ "lewis6991/gitsigns.nvim", config = function() require("plugins.gitsigns").setup() end, event = "BufReadPre" }),
  with_dir({ "kdheepak/lazygit.nvim", config = function() require("plugins.lazygit").setup() end, cmd = "LazyGit" }),
  
  -- Development tools
  with_dir({ "folke/todo-comments.nvim", config = function() require("plugins.todo-comments").setup() end, event = "BufReadPost" }),
  
  -- Session & project management
  with_dir({ "folke/persistence.nvim", config = function() require("plugins.persistence").setup() end, event = "VimEnter" }),
  with_dir({ "ahmedkhalf/project.nvim", config = function() require("plugins.project").setup() end, event = "VeryLazy" }),
  
  -- File browser
  with_dir({
    "mikavilpas/yazi.nvim",
    -- Use Nix-installed version
    config = function() require("plugins.yazi").setup() end,
    keys = {
      { "<leader>-", "<cmd>Yazi<cr>", desc = "Open Yazi" },
    },
  }),
  
  -- Utils
  with_dir({ "nvim-lua/plenary.nvim" }),
  with_dir({ "MunifTanjim/nui.nvim" }),
  with_dir({ "echasnovski/mini.icons", config = function() require("plugins.mini-icons").setup() end, event = "VeryLazy" }),
  with_dir({ "luukvbaal/stabilize.nvim", config = function() require("plugins.stabilize").setup() end, event = "VeryLazy" }),
}, {
  -- Lazy.nvim configuration
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
