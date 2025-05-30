-- nixcats utils - revised implementation with proper invariance
local M = {}

-- Constants
local LOG_LEVELS = vim.log.levels

-- INVARIANT: nixCats function must be available and callable
local function get_nixcats_function()
  local candidates = {
    nixCats,
    _G.nixCats,
  }
  
  for _, candidate in ipairs(candidates) do
    if candidate and (type(candidate) == "function" or type(candidate) == "table") then
      return candidate
    end
  end
  
  return nil
end

function M.has_category(category)
  -- INVARIANT: Category must be non-empty string
  if type(category) ~= "string" or #category == 0 then
    error("INVARIANT FAILED: category must be non-empty string")
  end
  
  local nixcats_fn = get_nixcats_function()
  
  -- NEGATIVE: Return false if nixCats not available
  if not nixcats_fn then
    return false
  end
  
  -- NEGATIVE: Return false on any error
  local status, result = pcall(function()
    if type(nixcats_fn) == "function" then
      return nixcats_fn(category)
    elseif type(nixcats_fn) == "table" then
      return nixcats_fn[category]
    end
    return false
  end)
  
  return status and result or false
end

-- Alias for backward compatibility
M.nixcats = M.has_category

function M.safe_call(fn, error_context, ...)
  -- INVARIANT: Function must be callable
  if type(fn) ~= "function" then
    vim.notify(
      string.format("Attempted to call non-function in %s", error_context),
      LOG_LEVELS.ERROR
    )
    return false
  end
  
  -- INVARIANT: Error context must be provided
  if type(error_context) ~= "string" or #error_context == 0 then
    error("INVARIANT FAILED: error_context must be non-empty string")
  end
  
  local status, result = pcall(fn, ...)
  
  -- NEGATIVE: Return false and notify on error
  if not status then
    vim.notify(
      string.format("Error during %s: %s", error_context, tostring(result)),
      LOG_LEVELS.ERROR
    )
    return false
  end
  
  return true
end

function M.safe_require(module_name)
  -- INVARIANT: Module name must be non-empty string
  if type(module_name) ~= "string" or #module_name == 0 then
    error("INVARIANT FAILED: module_name must be non-empty string")
  end
  
  local status, module = pcall(require, module_name)
  
  -- NEGATIVE: Return nil and warn on failure
  if not status then
    vim.notify(
      string.format("Failed to load module '%s': %s", module_name, tostring(module)),
      LOG_LEVELS.WARN
    )
    return nil
  end
  
  return module
end

function M.has_plugin(plugin_name)
  -- INVARIANT: Plugin name must be non-empty string
  if type(plugin_name) ~= "string" or #plugin_name == 0 then
    error("INVARIANT FAILED: plugin_name must be non-empty string")
  end
  
  local root_name = plugin_name:match("^[.-]+") or plugin_name
  local status, _ = pcall(require, root_name)
  return status
end

function M.defer(fn, delay)
  -- INVARIANT: Function must be callable
  if type(fn) ~= "function" then
    error("INVARIANT FAILED: deferred function must be callable")
  end
  
  local actual_delay = delay or 10
  
  -- INVARIANT: Delay must be non-negative number
  if type(actual_delay) ~= "number" or actual_delay < 0 then
    error("INVARIANT FAILED: delay must be non-negative number")
  end
  
  vim.defer_fn(function()
    M.safe_call(fn, string.format("deferred function after %dms", actual_delay))
  end, actual_delay)
end

function M.merge_tables(t1, t2)
  -- NEGATIVE: Return empty table if both are nil
  if not t1 and not t2 then
    return {}
  end
  
  -- NEGATIVE: Use fallback if one is nil
  local first = t1 or {}
  local second = t2 or {}
  
  -- INVARIANT: Both parameters must be tables if provided
  if t1 and type(t1) ~= "table" then
    error("INVARIANT FAILED: t1 must be table or nil")
  end
  if t2 and type(t2) ~= "table" then
    error("INVARIANT FAILED: t2 must be table or nil")
  end
  
  local result = vim.tbl_deep_extend("force", {}, first)
  return vim.tbl_deep_extend("force", result, second)
end

function M.keymap(mode, lhs, rhs, opts)
  -- INVARIANT: Mode must be string or table of strings
  if type(mode) == "string" then
    if #mode == 0 then
      error("INVARIANT FAILED: mode string cannot be empty")
    end
  elseif type(mode) == "table" then
    if #mode == 0 then
      error("INVARIANT FAILED: mode table cannot be empty")
    end
    for i, m in ipairs(mode) do
      if type(m) ~= "string" or #m == 0 then
        error(string.format("INVARIANT FAILED: mode[%d] must be non-empty string", i))
      end
    end
  else
    error("INVARIANT FAILED: mode must be string or table of strings")
  end
  
  -- INVARIANT: LHS must be non-empty string
  if type(lhs) ~= "string" or #lhs == 0 then
    error("INVARIANT FAILED: lhs must be non-empty string")
  end
  
  -- INVARIANT: RHS must be string or function
  if type(rhs) ~= "string" and type(rhs) ~= "function" then
    error("INVARIANT FAILED: rhs must be string or function")
  end
  
  -- INVARIANT: Opts must be table if provided
  if opts and type(opts) ~= "table" then
    error("INVARIANT FAILED: opts must be table or nil")
  end
  
  local default_opts = { noremap = true, silent = true }
  local final_opts = M.merge_tables(default_opts, opts)
  
  local status, err = pcall(vim.keymap.set, mode, lhs, rhs, final_opts)
  
  -- NEGATIVE: Warn on keymap failure but don't crash
  if not status then
    vim.notify(
      string.format("Failed to set keymap %s -> %s: %s", lhs, tostring(rhs), tostring(err)),
      LOG_LEVELS.WARN
    )
    return false
  end
  
  return true
end

function M.validate_string(value, name, allow_empty)
  if type(value) ~= "string" then
    error(string.format("INVARIANT FAILED: %s must be string", name))
  end
  
  if not allow_empty and #value == 0 then
    error(string.format("INVARIANT FAILED: %s cannot be empty", name))
  end
  
  return true
end

function M.validate_table(value, name, allow_empty)
  if type(value) ~= "table" then
    error(string.format("INVARIANT FAILED: %s must be table", name))
  end
  
  if not allow_empty and next(value) == nil then
    error(string.format("INVARIANT FAILED: %s cannot be empty", name))
  end
  
  return true
end

function M.validate_number(value, name, min_val, max_val)
  if type(value) ~= "number" then
    error(string.format("INVARIANT FAILED: %s must be number", name))
  end
  
  if min_val and value < min_val then
    error(string.format("INVARIANT FAILED: %s must be >= %s", name, min_val))
  end
  
  if max_val and value > max_val then
    error(string.format("INVARIANT FAILED: %s must be <= %s", name, max_val))
  end
  
  return true
end

function M.validate_function(value, name)
  if type(value) ~= "function" then
    error(string.format("INVARIANT FAILED: %s must be function", name))
  end
  
  return true
end

return M
