local M = {}

-- Constants
local LOG_LEVELS = vim.log.levels

-- Single source of truth for nixCats detection
function M.get_nixcats()
  return type(_G.nixCats) == "function" and _G.nixCats or 
         type(nixCats) == "function" and nixCats or nil
end

function M.has_category(category)
  if type(category) ~= "string" or #category == 0 then
    error("INVARIANT FAILED: category must be non-empty string")
  end
  
  local nixcats_fn = M.get_nixcats()
  if not nixcats_fn then return false end
  
  local status, result = pcall(nixcats_fn, category)
  return status and result and true or false
end

-- Consolidated validation with single error format
local function validate_type(value, name, expected_type, allow_nil)
  if allow_nil and value == nil then return true end
  if type(value) ~= expected_type then
    error(string.format("INVARIANT FAILED: %s must be %s", name, expected_type))
  end
  return true
end

local function validate_non_empty(value, name)
  if type(value) == "string" and #value == 0 then
    error(string.format("INVARIANT FAILED: %s cannot be empty", name))
  end
  if type(value) == "table" and next(value) == nil then
    error(string.format("INVARIANT FAILED: %s cannot be empty", name))
  end
  return true
end

-- Consolidated validation functions
function M.validate_string(value, name, allow_empty)
  validate_type(value, name, "string")
  if not allow_empty then validate_non_empty(value, name) end
  return true
end

function M.validate_table(value, name, allow_empty)
  validate_type(value, name, "table")
  if not allow_empty then validate_non_empty(value, name) end
  return true
end

function M.validate_number(value, name, min_val, max_val)
  validate_type(value, name, "number")
  if min_val and value < min_val then
    error(string.format("INVARIANT FAILED: %s must be >= %s", name, min_val))
  end
  if max_val and value > max_val then
    error(string.format("INVARIANT FAILED: %s must be <= %s", name, max_val))
  end
  return true
end

function M.validate_function(value, name)
  validate_type(value, name, "function")
  return true
end

-- Consolidated error handling
function M.safe_call(fn, context, ...)
  M.validate_function(fn, "function parameter")
  M.validate_string(context, "error context")
  
  local status, result = pcall(fn, ...)
  if not status then
    vim.notify(
      string.format("Error during %s: %s", context, tostring(result)),
      LOG_LEVELS.ERROR
    )
    return false
  end
  return true
end

function M.safe_require(module_name)
  M.validate_string(module_name, "module_name")
  
  local status, module = pcall(require, module_name)
  if not status then
    vim.notify(
      string.format("Failed to load module '%s': %s", module_name, tostring(module)),
      LOG_LEVELS.WARN
    )
    return nil
  end
  return module
end

-- Simplified table operations
function M.merge_tables(t1, t2)
  if not t1 and not t2 then return {} end
  
  local first = t1 or {}
  local second = t2 or {}
  
  if t1 then M.validate_table(t1, "t1") end
  if t2 then M.validate_table(t2, "t2") end
  
  return vim.tbl_deep_extend("force", vim.tbl_deep_extend("force", {}, first), second)
end

-- Consolidated keymap function
function M.keymap(mode, lhs, rhs, opts)
  -- Validate mode
  if type(mode) == "string" then
    M.validate_string(mode, "mode")
  elseif type(mode) == "table" then
    M.validate_table(mode, "mode")
    for i, m in ipairs(mode) do
      M.validate_string(m, string.format("mode[%d]", i))
    end
  else
    error("INVARIANT FAILED: mode must be string or table of strings")
  end
  
  M.validate_string(lhs, "lhs")
  
  if type(rhs) ~= "string" and type(rhs) ~= "function" then
    error("INVARIANT FAILED: rhs must be string or function")
  end
  
  if opts then M.validate_table(opts, "opts") end
  
  local final_opts = M.merge_tables({ noremap = true, silent = true }, opts)
  
  local status, err = pcall(vim.keymap.set, mode, lhs, rhs, final_opts)
  if not status then
    vim.notify(
      string.format("Failed to set keymap %s -> %s: %s", lhs, tostring(rhs), tostring(err)),
      LOG_LEVELS.WARN
    )
    return false
  end
  return true
end

-- Utility functions
function M.has_plugin(plugin_name)
  M.validate_string(plugin_name, "plugin_name")
  local root_name = plugin_name:match("^[.-]+") or plugin_name
  return pcall(require, root_name)
end

function M.defer(fn, delay)
  M.validate_function(fn, "deferred function")
  M.validate_number(delay or 10, "delay", 0)
  
  vim.defer_fn(function()
    M.safe_call(fn, string.format("deferred function after %dms", delay or 10))
  end, delay or 10)
end

-- Backward compatibility
M.nixcats = M.has_category

return M
