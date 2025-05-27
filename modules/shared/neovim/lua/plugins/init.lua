-- Centralized plugin loading system
local utils = require("utils")
local M = {}

-- Plugin configuration registry
local PLUGINS = {
  -- Core plugins (load first)
  colorscheme = {
    priority = 1,
    categories = { "general" },
    setup = function()
      require("rose-pine").setup({
        variant = "main",
        dark_variant = "main",
        bold_vert_split = false,
        dim_nc_background = false,
        disable_background = false,
        disable_float_background = false,
        disable_italics = false,
        groups = {
          background = "#191724",
          background_nc = "#191724",
          panel = "#1f1d2e",
          panel_nc = "#1f1d2e",
          border = "#26233a",
          comment = "#6e6a86",
          link = "#31748f",
          punctuation = "#908caa",
          error = "#eb6f92",
          hint = "#c4a7e7",
          info = "#9ccfd8",
          warn = "#f6c177",
          headings = {
            h1 = "#c4a7e7",
            h2 = "#9ccfd8",
            h3 = "#ebbcba",
            h4 = "#f6c177",
            h5 = "#31748f",
            h6 = "#9ccfd8",
          }
        },
        highlight_groups = {
          ColorColumn = { bg = "#1f1d2e" },
          CursorLine = { bg = "none" },
          StatusLine = { fg = "#e0def4", bg = "#1f1d2e" },
        }
      })
      vim.cmd("colorscheme rose-pine")
    end
  },

  -- Foundation plugins
  treesitter = {
    priority = 2,
    categories = { "general" },
    module = "plugins.treesitter"
  },

  lsp = {
    priority = 3,
    categories = { "general" },
    module = "plugins.lsp"
  },

  completion = {
    priority = 4,
    categories = { "general" },
    module = "plugins.completion",
    depends = { "lsp" }
  },

  -- UI plugins
  telescope = {
    priority = 5,
    categories = { "general" },
    module = "plugins.telescope"
  },

  ["which-key"] = {
    priority = 6,
    categories = { "general" },
    module = "plugins.which-key"
  },

  ["neo-tree"] = {
    priority = 7,
    categories = { "general" },
    module = "plugins.neo-tree"
  },

  lualine = {
    priority = 8,
    categories = { "general" },
    module = "plugins.lualine"
  },

  bufferline = {
    priority = 9,
    categories = { "general" },
    module = "plugins.bufferline"
  },

  noice = {
    priority = 10,
    categories = { "general" },
    module = "plugins.noice"
  },

  ["indent-blankline"] = {
    priority = 11,
    categories = { "general" },
    module = "plugins.indent-blankline"
  },

  -- Editor enhancement plugins
  ["mini-pairs"] = {
    priority = 12,
    categories = { "general" },
    module = "plugins.mini-pairs"
  },

  comment = {
    priority = 13,
    categories = { "general" },
    module = "plugins.comment"
  },

  flash = {
    priority = 14,
    categories = { "general" },
    module = "plugins.flash"
  },

  surround = {
    priority = 15,
    categories = { "general" },
    module = "plugins.surround"
  },

  yanky = {
    priority = 16,
    categories = { "general" },
    module = "plugins.yanky"
  },

  trouble = {
    priority = 17,
    categories = { "general" },
    module = "plugins.trouble"
  },

  ["todo-comments"] = {
    priority = 18,
    categories = { "general" },
    module = "plugins.todo-comments"
  },

  -- Git plugins
  gitsigns = {
    priority = 19,
    categories = { "general" },
    module = "plugins.gitsigns"
  },

  lazygit = {
    priority = 20,
    categories = { "general" },
    module = "plugins.lazygit"
  },

  -- Extra plugins
  copilot = {
    priority = 21,
    categories = { "general" },
    module = "plugins.copilot"
  },

  project = {
    priority = 22,
    categories = { "general" },
    module = "plugins.project"
  },

  persistence = {
    priority = 23,
    categories = { "general" },
    module = "plugins.persistence"
  },

  yazi = {
    priority = 24,
    categories = { "general" },
    module = "plugins.yazi"
  },
}

-- Check if plugin should be loaded
local function should_load_plugin(plugin_config)
  -- Check if any required category is available
  for _, category in ipairs(plugin_config.categories or {}) do
    if utils.has_category(category) then
      return true
    end
  end
  return false
end

-- Load a single plugin
local function load_plugin(name, config)
  if not should_load_plugin(config) then
    return false
  end

  -- Check dependencies
  if config.depends then
    for _, dep in ipairs(config.depends) do
      if not M.loaded_plugins[dep] then
        vim.notify(
          string.format("Plugin '%s' depends on '%s' which isn't loaded", name, dep),
          vim.log.levels.WARN
        )
        return false
      end
    end
  end

  local success = false

  if config.setup then
    -- Direct setup function
    success = utils.safe_setup(name, config.setup)
  elseif config.module then
    -- Load from module
    local plugin_module = utils.safe_require(config.module)
    if plugin_module and plugin_module.setup then
      success = utils.safe_setup(name, plugin_module.setup)
    else
      vim.notify(
        string.format("Plugin module '%s' has no setup function", config.module),
        vim.log.levels.WARN
      )
    end
  end

  if success then
    M.loaded_plugins[name] = true
    vim.notify(
      string.format("✓ Loaded plugin: %s", name),
      vim.log.levels.INFO
    )
  end

  return success
end

-- Main loading function
function M.load()
  if not utils.has_category("general") then
    vim.notify("nixCats general category not enabled, skipping plugin loading", vim.log.levels.WARN)
    return
  end

  M.loaded_plugins = {}
  
  -- Sort plugins by priority
  local sorted_plugins = {}
  for name, config in pairs(PLUGINS) do
    table.insert(sorted_plugins, { name = name, config = config })
  end
  
  table.sort(sorted_plugins, function(a, b)
    return (a.config.priority or 999) < (b.config.priority or 999)
  end)

  -- Load colorscheme immediately
  local colorscheme_config = PLUGINS.colorscheme
  if colorscheme_config then
    load_plugin("colorscheme", colorscheme_config)
  end

  -- Load remaining plugins with slight delay
  utils.defer(function()
    for _, item in ipairs(sorted_plugins) do
      if item.name ~= "colorscheme" then
        load_plugin(item.name, item.config)
      end
    end
    
    vim.notify(
      string.format("Plugin loading complete. Loaded %d/%d plugins", 
        vim.tbl_count(M.loaded_plugins), 
        vim.tbl_count(PLUGINS)
      ),
      vim.log.levels.INFO
    )
  end, 50)
end

-- Get loaded plugins
function M.get_loaded_plugins()
  return M.loaded_plugins or {}
end

-- Check if specific plugin is loaded
function M.is_loaded(plugin_name)
  return M.loaded_plugins and M.loaded_plugins[plugin_name] or false
end

-- Manually load a specific plugin
function M.load_plugin(plugin_name)
  local config = PLUGINS[plugin_name]
  if not config then
    vim.notify(
      string.format("Unknown plugin: %s", plugin_name),
      vim.log.levels.ERROR
    )
    return false
  end
  
  return load_plugin(plugin_name, config)
end

-- Register a new plugin
function M.register_plugin(name, config)
  PLUGINS[name] = config
end

-- Auto-load plugins
M.load()

return M
