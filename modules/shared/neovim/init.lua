-- Load core configuration
require("core.options")
require("core.keymaps")
require("core.autocmds")

-- nixCats: Get plugin specs from Nix (with dir paths to Nix store)
local nix_plugins = vim.g.lazy_nix_plugins or {}

-- Create lookup table from Nix plugins
local nix_lookup = {}
for _, spec in ipairs(nix_plugins) do
  nix_lookup[spec.name] = spec
end

-- Helper to find and merge Nix spec
local function with_nix(name, config)
  local nix_spec = nix_lookup[name] or nix_lookup[name:gsub("%.", "-")]
  if nix_spec then
    return vim.tbl_extend("force", { dir = nix_spec.dir, name = nix_spec.name }, config or {})
  end
  return config or { name }
end

-- Define all plugin configurations
local plugins = {
  -- Theme & UI
  with_nix("telescope-nvim", {
    dependencies = { "plenary.nvim", "telescope-fzf-native.nvim" },
    config = function() require("plugins.telescope").setup() end,
    cmd = "Telescope",
    keys = {
      { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find Files" },
      { "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Live Grep" },
      { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Buffers" },
    },
  }),
  
  with_nix("lualine-nvim", {
    dependencies = { "nvim-web-devicons" },
    config = function() require("plugins.lualine").setup() end,
    event = "VeryLazy",
  }),
  
  with_nix("bufferline-nvim", {
    dependencies = { "nvim-web-devicons" },
    config = function() require("plugins.bufferline").setup() end,
    event = "VeryLazy",
  }),
  
  -- File management & navigation
  with_nix("neo-tree-nvim", {
    dependencies = {
      "plenary-nvim",
      "nvim-web-devicons",
      "nui-nvim",
      "nvim-window-picker",
    },
    config = function() require("plugins.neo-tree").setup() end,
    cmd = "Neotree",
    keys = {
      { "<leader>e", "<cmd>Neotree toggle<cr>", desc = "Toggle Neotree" },
    },
  }),
  
  with_nix("which-key-nvim", {
    config = function() require("plugins.which-key").setup() end,
    event = "VeryLazy",
  }),
  
  -- LSP & completion
  with_nix("nvim-lspconfig", {
    dependencies = { "blink-cmp" },
    config = function() require("plugins.lsp").setup() end,
    event = { "BufReadPre", "BufNewFile" },
  }),
  
  with_nix("blink-cmp", {
    dependencies = { "luasnip", "friendly-snippets" },
    config = function() require("plugins.completion").setup() end,
    event = "InsertEnter",
  }),
  
  with_nix("trouble-nvim", {
    config = function() require("plugins.trouble").setup() end,
    cmd = "Trouble",
  }),
  
  with_nix("luasnip", {
    config = function() require("plugins.luasnip").setup() end,
  }),
  
  with_nix("friendly-snippets", {}),
  
  -- Treesitter
  with_nix("nvim-treesitter", {
    dependencies = {
      "nvim-treesitter-context",
      "nvim-ts-autotag",
      "nvim-treesitter-textobjects",
    },
    config = function() require("plugins.treesitter").setup() end,
    event = { "BufReadPost", "BufNewFile" },
  }),
  
  -- Editing enhancements
  with_nix("comment-nvim", {
    config = function() require("plugins.comment").setup() end,
    event = "VeryLazy",
  }),
  
  with_nix("nvim-surround", {
    config = function() require("plugins.surround").setup() end,
    event = "VeryLazy",
  }),
  
  with_nix("flash-nvim", {
    config = function() require("plugins.flash").setup() end,
    event = "VeryLazy",
  }),
  
  with_nix("mini-pairs", {
    config = function() require("plugins.mini-pairs").setup() end,
    event = "InsertEnter",
  }),
  
  with_nix("yanky-nvim", {
    config = function() require("plugins.yanky").setup() end,
    event = "VeryLazy",
  }),
  
  -- Visual improvements
  with_nix("indent-blankline-nvim", {
    config = function() require("plugins.indent-blankline").setup() end,
    event = "BufReadPost",
  }),
  
  with_nix("noice-nvim", {
    dependencies = { "nui-nvim", "nvim-notify" },
    config = function() require("plugins.noice").setup() end,
    event = "VeryLazy",
  }),
  
  with_nix("dressing-nvim", {
    event = "VeryLazy",
  }),
  
  -- Git integration
  with_nix("gitsigns-nvim", {
    config = function() require("plugins.gitsigns").setup() end,
    event = "BufReadPre",
  }),
  
  with_nix("lazygit-nvim", {
    config = function() require("plugins.lazygit").setup() end,
    cmd = "LazyGit",
  }),
  
  -- Development tools
  with_nix("todo-comments-nvim", {
    config = function() require("plugins.todo-comments").setup() end,
    event = "BufReadPost",
  }),
  
  -- Session & project management
  with_nix("persistence-nvim", {
    config = function() require("plugins.persistence").setup() end,
    event = "VimEnter",
  }),
  
  with_nix("project-nvim", {
    config = function() require("plugins.project").setup() end,
    event = "VeryLazy",
  }),
  
  -- File browser
  with_nix("yazi-nvim", {
    config = function() require("plugins.yazi").setup() end,
    keys = {
      { "<leader>-", "<cmd>Yazi<cr>", desc = "Open Yazi" },
    },
  }),
  
  -- Utils (just need dir, no extra config)
  with_nix("plenary-nvim", {}),
  with_nix("nui-nvim", {}),
  with_nix("mini-icons", {
    config = function() require("plugins.mini-icons").setup() end,
    event = "VeryLazy",
  }),
  with_nix("stabilize-nvim", {
    config = function() require("plugins.stabilize").setup() end,
    event = "VeryLazy",
  }),
}

-- Setup lazy.nvim with nixCats pattern
require("lazy").setup(plugins, {
  performance = {
    reset_packpath = false,  -- Don't reset - Nix plugins are in packpath
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
  vim.notify("Theme plugin not found or invalid", vim.log.levels.INFO)
end
