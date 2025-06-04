local M = {}

function M.setup()
  local ok, rose_pine = pcall(require, "rose-pine")
  if not ok then
    vim.cmd.colorscheme("habamax")
    return
  end

  rose_pine.setup({
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
  })

  vim.cmd.colorscheme("rose-pine")

  -- Additional custom highlights
  local custom_highlights = {
    CursorLineNr = { fg = "#e0def4", bold = true },
    Folded = { fg = "#908caa", bg = "#232136" },
    Search = { fg = "#191724", bg = "#f6c177" },
  }

  for group, opts in pairs(custom_highlights) do
    vim.api.nvim_set_hl(0, group, opts)
  end
end

return M