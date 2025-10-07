local M = {}

function M.setup()
  -- Load centralized theme palette from Nix
  local ok, palette = pcall(require, "theme.palette")
  if not ok then
    vim.notify("Theme palette not found, using fallback", vim.log.levels.WARN)
    -- Fallback Rose Pine theme colors with better contrast
    palette = {
      background = "#191724",
      surface = "#1f1d2e",
      overlay = "#26233a",
      text = "#e0def4",
      subtext = "#908caa",
      muted = "#6e6a86",
      primary = "#c4a7e7",
      secondary = "#ebbcba",
      success = "#9ccfd8",
      warning = "#f6c177",
      error = "#eb6f92",
      info = "#31748f",
      border = "#403d52",
      selection = "#2a283e",
      cursor = "#e0def4",
      link = "#c4a7e7",
    }
  end

  local rose_pine_ok, rose_pine = pcall(require, "rose-pine")
  if not rose_pine_ok then
    vim.notify("Rose Pine theme not found, using fallback colorscheme", vim.log.levels.WARN)
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
      border = palette.border,
      comment = palette.muted,
      error = palette.error,
      hint = palette.primary,
      info = palette.info,
      warn = palette.warning,
    },

    highlight_groups = {
      -- Better contrast for borders and backgrounds
      TelescopeBorder = { fg = palette.border, bg = palette.background },
      TelescopeNormal = { bg = palette.surface },
      NormalFloat = { bg = palette.surface },
      FloatBorder = { fg = palette.border, bg = palette.surface },
      
      -- Improved diagnostic virtual text with backgrounds for better visibility
      DiagnosticVirtualTextError = { fg = palette.error, bg = palette.overlay },
      DiagnosticVirtualTextWarn = { fg = palette.warning, bg = palette.overlay },
      DiagnosticVirtualTextInfo = { fg = palette.info, bg = palette.overlay },
      DiagnosticVirtualTextHint = { fg = palette.primary, bg = palette.overlay },
      
      -- Better selection and search visibility
      Visual = { bg = palette.selection },
      Search = { fg = palette.background, bg = palette.warning, bold = true },
      IncSearch = { fg = palette.background, bg = palette.secondary, bold = true },
    },
  })

  vim.cmd.colorscheme("rose-pine")

  -- Additional custom highlights using centralized palette for better contrast
  local custom_highlights = {
    -- Line numbers and cursor
    CursorLineNr = { fg = palette.primary, bold = true },
    LineNr = { fg = palette.muted },
    
    -- Folding with better contrast
    Folded = { fg = palette.text, bg = palette.overlay },
    FoldColumn = { fg = palette.muted, bg = palette.background },
    
    -- Status and tab lines
    StatusLine = { fg = palette.text, bg = palette.surface },
    StatusLineNC = { fg = palette.muted, bg = palette.surface },
    TabLine = { fg = palette.subtext, bg = palette.surface },
    TabLineFill = { bg = palette.background },
    TabLineSel = { fg = palette.text, bg = palette.overlay, bold = true },
    
    -- Better popup menu contrast
    Pmenu = { fg = palette.text, bg = palette.surface },
    PmenuSel = { fg = palette.background, bg = palette.primary, bold = true },
    PmenuSbar = { bg = palette.overlay },
    PmenuThumb = { bg = palette.primary },
  }

  for group, opts in pairs(custom_highlights) do
    vim.api.nvim_set_hl(0, group, opts)
  end
end

return M