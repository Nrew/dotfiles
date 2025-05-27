-- Centralized plugin loading system
local utils = require("utils")
local M = {}

-- Plugin registry with clean configuration
local PLUGINS = {
  colorscheme = {
    priority = 1,
    setup = function()
      require("rose-pine").setup({
        variant = "main",
        dark_variant = "main",
        groups = {
          background = "#191724",
          panel = "#1f1d2e",
          border = "#26233a",
          comment = "#6e6a86",
          error = "#eb6f92",
          hint = "#c4a7e7",
          info = "#9ccfd8",
          warn = "#f6c177",
        },
        highlight_groups = {
          ColorColumn = { bg = "#1f1d2e" },
          CursorLine = { bg = "none" },
        }
      })
      vim.cmd("colorscheme rose-pine")
    end
  },
  
  treesitter = { priority = 2, module = "plugins.treesitter" },
  lsp = { priority = 3, module = "plugins.lsp" },
  completion = { priority = 4, module = "plugins.completion" },
  telescope = { priority = 5, module = "plugins.telescope" },
  ["which-key"] = { priority = 6, module = "plugins.which-key" },
  ["neo-tree"] = { priority = 7, module = "plugins.neo-tree" },
  lualine = { priority = 8, module = "plugins.lualine" },
  bufferline = { priority = 9, module = "plugins.bufferline" },
  noice = { priority = 10, module = "plugins.noice" },
  trouble = { priority = 11, module = "plugins.trouble" },
  gitsigns = { priority = 12, module = "plugins.gitsigns" },
}

local function load_plugin(name, config)
  if config.setup then
    return utils.safe_setup(name, config.setup)
  elseif config.module then
    local plugin_module = utils.safe_require(config.module)
    if plugin_module and plugin_module.setup then
      return utils.safe_setup(name, plugin_module.setup)
    end
  end
  return false
end

function M.load()
  if not utils.has_category("general") then
    return
  end

  M.loaded_plugins = {}
  
  -- Sort by priority
  local sorted = {}
  for name, config in pairs(PLUGINS) do
    table.insert(sorted, { name = name, config = config })
  end
  table.sort(sorted, function(a, b)
    return a.config.priority < b.config.priority
  end)

  -- Load colorscheme first
  load_plugin("colorscheme", PLUGINS.colorscheme)

  -- Load others after delay
  utils.defer(function()
    for _, item in ipairs(sorted) do
      if item.name ~= "colorscheme" then
        if load_plugin(item.name, item.config) then
          M.loaded_plugins[item.name] = true
        end
      end
    end
  end)
end

M.load()
return M
