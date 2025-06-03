local utils = require("core.utils")
local M = {}

function M.load()
  return {

  }
end

function M.setup()
  assert(vim.cmd.colorscheme, "INVARIANT FAILED: vim.cmd.colorscheme not available")
  
  local rose_pine = utils.safe_require("rose-pine")
  
  if not rose_pine then
    assert(vim.fn.exists(":colorscheme"), "INVARIANT FAILED: colorscheme command must exist")
    local success = utils.safe_call(function() 
      vim.cmd.colorscheme("habamax") 
    end, "fallback colorscheme")
    assert(success, "CRITICAL INVARIANT FAILED: fallback colorscheme must work")
    return
  end

  assert(type(rose_pine.setup) == "function", "INVARIANT FAILED: rose-pine.setup must be function")

  local config = {
    variant = "main",
    dark_variant = "main",
    bold_vert_split = false,
    dim_nc_background = false,
    disable_background = false,
    disable_float_background = false,
    
    groups = {
      background = "#191724",
      panel = "#1f1d2e",
      border = "#26233a",
      comment = "#6e6a86",
      error = "#eb6f92",
      hint = "#c4a7e7",
      info = "#9ccfd8",
      warn = "#f6c177",
    },
    
    highlight_groups = {
      TelescopeBorder = { fg = "#26233a", bg = "#191724" },
      NormalFloat = { bg = "#1f1d2e" },
      FloatBorder = { fg = "#26233a", bg = "#1f1d2e" },
      DiagnosticVirtualTextError = { fg = "#eb6f92", bg = "#2a273f" },
      DiagnosticVirtualTextWarn = { fg = "#f6c177", bg = "#2a273f" },
      DiagnosticVirtualTextInfo = { fg = "#9ccfd8", bg = "#2a273f" },
      DiagnosticVirtualTextHint = { fg = "#c4a7e7", bg = "#2a273f" },
    },
  }

  assert(type(config.groups) == "table", "INVARIANT FAILED: groups must be table")
  assert(type(config.highlight_groups) == "table", "INVARIANT FAILED: highlight_groups must be table")

  local success = utils.safe_call(function()
    rose_pine.setup(config)
    
    vim.cmd.colorscheme("rose-pine")
    
    local current_colorscheme = vim.g.colors_name
    assert(current_colorscheme == "rose-pine", 
           string.format("INVARIANT FAILED: expected rose-pine colorscheme, got %s", tostring(current_colorscheme)))
    
    local custom_highlights = {
      CursorLineNr = { fg = "#e0def4", bold = true },
      Folded = { fg = "#908caa", bg = "#232136" },
      Search = { fg = "#191724", bg = "#f6c177" },
    }
    
    for group, opts in pairs(custom_highlights) do
      assert(type(group) == "string" and #group > 0, "INVARIANT FAILED: highlight group must be non-empty string")
      assert(type(opts) == "table", "INVARIANT FAILED: highlight opts must be table")
      vim.api.nvim_set_hl(0, group, opts)
    end
  end, "rose-pine setup")

  assert(success, "CRITICAL INVARIANT FAILED: rose-pine theme setup must succeed")
end

return M
