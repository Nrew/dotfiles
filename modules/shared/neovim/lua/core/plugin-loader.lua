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
  -- INVARIANT: Plugin name must be valid
  assert(type(name) == "string" and #name > 0, "INVARIANT FAILED: plugin name must be non-empty string")
  
  -- INVARIANT: Config must be properly structured
  assert(type(config) == "table", string.format("INVARIANT FAILED: plugin '%s' config must be table", name))
  assert(type(config.category) == "string" and #config.category > 0, 
         string.format("INVARIANT FAILED: plugin '%s' must have non-empty category", name))
  
  -- NEGATIVE: Don't load if already loaded
  if loaded_plugins[name] then
    return true
  end
  
  -- NEGATIVE: Don't load if category not enabled
  if not utils.has_category(config.category) then
    return false
  end
  
  -- INVARIANT: Dependencies must be loaded first
  if config.dependencies then
    assert(type(config.dependencies) == "table", 
           string.format("INVARIANT FAILED: plugin '%s' dependencies must be table", name))
    
    for _, dep in ipairs(config.dependencies) do
      assert(type(dep) == "string" and #dep > 0, 
             string.format("INVARIANT FAILED: dependency '%s' must be non-empty string", tostring(dep)))
      
      if not loaded_plugins[dep] then
        local dep_config = PLUGIN_REGISTRY[dep]
        assert(dep_config, string.format("INVARIANT FAILED: dependency '%s' must exist in registry", dep))
        
        if not load_plugin(dep, dep_config) then
          error(string.format("CRITICAL INVARIANT FAILED: failed to load required dependency '%s' for plugin '%s'", dep, name))
        end
      end
    end
  end
  
  local success = false
  
  if config.setup_fn then
    -- INVARIANT: Custom setup must be function
    assert(type(config.setup_fn) == "function", 
           string.format("INVARIANT FAILED: plugin '%s' setup_fn must be function", name))
    success = utils.safe_call(config.setup_fn, string.format("plugin '%s' custom setup", name))
  elseif config.config_module then
    -- INVARIANT: Config module must be string
    assert(type(config.config_module) == "string" and #config.config_module > 0,
           string.format("INVARIANT FAILED: plugin '%s' config_module must be non-empty string", name))
    
    local plugin_module = utils.safe_require(config.config_module)
    if plugin_module then
      -- INVARIANT: Plugin module must have setup function
      assert(type(plugin_module.setup) == "function",
             string.format("INVARIANT FAILED: plugin module '%s' must have setup function", config.config_module))
      success = utils.safe_call(plugin_module.setup, string.format("plugin '%s' module setup", name))
    end
  else
    error(string.format("INVARIANT FAILED: plugin '%s' must have either setup_fn or config_module", name))
  end
  
  if success then
    loaded_plugins[name] = true
  end
  
  return success
end

function M.load_all()
  -- CRITICAL INVARIANT: General category must be enabled
  assert(utils.has_category("general"), "CRITICAL INVARIANT FAILED: general category must be enabled for plugin loading")
  
  -- INVARIANT: Plugin registry must be properly structured
  assert(type(PLUGIN_REGISTRY) == "table", "INVARIANT FAILED: PLUGIN_REGISTRY must be table")
  assert(next(PLUGIN_REGISTRY) ~= nil, "INVARIANT FAILED: PLUGIN_REGISTRY cannot be empty")
  
  local sorted_plugins = {}
  for name, config in pairs(PLUGIN_REGISTRY) do
    -- INVARIANT: Each plugin entry must be valid
    assert(type(name) == "string" and #name > 0, "INVARIANT FAILED: plugin name must be non-empty string")
    assert(type(config) == "table", string.format("INVARIANT FAILED: plugin '%s' config must be table", name))
    assert(config.category, string.format("INVARIANT FAILED: plugin '%s' must have category", name))
    assert(type(config.priority) == "number", string.format("INVARIANT FAILED: plugin '%s' must have numeric priority", name))
    
    table.insert(sorted_plugins, { name = name, config = config })
  end
  
  -- INVARIANT: Must have plugins to sort
  assert(#sorted_plugins > 0, "INVARIANT FAILED: must have plugins to load")
  
  table.sort(sorted_plugins, function(a, b)
    return (a.config.priority or 999) < (b.config.priority or 999)
  end)
  
  -- Load theme first if available
  local theme_config = PLUGIN_REGISTRY.theme
  if theme_config then
    local theme_success = load_plugin("theme", theme_config)
    -- NEGATIVE: Theme loading failure is acceptable but should be noted
    if not theme_success then
      vim.notify("Theme failed to load, continuing with other plugins", vim.log.levels.WARN)
    end
  end
  
  vim.defer_fn(function()
    local loaded_count = 0
    local total_count = #sorted_plugins
    local failed_plugins = {}
    
    for _, item in ipairs(sorted_plugins) do
      if item.name ~= "theme" then
        if load_plugin(item.name, item.config) then
          loaded_count = loaded_count + 1
        else
          table.insert(failed_plugins, item.name)
        end
      end
    end
    
    -- NEGATIVE: If too many plugins fail, system is unstable
    local failure_rate = (#failed_plugins / total_count)
    assert(failure_rate < 0.5, 
           string.format("CRITICAL INVARIANT FAILED: too many plugins failed to load (%.1f%% failure rate)", failure_rate * 100))
    
    if #failed_plugins > 0 then
      vim.notify(
        string.format("Failed to load plugins: %s", table.concat(failed_plugins, ", ")),
        vim.log.levels.WARN
      )
    end
    
    vim.notify(
      string.format("Loaded %d/%d plugins successfully", loaded_count, total_count - 1),
      vim.log.levels.INFO
    )
  end, 50)
end

function M.load_plugin(name)
  -- INVARIANT: Plugin name must be valid
  assert(type(name) == "string" and #name > 0, "INVARIANT FAILED: plugin name must be non-empty string")
  
  local config = PLUGIN_REGISTRY[name]
  assert(config, string.format("INVARIANT FAILED: plugin '%s' must exist in registry", name))
  
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
  
  -- INVARIANT: Must return non-empty list
  assert(#plugins > 0, "INVARIANT FAILED: plugin list cannot be empty")
  return plugins
end

function M.is_loaded(name)
  -- INVARIANT: Plugin name must be valid
  assert(type(name) == "string" and #name > 0, "INVARIANT FAILED: plugin name must be non-empty string")
  return loaded_plugins[name] or false
end

return M