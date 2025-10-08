require("core.options")
require("core.keymaps")
require("core.autocmds")

-- Load theme first (it sets up the colorscheme)
local theme_ok, theme = pcall(require, "plugins.theme")
if theme_ok and type(theme.setup) == "function" then
  local setup_ok, setup_err = pcall(theme.setup)
  if not setup_ok then
    vim.notify("Failed to setup theme: " .. tostring(setup_err), vim.log.levels.WARN)
  end
else
  vim.notify("Theme module not found or invalid", vim.log.levels.WARN)
end

-- Plugin loading with better error handling
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

  if #failed_list > 0 then
    local message = string.format(
      "Plugin Loading Complete\n\n✔ Loaded %d plugins\n✘ Failed %d plugins:\n  %s",
      #loaded_list,
      #failed_list,
      table.concat(failed_list, "\n  ")
    )
    vim.notify(message, vim.log.levels.WARN, { title = "NixCats Neovim" })
  else
    vim.notify(
      string.format("✔ Successfully loaded %d plugins", #loaded_list),
      vim.log.levels.INFO,
      { title = "NixCats Neovim" }
    )
  end
end

-- Defer plugin loading to improve startup time
vim.api.nvim_create_autocmd("User", {
  pattern = "DeferredUIEnter",
  callback = function()
    -- Load plugins in order of dependency
    local plugins = {
      "luasnip",           -- Snippets first (completion depends on it)
      "treesitter",        -- Syntax highlighting
      "lsp",               -- LSP configuration
      "completion",        -- Completion (depends on LSP and snippets)
      "telescope",         -- Fuzzy finder
      "neo-tree",          -- File explorer
      "lualine",           -- Status line
      "bufferline",        -- Buffer line
      "which-key",         -- Key hints
      "noice",             -- UI enhancements
      "indent-blankline",  -- Indent guides
      "mini-pairs",        -- Auto pairs
      "comment",           -- Comment plugin
      "flash",             -- Jump plugin
      "surround",          -- Surround plugin
      "yanky",             -- Yank ring
      "trouble",           -- Diagnostics list
      "todo-comments",     -- TODO comments
      "gitsigns",          -- Git signs
      "lazygit",           -- LazyGit integration
      "project",           -- Project management
      "persistence",       -- Session persistence
      "yazi",              -- Yazi file manager
      "mini-icons",        -- Icons
      "stabilize",         -- Stabilize windows
    }

    for _, plugin in ipairs(plugins) do
      load_plugin(plugin)
    end

    vim.schedule(show_results)
  end,
})

-- Trigger deferred loading
vim.defer_fn(function()
  vim.api.nvim_exec_autocmds("User", { pattern = "DeferredUIEnter" })
end, 50)

vim.notify("NixCats Neovim initializing...", vim.log.levels.INFO)
