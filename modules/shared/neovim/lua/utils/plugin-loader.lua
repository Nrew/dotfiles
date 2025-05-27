-- Centralized plugin loader with dependency management
local utils = require("utils")
local M = {}

-- Plugin registry with metadata and dependencies
local PLUGIN_REGISTRY = {
  -- Core plugins (loaded first)
  colorscheme = {
    category = "general",
    priority = 1,
    setup_fn = function()
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
    end,
  },
  
  -- Foundation plugins
  treesitter = {
    category = "general",
    priority = 2,
    config_module = "plugins.treesitter",
  },
  
  lsp = {
    category = "general",
    priority = 3,
    config_module = "plugins.lsp",
  },
  
  completion = {
    category = "general",
    priority = 4,
    dependencies = { "lsp" },
    config_module = "plugins.completion",
  },
  
  -- UI plugins
  telescope = {
    category = "general",
    priority = 5,
    config_module = "plugins.telescope",
  },
  
  ["neo-tree"] = {
    category = "general",
    priority = 6,
    config_module = "plugins.neo-tree",
  },
  
  lualine = {
    category = "general",
    priority = 7,
    dependencies = { "colorscheme" },
    config_module = "plugins.lualine",
  },
  
  bufferline = {
    category = "general",
    priority = 8,
    dependencies = { "colorscheme" },
    config_module = "plugins.bufferline",
  },
  
  ["which-key"] = {
    category = "general",
    priority = 9,
    config_module = "plugins.which-key",
  },
  
  noice = {
    category = "general",
    priority = 10,
    config_module = "plugins.noice",
  },
  
  ["indent-blankline"] = {
    category = "general",
    priority = 11,
    config_module = "plugins.indent-blankline",
  },
  
  -- Editor enhancement plugins
  ["mini-pairs"] = {
    category = "general",
    priority = 12,
    config_module = "plugins.mini-pairs",
  },
  
  comment = {
    category = "general",
    priority = 13,
    config_module = "plugins.comment",
  },
  
  flash = {
    category = "general",
    priority = 14,
    config_module = "plugins.flash",
  },
  
  surround = {
    category = "general",
    priority = 15,
    config_module = "plugins.surround",
  },
  
  yanky = {
    category = "general",
    priority = 16,
    config_module = "plugins.yanky",
  },
  
  trouble = {
    category = "general",
    priority = 17,
    dependencies = { "lsp" },
    config_module = "plugins.trouble",
  },
  
  ["todo-comments"] = {
    category = "general",
    priority = 18,
    config_module = "plugins.todo-comments",
  },
  
  -- Git plugins
  gitsigns = {
    category = "general",
    priority = 19,
    config_module = "plugins.gitsigns",
  },
  
  lazygit = {
    category = "general",
    priority = 20,
    config_module = "plugins.lazygit",
  },
  
  -- Additional plugins
  copilot = {
    category = "general",
    priority = 21,
    config_module = "plugins.copilot",
  },
  
  project = {
    category = "general",
    priority = 22,
    config_module = "plugins.project",
  },
  
  persistence = {
    category = "general",
    priority = 23,
    config_module = "plugins.persistence",
  },
  
  yazi = {
    category = "general",
    priority = 24,
    config_module = "plugins.yazi",
  },
}

-- Track loaded plugins to avoid duplicates
local loaded_plugins = {}

-- Load a single plugin with error handling
local function load_plugin(name, config)
  if loaded_plugins[name] then
    return true
  end
  
  -- Check if required category is enabled
  if not utils.nixcats(config.category) then
    return false
  end
  
  -- Check dependencies
  if config.dependencies then
    for _, dep in ipairs(config.dependencies) do
      if not loaded_plugins[dep] then
        local dep_config = PLUGIN_REGISTRY[dep]
        if dep_config and not load_plugin(dep, dep_config) then
          vim.notify(
            string.format("Failed to load dependency '%s' for plugin '%s'", dep, name),
            vim.log.levels.WARN
          )
          return false
        end
      end
    end
  end
  
  local success = false
  
  -- Load plugin configuration
  if config.setup_fn then
    -- Custom setup function
    success = utils.safe_call(config.setup_fn, string.format("plugin '%s' custom setup", name))
  elseif config.config_module then
    -- Load from module
    local plugin_module = utils.safe_require(config.config_module)
    if plugin_module and type(plugin_module.setup) == "function" then
      success = utils.safe_call(plugin_module.setup, string.format("plugin '%s' module setup", name))
    else
      vim.notify(
        string.format("Plugin module '%s' has no setup function", config.config_module),
        vim.log.levels.WARN
      )
    end
  end
  
  if success then
    loaded_plugins[name] = true
  end
  
  return success
end

-- Load all plugins in priority order
function M.load_all()
  if not utils.nixcats("general") then
    vim.notify("nixCats general category not enabled, skipping plugin loading", vim.log.levels.INFO)
    return
  end
  
  -- Sort plugins by priority
  local sorted_plugins = {}
  for name, config in pairs(PLUGIN_REGISTRY) do
    table.insert(sorted_plugins, { name = name, config = config })
  end
  
  table.sort(sorted_plugins, function(a, b)
    return (a.config.priority or 999) < (b.config.priority or 999)
  end)
  
  -- Load colorscheme immediately
  local colorscheme_config = PLUGIN_REGISTRY.colorscheme
  if colorscheme_config then
    load_plugin("colorscheme", colorscheme_config)
  end
  
  -- Load remaining plugins with a small delay for better startup performance
  vim.defer_fn(function()
    local loaded_count = 0
    local total_count = #sorted_plugins
    
    for _, item in ipairs(sorted_plugins) do
      if item.name ~= "colorscheme" then  -- Skip colorscheme as it's already loaded
        if load_plugin(item.name, item.config) then
          loaded_count = loaded_count + 1
        end
      end
    end
    
    vim.notify(
      string.format("Loaded %d/%d plugins successfully", loaded_count, total_count - 1),
      vim.log.levels.INFO
    )
  end, 50)
end

-- Load a specific plugin manually
function M.load_plugin(name)
  local config = PLUGIN_REGISTRY[name]
  if not config then
    vim.notify(string.format("Unknown plugin: %s", name), vim.log.levels.ERROR)
    return false
  end
  
  return load_plugin(name, config)
end

-- Get list of available plugins
function M.list_plugins()
  local plugins = {}
  for name, config in pairs(PLUGIN_REGISTRY) do
    table.insert(plugins, {
      name = name,
      category = config.category,
      priority = config.priority,
      loaded = loaded_plugins[name] or false,
    })
  end
  return plugins
end

-- Check if a plugin is loaded
function M.is_loaded(name)
  return loaded_plugins[name] or false
end

return M
