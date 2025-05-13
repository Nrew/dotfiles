local M = {}

-- Plugin loading order and groups
local PLUGIN_GROUPS = {
  colorscheme = {
    priority = 1,
    plugins = {"colorscheme"},
  },
  core = {
    priority = 2,
    plugins = {"treesitter", "lsp", "completion"},
  },
  ui = {
    priority = 3,
    plugins = {"telescope", "neo-tree", "lualine", "bufferline", "which-key"},
  },
  editor = {
    priority = 4,
    plugins = {"mini-pairs", "comment", "flash", "surround", "yanky"},
  },
  git = {
    priority = 5,
    plugins = {"gitsigns", "lazygit"},
  },
  extra = {
    priority = 6,
    plugins = {"copilot", "project", "persistence", "yazi"},
  },
}

-- Lazy load a plugin configuration
local function lazy_load_plugin(plugin_name)
  return function()
    if nixCats("general") then
      local ok, plugin = pcall(require, "plugins." .. plugin_name)
      if not ok then
        vim.notify(
          string.format("Failed to load plugin '%s': %s", plugin_name, plugin),
          vim.log.levels.WARN
        )
        return
      end
      
      if type(plugin) == "table" and type(plugin.setup) == "function" then
        plugin.setup()
      end
    end
  end
end

-- Load plugins in groups with priority
function M.load()
  local groups = vim.tbl_values(PLUGIN_GROUPS)
  table.sort(groups, function(a, b) 
    return a.priority < b.priority 
  end)
  
  for _, group in ipairs(groups) do
    for _, plugin in ipairs(group.plugins) do
      vim.defer_fn(lazy_load_plugin(plugin), 100 * group.priority)
    end
  end
end

-- Initialize all plugins
M.load()

return M
