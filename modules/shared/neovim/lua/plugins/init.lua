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
    plugins = {"telescope", "neo-tree", "lualine", "bufferline", "which-key", "noice", "indent-blankline"},
  },
  editor = {
    priority = 4,
    plugins = {"mini-pairs", "comment", "flash", "surround", "yanky", "trouble", "todo-comments"},
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

-- Plugin-specific setup overrides for plugins that don't follow the standard pattern
local PLUGIN_OVERRIDES = {
  colorscheme = function()
    -- Rose-pine theme setup
    require("rose-pine").setup({
      variant = "auto",
      dark_variant = "main",
      bold_vert_split = false,
      dim_nc_background = false,
      disable_background = false,
      disable_float_background = false,
      disable_italics = false,
      groups = {
        background = "base",
        background_nc = "_experimental_nc",
        panel = "surface",
        panel_nc = "base",
        border = "highlight_med",
        comment = "muted",
        link = "iris",
        punctuation = "subtle",
        error = "love",
        hint = "iris",
        info = "foam",
        warn = "gold",
        headings = {
          h1 = "iris",
          h2 = "foam",
          h3 = "rose",
          h4 = "gold",
          h5 = "pine",
          h6 = "foam",
        }
      },
      highlight_groups = {
        ColorColumn = { bg = "rose" },
        CursorLine = { bg = "foam", blend = 10 },
        StatusLine = { fg = "love", bg = "love", blend = 10 },
      }
    })
    vim.cmd("colorscheme rose-pine")
  end,
}

-- Safely require and setup a plugin
local function safe_setup_plugin(plugin_name)
  local ok, plugin = pcall(require, "plugins." .. plugin_name)
  if not ok then
    vim.notify(
      string.format("Failed to load plugin config '%s': %s", plugin_name, plugin),
      vim.log.levels.WARN
    )
    return false
  end
  
  -- Check for override function first
  if PLUGIN_OVERRIDES[plugin_name] then
    local ok_override, err = pcall(PLUGIN_OVERRIDES[plugin_name])
    if not ok_override then
      vim.notify(
        string.format("Failed to run override for '%s': %s", plugin_name, err),
        vim.log.levels.ERROR
      )
    end
    return true
  end
  
  -- Standard plugin setup
  if type(plugin) == "table" then
    if type(plugin.setup) == "function" then
      local ok_setup, err = pcall(plugin.setup)
      if not ok_setup then
        vim.notify(
          string.format("Failed to setup plugin '%s': %s", plugin_name, err),
          vim.log.levels.ERROR
        )
        return false
      end
    elseif type(plugin.config) == "function" then
      -- Some plugins use config instead of setup
      local ok_config, err = pcall(plugin.config)
      if not ok_config then
        vim.notify(
          string.format("Failed to config plugin '%s': %s", plugin_name, err),
          vim.log.levels.ERROR
        )
        return false
      end
    end
  end
  
  return true
end

-- Lazy load a plugin configuration with error handling
local function lazy_load_plugin(plugin_name)
  return function()
    if not nixCats("general") then
      return
    end
    
    safe_setup_plugin(plugin_name)
  end
end

-- Load plugins in groups with priority
function M.load()
  if not nixCats("general") then
    vim.notify("nixCats general category not enabled, skipping plugin loading", vim.log.levels.WARN)
    return
  end
  
  local groups = vim.tbl_values(PLUGIN_GROUPS)
  table.sort(groups, function(a, b) 
    return a.priority < b.priority 
  end)
  
  for _, group in ipairs(groups) do
    for _, plugin in ipairs(group.plugins) do
      -- Use vim.defer_fn for async loading with different delays per group
      vim.defer_fn(lazy_load_plugin(plugin), 50 * group.priority)
    end
  end
end

-- Manual setup function for specific plugins if needed
function M.setup_plugin(plugin_name)
  if not nixCats("general") then
    vim.notify("nixCats general category not enabled", vim.log.levels.WARN)
    return false
  end
  
  return safe_setup_plugin(plugin_name)
end

-- Get list of available plugin configs
function M.list_plugins()
  local available = {}
  for _, group in pairs(PLUGIN_GROUPS) do
    for _, plugin in ipairs(group.plugins) do
      table.insert(available, plugin)
    end
  end
  return available
end

-- Initialize all plugins
M.load()

return M
