-- Enable vim loader for faster startup
if vim.loader then
  vim.loader.enable()
end

-- Load core configuration
require("core.options")
require("core.keymaps")
require("core.autocmds")

-- Load theme immediately (needed for UI)
require("plugins.theme").setup()

-- Initialize lze for lazy loading
local lze = require("lze")

-- Configure lazy loading with lze
lze.load({
  -- Treesitter - load early for syntax highlighting
  {
    "nvim-treesitter",
    event = "BufReadPost",
    load = function()
      require("plugins.treesitter").setup()
    end,
  },

  -- LSP - load on file open
  {
    "nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    load = function()
      require("plugins.lsp").setup()
    end,
  },

  -- Completion - load with LSP
  {
    "blink-cmp",
    event = "InsertEnter",
    load = function()
      require("plugins.completion").setup()
    end,
  },

  -- Snippets - load on insert
  {
    "luasnip",
    event = "InsertEnter",
    load = function()
      require("plugins.luasnip").setup()
    end,
  },

  -- UI Components - load after UI is ready
  {
    "lualine",
    event = "VeryLazy",
    load = function()
      require("plugins.lualine").setup()
    end,
  },

  {
    "bufferline",
    event = "VeryLazy",
    load = function()
      require("plugins.bufferline").setup()
    end,
  },

  {
    "indent-blankline",
    event = "BufReadPost",
    load = function()
      require("plugins.indent-blankline").setup()
    end,
  },

  {
    "noice",
    event = "VeryLazy",
    load = function()
      require("plugins.noice").setup()
    end,
  },

  -- File navigation - load on demand
  {
    "neo-tree",
    keys = {
      { "<leader>e", "<cmd>Neotree toggle<cr>", desc = "Toggle Neo-tree" },
    },
    load = function()
      require("plugins.neo-tree").setup()
    end,
  },

  {
    "telescope",
    keys = {
      { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find files" },
      { "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Live grep" },
      { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Buffers" },
      { "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "Help tags" },
    },
    load = function()
      require("plugins.telescope").setup()
    end,
  },

  {
    "yazi",
    keys = {
      { "<leader>y", "<cmd>Yazi<cr>", desc = "Open Yazi" },
    },
    load = function()
      require("plugins.yazi").setup()
    end,
  },

  -- Editing enhancements - load on insert or specific actions
  {
    "mini-pairs",
    event = "InsertEnter",
    load = function()
      require("plugins.mini-pairs").setup()
    end,
  },

  {
    "comment",
    keys = {
      { "gc", mode = { "n", "v" }, desc = "Comment toggle" },
      { "gb", mode = { "n", "v" }, desc = "Comment toggle blockwise" },
    },
    load = function()
      require("plugins.comment").setup()
    end,
  },

  {
    "surround",
    keys = {
      { "ys", mode = "n", desc = "Add surround" },
      { "ds", mode = "n", desc = "Delete surround" },
      { "cs", mode = "n", desc = "Change surround" },
    },
    load = function()
      require("plugins.surround").setup()
    end,
  },

  {
    "flash",
    keys = {
      { "s", mode = { "n", "x", "o" }, desc = "Flash" },
      { "S", mode = { "n", "x", "o" }, desc = "Flash Treesitter" },
    },
    load = function()
      require("plugins.flash").setup()
    end,
  },

  {
    "yanky",
    keys = {
      { "p", mode = { "n", "x" }, desc = "Paste" },
      { "P", mode = { "n", "x" }, desc = "Paste before" },
      { "<leader>p", desc = "Yank history" },
    },
    load = function()
      require("plugins.yanky").setup()
    end,
  },

  -- Git integration - load when needed
  {
    "gitsigns",
    event = "BufReadPost",
    load = function()
      require("plugins.gitsigns").setup()
    end,
  },

  {
    "lazygit",
    keys = {
      { "<leader>gg", "<cmd>LazyGit<cr>", desc = "LazyGit" },
    },
    load = function()
      require("plugins.lazygit").setup()
    end,
  },

  -- Utility plugins - load when needed
  {
    "which-key",
    keys = { "<leader>", '"', "'", "`", "c", "v", "g" },
    load = function()
      require("plugins.which-key").setup()
    end,
  },

  {
    "trouble",
    keys = {
      { "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", desc = "Diagnostics (Trouble)" },
      { "<leader>xd", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Buffer Diagnostics" },
    },
    load = function()
      require("plugins.trouble").setup()
    end,
  },

  {
    "todo-comments",
    event = "BufReadPost",
    load = function()
      require("plugins.todo-comments").setup()
    end,
  },

  -- Session management - load lazily
  {
    "persistence",
    event = "VeryLazy",
    load = function()
      require("plugins.persistence").setup()
    end,
  },

  {
    "project",
    event = "VeryLazy",
    load = function()
      require("plugins.project").setup()
    end,
  },

  -- Utilities - load on demand
  {
    "mini-icons",
    event = "VeryLazy",
    load = function()
      require("plugins.mini-icons").setup()
    end,
  },

  {
    "stabilize",
    event = "VeryLazy",
    load = function()
      require("plugins.stabilize").setup()
    end,
  },
})

vim.notify("NixCats Neovim ready", vim.log.levels.INFO)
