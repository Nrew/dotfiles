-- nixcats plugin loader - revised implementation with proper invariance
local utils = require("core.utils")

local M = {}

-- Constants
local DEFER_DELAY_MS = 50
local MAX_FAILURE_RATE = 0.5
local THEME_PRIORITY = 1

local PLUGIN_REGISTRY = {
  theme = { category = "general", priority = THEME_PRIORITY, config_module = "plugins.theme" },
  treesitter = { category = "general", priority = 2, config_module = "plugins.treesitter" },
  lsp = { category = "general", priority = 3, config_module = "plugins.lsp" },
  completion = { category = "general", priority = 4, dependencies = { "lsp" }, config_module = "plugins.completion" },
  telescope = { category = "general", priority = 5, config_module = "plugins.telescope" },
  ["neo-tree"] = { category = "general", priority = 6, config_module = "plugins.neo-tree" },
  lualine = { category = "general", priority = 7, dependencies = { "theme" }, config_module = "plugins.lualine" },
  bufferline = { category = "general", priority = 8, dependencies = { "theme" }, config_module = "plugins.bufferline" },
  ["which-key"] = { category = "general", priority = 9, config_module = "plugins.which-key" },
  noice = { category = "general", priority = 10, config_module = "plugins.noice" },
  ["indent-blankline"] = { category = "general", priority = 11, config_module = "plugins.indent-blankline" },
  ["mini-pairs"] = { category = "general", priority = 12, config_module = "plugins.mini-pairs" },
  comment = { category = "general", priority = 13, config_module = "plugins.comment" },
  flash = { category = "general", priority = 14, config_module = "plugins.flash" },
  surround = { category = "general", priority = 15, config_module = "plugins.surround" },
  yanky = { category = "general", priority = 16, config_module = "plugins.yanky" },
  trouble = { category = "general", priority = 17, dependencies = { "lsp" }, config_module = "plugins.trouble" },
  ["todo-comments"] = { category = "general", priority = 18, config_module = "plugins.todo-comments" },
  gitsigns = { category = "general", priority = 19, config_module = "plugins.gitsigns" },
  lazygit = { category = "general", priority = 20, config_module = "plugins.lazygit" },
  copilot = { category = "general", priority = 21, config_module = "plugins.copilot" },
  project = { category = "general", priority = 22, config_module = "plugins.project" },
  persistence = { category = "general", priority = 23, config_module = "plugins.persistence" },
  yazi = { category = "general", priority = 24, config_module = "plugins.yazi" },
}

local loaded_plugins = {}

-- INVARIANT: Validate plugin registry structure at module load time
local function validate_registry()
  if not next(PLUGIN_REGISTRY) then
    error("CRITICAL INVARIANT FAILED: PLUGIN_REGISTRY cannot be empty")
  end
  
  for name, config in pairs(PLUGIN_REGISTRY) do
    if type(name) ~= "string" or #name == 0 then
      error("INVARIANT FAILED: plugin name must be non-empty string")
    end
    if type(config) ~= "table" then
      error(string.format("INVARIANT FAILED: plugin '%s' config must be table", name))
    end
    if type(config.category) ~= "string" or #config.category == 0 then
      error(string.format("INVARIANT FAILED: plugin '%s' must have non-empty category", name))
    end
    if type(config.priority) ~= "number" then
      error(string.format("INVARIANT FAILED: plugin '%s' must have numeric priority", name))
    end
    if config.dependencies then
      if type(config.dependencies) ~= "table" then
        error(string.format("INVARIANT FAILED: plugin '%s' dependencies must be table", name))
      end
      for _, dep in ipairs(config.dependencies) do
        if type(dep) ~= "string" or #dep == 0 then
          error(string.format("INVARIANT FAILED: dependency '%s' must be non-empty string", tostring(dep)))
        end
        if not PLUGIN_REGISTRY[dep] then
          error(string.format("INVARIANT FAILED: dependency '%s' must exist in registry", dep))
        end
      end
    end
  end
end

-- Validate at module load time
validate_registry()

