-- nixcats plugin loader - consolidated implementation
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

-- Consolidated validation using utils
local function validate_plugin_config(name, config)
  utils.validate_string(name, "plugin name")
  utils.validate_table(config, string.format("plugin '%s' config", name))
  utils.validate_string(config.category, string.format("plugin '%s' category", name))
  utils.validate_number(config.priority, string.format("plugin '%s' priority", name))
  
  if config.dependencies then
    utils.validate_table(config.dependencies, string.format("plugin '%s' dependencies", name))
    for _, dep in ipairs(config.dependencies) do
      utils.validate_string(dep, "dependency")
      if not PLUGIN_REGISTRY[dep] then
        error(string.format("INVARIANT FAILED: dependency '%s' must exist in registry", dep))
      end
    end
  end
end

-- Validate registry at module load
for name, config in pairs(PLUGIN_REGISTRY) do
  validate_plugin_config(name, config)
end

local function load_plugin(name, config)
  if loaded_plugins[name] then return true end
  if not utils.has_category(config.category) then return false end
  
  -- Load dependencies first
  if config.dependencies then
    for _, dep in ipairs(config.dependencies) do
      if not loaded_plugins[dep] and not load_plugin(dep, PLUGIN_REGISTRY[dep]) then
        error(string.format("CRITICAL INVARIANT FAILED: failed to load dependency '%s' for '%s'", dep, name))
      end
    end
  end
  
  local success = false
  if config.setup_fn then
    success = utils.safe_call(config.setup_fn, string.format("plugin '%s' custom setup", name))
  elseif config.config_module then
    local plugin_module = utils.safe_require(config.config_module)
    if plugin_module then
      utils.validate_function(plugin_module.setup, string.format("plugin module '%s' setup", config.config_module))
      success = utils.safe_call(plugin_module.setup, string.format("plugin '%s' module setup", name))
    end
  else
    error(string.format("INVARIANT FAILED: plugin '%s' must have setup_fn or config_module", name))
  end
  
  if success then loaded_plugins[name] = true end
  return success
end

-- Simplified plugin processing
local function process_plugins()
  local sorted = {}
  for name, config in pairs(PLUGIN_REGISTRY) do
    table.insert(sorted, { name = name, config = config })
  end
  
  table.sort(sorted, function(a, b) return a.config.priority < b.config.priority end)
  
  return sorted
end

local function load_with_stats(plugins)
  local loaded_count = 0
  local failed_plugins = {}
  
  for _, item in ipairs(plugins) do
    if item.name ~= "theme" then  -- Theme handled separately
      if load_plugin(item.name, item.config) then
        loaded_count = loaded_count + 1
      else
        table.insert(failed_plugins, item.name)
      end
    end
  end
  
  return loaded_count, failed_plugins
end

function M.load_all()
  if not utils.has_category("general") then
    vim.notify("General category not enabled, skipping plugin loading", vim.log.levels.WARN)
    return
  end
  
  local sorted_plugins = process_plugins()
  local theme_loaded = load_plugin("theme", PLUGIN_REGISTRY.theme)
  
  vim.defer_fn(function()
    local loaded_count, failed_plugins = load_with_stats(sorted_plugins)
    if theme_loaded then loaded_count = loaded_count + 1 end
    
    local total = #sorted_plugins
    local failure_rate = total > 0 and (#failed_plugins / total) or 0
    
    if failure_rate >= MAX_FAILURE_RATE then
      error(string.format("CRITICAL INVARIANT FAILED: %.1f%% plugin failure rate", failure_rate * 100))
    end
    
    if #failed_plugins > 0 then
      vim.notify(string.format("Failed plugins: %s", table.concat(failed_plugins, ", ")), vim.log.levels.WARN)
    end
    
    vim.notify(string.format("Loaded %d/%d plugins", loaded_count, total), vim.log.levels.INFO)
  end, DEFER_DELAY_MS)
end

function M.load_plugin(name)
  local config = PLUGIN_REGISTRY[name]
  if not config then
    error(string.format("INVARIANT FAILED: plugin '%s' not in registry", name))
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
  local total, loaded = 0, 0
  for _ in pairs(PLUGIN_REGISTRY) do total = total + 1 end
  for _ in pairs(loaded_plugins) do loaded = loaded + 1 end
  
  return {
    total = total,
    loaded = loaded,
    failure_rate = total > 0 and ((total - loaded) / total) or 0
  }
end

return M
