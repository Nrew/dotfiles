local M = {}

function M.setup()
  -- Load centralized theme palette from Nix
  local ok, palette = pcall(require, "theme.palette")
  if not ok then
    vim.notify("Theme palette not found, using fallback", vim.log.levels.WARN)
    palette = {
      background = "#191724",
      surface = "#1f1d2e",
      overlay = "#26233a",
      text = "#e0def4",
      subtext = "#908caa",
      muted = "#6e6a86",
      primary = "#c4a7e7",
      secondary = "#ea9a97",
      success = "#9ccfd8",
      warning = "#f6c177",
      error = "#eb6f92",
      info = "#31748f",
    }
  end

  local rose_pine_ok, rose_pine = pcall(require, "rose-pine")
  if not rose_pine_ok then
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
      background = palette.background,
      panel = palette.surface,
      border = palette.overlay,
      comment = palette.muted,
      error = palette.error,
      hint = palette.primary,
      info = palette.info,
      warn = palette.warning,
    },

    highlight_groups = {
      TelescopeBorder = { fg = palette.overlay, bg = palette.background },
      NormalFloat = { bg = palette.surface },
      FloatBorder = { fg = palette.overlay, bg = palette.surface },
      DiagnosticVirtualTextError = { fg = palette.error, bg = palette.surface },
      DiagnosticVirtualTextWarn = { fg = palette.warning, bg = palette.surface },
      DiagnosticVirtualTextInfo = { fg = palette.info, bg = palette.surface },
      DiagnosticVirtualTextHint = { fg = palette.primary, bg = palette.surface },
    },
  })

  vim.cmd.colorscheme("rose-pine")

  -- Additional custom highlights using centralized palette
  local custom_highlights = {
    CursorLineNr = { fg = palette.text, bold = true },
    Folded = { fg = palette.subtext, bg = palette.overlay },
    Search = { fg = palette.background, bg = palette.warning },
  }

  for group, opts in pairs(custom_highlights) do
    vim.api.nvim_set_hl(0, group, opts)
  end
end

return M