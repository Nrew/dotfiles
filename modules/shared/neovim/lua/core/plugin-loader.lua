local M = {}

local PLUGIN_REGISTRY = {
  theme      =           { category = "general", priority = 999, module = "plugins.theme" },
  treesitter =           { category = "general", priority = 50,  module = "plugins.treesitter" },
  lsp        =           { category = "general", priority = 800, module = "plugins.lsp" },
  completion =           { category = "general", priority = 700, dependencies = { "lsp" }, module = "plugins.completion" },
  telescope  =           { category = "general", priority = 50,  module = "plugins.telescope" },
  ["neo-tree"] =         { category = "general", priority = 50,  module = "plugins.neo-tree" },
  lualine    =           { category = "general", priority = 50,  dependencies = { "theme" }, module = "plugins.lualine" },
  bufferline =           { category = "general", priority = 50,  dependencies = { "theme" }, module = "plugins.bufferline" },
  ["which-key"] =        { category = "general", priority = 50,  module = "plugins.which-key" },
  noice      =           { category = "general", priority = 50,  module = "plugins.noice" },
  ["indent-blankline"] = { category = "general", priority = 50,  module = "plugins.indent-blankline" },
  ["mini-pairs"] =       { category = "general", priority = 50,  module = "plugins.mini-pairs" },
  comment    =           { category = "general", priority = 50,  module = "plugins.comment" },
  flash      =           { category = "general", priority = 50,  module = "plugins.flash" },
  surround   =           { category = "general", priority = 50,  module = "plugins.surround" },
  yanky      =           { category = "general", priority = 50,  module = "plugins.yanky" },
  trouble    =           { category = "general", priority = 50,  dependencies = { "lsp" }, module = "plugins.trouble" },
  ["todo-comments"] =    { category = "general", priority = 50,  module = "plugins.todo-comments" },
  gitsigns   =           { category = "general", priority = 50,  module = "plugins.gitsigns" },
  lazygit    =           { category = "general", priority = 50,  module = "plugins.lazygit" },
  project    =           { category = "general", priority = 50,  module = "plugins.project" },
  persistence =          { category = "general", priority = 50,  module = "plugins.persistence" },
  yazi       =           { category = "general", priority = 50,  module = "plugins.yazi" },
}


-- PLUGIN LOADING

local loaded = {}
local failed = {}

local function is_loaded(name)
  return loaded[name] ~= nil
end

local function mark_loaded(name)
  loaded[name] = true
end

local function mark_failed(name, reason)
  failed[name] = reason
end

local function load_dependencies(spec)
  assert(spec, "INVARIANCE ERROR: spec is expected to be non nil")
  if not spec.dependencies then return true end
  
  for _, dep_name in ipairs(spec.dependencies) do
    if is_loaded(dep_name) then goto continue end

    local dep_spec = PLUGIN_REGISTRY[dep_name]

    if not dep_spec then
      mark_failed(dep_name, "missing from registry")
    end

    if not M.load_plugin(dep_name, dep_spec) then
      return false
    end
    ::continue::
  end

  return true
end

local function get_specs()
  local specs = {}

  for name, spec in pairs(PLUGIN_REGISTRY) do
    table.insert(specs, { name = name, spec = spec })
  end

  table.sort(specs, function(a, b)
    return (a.spec.priority or 50) > (b.spec.priority or 50)
  end)

  return specs
end

local function show_results()
  local loaded_list = {}
  local failed_list = {}

  for name in pairs(loaded) do
    table.insert(loaded_list, name)
  end

  for name, reason in pairs(failed) do
    table.insert(failed_list, name .. " (" .. reason .. ")")
  end
  table.sort(loaded_list)
  table.sort(failed_list)

  local message = string.format(
    "Plugin Loading Results:\n\nLoaded (%d): \n%s\n\nFailed (%d): \n%s",
    #loaded_list,
    #loaded_list > 0 and "| " .. table.concat(loaded_list, "\n| ") or "None",
    #failed_list,
    #failed_list > 0 and "| " .. table.concat(failed_list, "\n| ") or "None"
  )

  vim.notify(message, vim.log.levels.INFO, { title = "Plugin Loader" })
end

function M.load_plugin(name, spec)
  if is_loaded(name) or failed[name] then return is_loaded(name) end

  if not load_dependencies(spec) then
    mark_failed(name, "dependency failed")
    return false
  end

  local utils = require('core.utils')
  local lze   = utils.safe_require('lze')

  local lze_spec = {
    name,
    enabled = utils.has_category(spec.category or "general"),
    priority = spec.priority or 50,
    after   = function()
      local status, plugin = pcall(require, spec.module)
      if not status then
        mark_failed(name, "module not found: " .. tostring(plugin))
        return
      end

      if type(plugin.setup) ~= "function" then
        mark_failed(name, "no setup function")
        return
      end

      local setup_ok = pcall(plugin.setup)

      if not setup_ok then
        mark_failed(name, "setup_failed")
        return
      end

      mark_loaded(name)
    end,
  }

  local status, plugin = pcall(require, spec.module)
  if status and type(plugin.load) == "function" then
    local p_config = plugin.load()
    for key, value in pairs(p_config) do
      lze_spec[key] = value
    end
  end

  local success, err = pcall(lze.load, { lze_spec })
  if not sucess then
    mark_failed(name, "lze load failed: " .. tostring(err))
    return false
  end

  return true
end

function M.load_all()
  local specs = get_specs()

  for _, item in ipairs(specs) do
    M.load_plugin(item.name, item.spec)
  end

  vim.schedule(show_results)
end

function M.is_loaded(name)
  return is_loaded(name)
end

function M.get_stats()
  local loaded_count, failed_count = 0, 0
  
  for _ in pairs(loaded) do loaded_count = loaded_count + 1 end
  for _ in pairs(failed) do failed_count = failed_count + 1 end
  
  return {
    loaded = loaded_count,
    failed = failed_count,
    total = loaded_count + failed_count
  }
end

return M
