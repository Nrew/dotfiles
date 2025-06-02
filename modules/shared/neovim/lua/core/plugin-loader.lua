local M = {}

local PLUGIN_REGISTRY = {
  theme      =           { category = "general", priority = 1,  module = "plugins.theme" },
  treesitter =           { category = "general", priority = 2,  module = "plugins.treesitter" },
  lsp        =           { category = "general", priority = 3,  module = "plugins.lsp" },
  completion =           { category = "general", priority = 4,  dependencies = { "lsp" }, module = "plugins.completion" },
  telescope  =           { category = "general", priority = 5,  module = "plugins.telescope" },
  ["neo-tree"] =         { category = "general", priority = 6,  module = "plugins.neo-tree" },
  lualine =              { category = "general", priority = 7,  dependencies = { "theme" }, module = "plugins.lualine" },
  bufferline =           { category = "general", priority = 8,  dependencies = { "theme" }, module = "plugins.bufferline" },
  ["which-key"] =        { category = "general", priority = 9,  module = "plugins.which-key" },
  noice =                { category = "general", priority = 10, module = "plugins.noice" },
  ["indent-blankline"] = { category = "general", priority = 11, module = "plugins.indent-blankline" },
  ["mini-pairs"] =       { category = "general", priority = 12, module = "plugins.mini-pairs" },
  comment =              { category = "general", priority = 13, module = "plugins.comment" },
  flash =                { category = "general", priority = 14, module = "plugins.flash" },
  surround =             { category = "general", priority = 15, module = "plugins.surround" },
  yanky =                { category = "general", priority = 16, module = "plugins.yanky" },
  trouble =              { category = "general", priority = 17, dependencies = { "lsp" }, module = "plugins.trouble" },
  ["todo-comments"] =    { category = "general", priority = 18, module = "plugins.todo-comments" },
  gitsigns =             { category = "general", priority = 19, module = "plugins.gitsigns" },
  lazygit =              { category = "general", priority = 20, module = "plugins.lazygit" },
  project =              { category = "general", priority = 22, module = "plugins.project" },
  persistence =          { category = "general", priority = 23, module = "plugins.persistence" },
  yazi =                 { category = "general", priority = 24, module = "plugins.yazi" },
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
    return (a.spec.priority or 0) > (b.spec.priority or 0)
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

  local status, plugin = pcall(require, spec.module)
  if not status then
    mark_failed(name, "module not found")
    return false
  end

  if type(plugin.setup) ~= "function" then
    mark_failed(name, "no setup function")
    return false
  end

  local setup_ok = pcall(plugin.setup)
  
  if not setup_ok then
    mark_failed(name, "setup_failed")
    return false
  end

  mark_loaded(name)
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
