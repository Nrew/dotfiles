local utils = require("core.utils")

local M = {}

local PLUGIN_REGISTRY = {
  theme = { category = "general", priority = 1, config_module = "plugins.theme" },
  
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
    dependencies = { "theme" },
    config_module = "plugins.lualine",
  },
  
  bufferline = {
    category = "general",
    priority = 8,
    dependencies = { "theme" },
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

local loaded_plugins = {}

local function load_plugin(name, config)
  assert(type(name) == "string" and name ~= "", "Plugin name must be a non-empty string")
  assert(type(config) == "table" and config.category, "Plugin config must be table with category")
  
  if loaded_plugins[name] then
    return true
  end
  
  if not utils.has_category(config.category) then
    return false
  end
  
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
  
  if config.setup_fn then
    success = utils.safe_call(config.setup_fn, string.format("plugin '%s' custom setup", name))
  elseif config.config_module then
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

function M.load_all()
  if not utils.has_category("general") then
    vim.notify("nixCats general category not enabled, skipping plugin loading", vim.log.levels.INFO)
    return
  end
  
  local sorted_plugins = {}
  for name, config in pairs(PLUGIN_REGISTRY) do
    assert(type(config) == "table", string.format("Plugin '%s' config must be a table", name))
    assert(config.category, string.format("Plugin '%s' must have a category", name))
    
    table.insert(sorted_plugins, { name = name, config = config })
  end
  
  table.sort(sorted_plugins, function(a, b)
    return (a.config.priority or 999) < (b.config.priority or 999)
  end)
  
  local theme_config = PLUGIN_REGISTRY.theme
  if theme_config then
    load_plugin("theme", theme_config)
  end
  
  vim.defer_fn(function()
    local loaded_count = 0
    local total_count = #sorted_plugins
    
    for _, item in ipairs(sorted_plugins) do
      if item.name ~= "theme" then
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

function M.load_plugin(name)
  assert(type(name) == "string" and name ~= "", "Plugin name must be a non-empty string")
  
  local config = PLUGIN_REGISTRY[name]
  if not config then
    vim.notify(string.format("Unknown plugin: %s", name), vim.log.levels.ERROR)
    return false
  end
  
  return load_plugin(name, config)
end

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

function M.is_loaded(name)
  assert(type(name) == "string", "Plugin name must be a string")
  return loaded_plugins[name] or false
end

return M