local M = {}

function M.has_category(category)
  assert(
    _G.nixCats and type(_G.nixCats) == "table",
    "CRITICAL INVARIANT FAILED: _G.nixCats global table not found or not a table. " ..
    "This is required for the nixCats Lua utilities to operate."
  )
  return _G.nixCats[category] == true
end

M.nixcats = M.has_category

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

function M.has_plugin(plugin_name)
  local root_name = plugin_name:match("^[.-]+") or plugin_name
  local status, _ = pcall(require, root_name)
  return status
end

function M.defer(fn, delay)
  vim.defer_fn(function()
    M.safe_call(fn, string.format("Deferred function '%s'", tostring(fn)))
  end, delay or 10)
end

function M.merge_tables(t1, t2)
  local result = vim.tbl_deep_extend("force", {}, t1 or {})
  return vim.tbl_deep_extend("force", result, t2 or {})
end

function M.keymap(mode, lhs, rhs, opts)
  local default_opts = { noremap = true, silent = true }
  local final_opts = M.merge_tables(default_opts, opts)
  vim.keymap.set(mode, lhs, rhs, final_opts)
end

return M