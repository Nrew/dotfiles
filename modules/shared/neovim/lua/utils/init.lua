-- Utility functions for Neovim configuration
local M = {}

-- Safe nixCats checking with fallback
function M.has_category(category)
  if type(nixCats) == "function" then
    return nixCats(category)
  end
  -- Fallback: assume basic categories are available if nixCats isn't loaded
  local basic_categories = { "general", "lua", "nix" }
  return vim.tbl_contains(basic_categories, category)
end

-- Safe plugin setup with error handling
function M.safe_setup(plugin_name, setup_fn)
  local ok, err = pcall(setup_fn)
  if not ok then
    vim.notify(
      string.format("Failed to setup '%s': %s", plugin_name, err),
      vim.log.levels.ERROR
    )
    return false
  end
  return true
end

-- Safe require with error handling
function M.safe_require(module_name)
  local ok, module = pcall(require, module_name)
  if not ok then
    vim.notify(
      string.format("Failed to load module '%s': %s", module_name, module),
      vim.log.levels.WARN
    )
    return nil
  end
  return module
end

-- Check if a plugin is available
function M.has_plugin(plugin_name)
  local ok, _ = pcall(require, plugin_name)
  return ok
end

-- Defer function with error handling
function M.defer(fn, delay)
  delay = delay or 100
  vim.defer_fn(function()
    local ok, err = pcall(fn)
    if not ok then
      vim.notify(
        string.format("Deferred function failed: %s", err),
        vim.log.levels.ERROR
      )
    end
  end, delay)
end

-- Set keymap with better defaults
function M.keymap(mode, lhs, rhs, opts)
  local options = { noremap = true, silent = true }
  if opts then
    options = vim.tbl_extend("force", options, opts)
  end
  vim.keymap.set(mode, lhs, rhs, options)
end

return M
