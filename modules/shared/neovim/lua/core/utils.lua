local M = {}

assert(
  _G.nixCats and type(_G.nixCats) == "function",
  "CRITICAL INVARIANT FAILED: _G.nixCats global function not found or not a function. " ..
  "This is required for the nixCats Lua utilities to operate."
)

function M.has_category(category)
  return _G.nixCats(category)
end

M.nixcats = M.has_category

-- Wrapper for pcall to execute a function
---@param fn function The function to call
---@param error_context string Context for error messages
---@param ... any Arguments to pass to the function
---@return boolean success True if the function executed without errors
function M.safe_call(fn, error_context, ...)
  if type(fn) ~= "function" then
    vim.notify(
      string.format("Attempted to call non-function in %s", error_context),
      vim.log.levels.ERROR
    )
    return false
  end

  local status, err = pcall(fn, ...)
  if not status then
    vim.notify(
      string.format("Error during %s: %s", error_context, tostring(err)),
      vim.log.levels.ERROR
    )
    return false
  end
  return true
end

-- Wrapper for require
---@param module_name string The name of the module to require
---@return table|nil         The loaded module, or nil on failure
function M.safe_require(module_name)
  local status, module = pcall(require, module_name)
  if not status then
    vim.notify(
      string.format("Failed to load module '%s': %s", module_name, tostring(module)),
      vim.log.levels.WARN
    )
    return nil
  end
  return module
end

-- Check if a Lua module (presumably a plugin) is available
---@param plugin_name string  The name of the plugin (Lua module name)
---@return boolean            True if the plugin can be required
function M.has_plugin(plugin_name)
  local root_name = plugin_name:match("^[.-]+") or plugin_name
  local status, _ = pcall(require, root_name)
  return status
end

-- Defer function execution with error handling
---@param fn function         The function to defer
---@param delay number|nil    The delay in milliseconds (default 10)
function M.defer(fn, delay)
  vim.defer_fn(function()
    M.safe_call(fn, string.format("Deferred function '%s'", tostring(fn)))
  end, delay or 10)
end

-- Merge two tables together
---@param t1 table First table
---@param t2 table Second table
---@return table The merged table
function M.merge_tables(t1, t2)
  local result = vim.tbl_deep_extend("force", {}, t1 or {})
  return vim.tbl_deep_extend("force", result, t2 or {})
end

-- Keymap setting helper with common defaults
---@param mode string|table   Modes for the keymap (e.g., "n", "v", {"n", "x"})
---@param lhs string          The left-hand side of the mapping
---@param rhs string|function The right-hand side (command or Lua function)
---@param opts table|nil      Additional options for vim.keymap.set
function M.keymap(mode, lhs, rhs, opts)
  local default_opts = { noremap = true, silent = true }
  local final_opts = M.merge_tables(default_opts, opts)
  vim.keymap.set(mode, lhs, rhs, final_opts)
end

return M