if vim.loader then
  vim.loader.enable()
end

require("core.options")
require("core.keymaps")
require("core.autocmds")

local loaded = {}
local failed = {}

local function load_plugin(name)
  local module_path = "plugins." .. name
  local status, module = pcall(require, module_path)

  if not status then
    failed[name] = "module not found: " .. tostring(module)
    return false
  end

  if type(module.setup) ~= "function" then
    failed[name] = "no setup function"
    return false
  end

  local setup_ok, setup_err = pcall(module.setup)
  if not setup_ok then
    failed[name] = "setup failed: " .. tostring(setup_err)
    return false
  end

  loaded[name] = true
  return true
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
    #loaded_list > 0 and "✔ " .. table.concat(loaded_list, "\n✔ ") or "None",
    #failed_list,
    #failed_list > 0 and "✘ " .. table.concat(failed_list, "\n✘ ") or "None"
  )

  vim.notify(message, vim.log.levels.INFO, { title = "Plugin Loader" })
end

vim.api.nvim_create_autocmd("User", {
  pattern = "DeferredUIEnter",
  callback = function()
    -- Load plugins
    local plugins = {
      "luasnip",
      "treesitter", "lsp", "completion", "telescope", "neo-tree",
      "lualine", "bufferline", "which-key", "noice", "indent-blankline", 
      "mini-pairs", "comment", "flash", "surround", "yanky", "trouble",
      "todo-comments", "gitsigns", "lazygit", "project", "persistence", "yazi",
      "mini-icons", "stabilize"
    }

    for _, plugin in ipairs(plugins) do
      load_plugin(plugin)
    end

    vim.schedule(show_results)
  end,
})

vim.defer_fn(function()
  vim.api.nvim_exec_autocmds("User", { pattern = "DeferredUIEnter" })
end, 50)

vim.notify("NixCats Neovim ready", vim.log.levels.INFO)