local function load_plugin(name, config)
  -- NEGATIVE: Skip if already loaded
  if loaded_plugins[name] then
    return true
  end
  
  -- NEGATIVE: Skip if category not enabled
  if not utils.has_category(config.category) then
    return false
  end
  
  -- NEGATIVE: Fail if dependencies not satisfied
  if config.dependencies then
    for _, dep in ipairs(config.dependencies) do
      if not loaded_plugins[dep] then
        local dep_config = PLUGIN_REGISTRY[dep]
        if not load_plugin(dep, dep_config) then
          error(string.format("CRITICAL INVARIANT FAILED: failed to load required dependency '%s' for plugin '%s'", dep, name))
        end
      end
    end
  end
  
  local success = false
  
  if config.setup_fn then
    success = utils.safe_call(config.setup_fn, string.format("plugin '%s' custom setup", name))
  elseif config.config_module then
    local plugin_module = utils.safe_require(config.config_module)
    if plugin_module then
      if type(plugin_module.setup) ~= "function" then
        error(string.format("INVARIANT FAILED: plugin module '%s' must have setup function", config.config_module))
      end
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

local function create_sorted_plugins()
  local sorted = {}
  for name, config in pairs(PLUGIN_REGISTRY) do
    table.insert(sorted, { name = name, config = config })
  end
  
  table.sort(sorted, function(a, b)
    return a.config.priority < b.config.priority
  end)
  
  return sorted
end

local function load_theme_first()
  local theme_config = PLUGIN_REGISTRY.theme
  if not theme_config then
    return false
  end
  
  local success = load_plugin("theme", theme_config)
  if not success then
    vim.notify("Theme failed to load, continuing with defaults", vim.log.levels.WARN)
  end
  return success
end

local function calculate_failure_stats(failed_plugins, total_plugins, exclude_theme)
  local adjusted_total = exclude_theme and (total_plugins - 1) or total_plugins
  local failure_rate = adjusted_total > 0 and (#failed_plugins / adjusted_total) or 0
  return failure_rate, adjusted_total
end

function M.load_all()
  -- CRITICAL INVARIANT: General category must be enabled
  if not utils.has_category("general") then
    error("CRITICAL INVARIANT FAILED: general category must be enabled for plugin loading")
  end
  
  local sorted_plugins = create_sorted_plugins()
  local theme_loaded = load_theme_first()
  
  vim.defer_fn(function()
    local loaded_count = theme_loaded and 1 or 0
    local failed_plugins = {}
    
    for _, item in ipairs(sorted_plugins) do
      -- NEGATIVE: Skip theme as it's already processed
      if item.name ~= "theme" then
        if load_plugin(item.name, item.config) then
          loaded_count = loaded_count + 1
        else
          table.insert(failed_plugins, item.name)
        end
      end
    end
    
    local failure_rate, adjusted_total = calculate_failure_stats(failed_plugins, #sorted_plugins, true)
    
    -- NEGATIVE: System is unstable if too many plugins fail
    if failure_rate >= MAX_FAILURE_RATE then
      error(string.format("CRITICAL INVARIANT FAILED: too many plugins failed to load (%.1f%% failure rate)", failure_rate * 100))
    end
    
    -- NEGATIVE: Only notify if there are failures
    if #failed_plugins > 0 then
      vim.notify(
        string.format("Failed to load plugins: %s", table.concat(failed_plugins, ", ")),
        vim.log.levels.WARN
      )
    end
    
    vim.notify(
      string.format("Loaded %d/%d plugins successfully", loaded_count, adjusted_total),
      vim.log.levels.INFO
    )
  end, DEFER_DELAY_MS)
end

function M.load_plugin(name)
  local config = PLUGIN_REGISTRY[name]
  if not config then
    error(string.format("INVARIANT FAILED: plugin '%s' must exist in registry", name))
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
  return loaded_plugins[name] or false
end

function M.get_stats()
  local total = 0
  local loaded = 0
  
  for _ in pairs(PLUGIN_REGISTRY) do
    total = total + 1
  end
  
  for _ in pairs(loaded_plugins) do
    loaded = loaded + 1
  end
  
  return {
    total = total,
    loaded = loaded,
    failure_rate = total > 0 and ((total - loaded) / total) or 0
  }
end

return M
