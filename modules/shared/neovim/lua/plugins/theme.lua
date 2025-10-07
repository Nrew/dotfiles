local M = {}

-- Cache the palette loader module
local palette_loader = nil

local function get_palette()
  -- Load the palette loader module (cached after first load)
  if not palette_loader then
    local ok, loader = pcall(require, "theme.palette")
    if not ok then
      vim.notify("Theme palette loader not found, using fallback", vim.log.levels.WARN)
      return {
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
    palette_loader = loader
  end
  
  -- Get current palette (will read from JSON if available)
  return palette_loader.get()
end

local function apply_theme()
  local palette = get_palette()

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

function M.setup()
  apply_theme()
  
  -- Watch for theme changes using file watching
  local config_home = vim.fn.expand(os.getenv("XDG_CONFIG_HOME") or "~/.config")
  local theme_file = config_home .. "/theme/palette.json"
  
  -- Create autocmd to watch for theme file changes
  vim.api.nvim_create_autocmd({"FocusGained", "BufEnter"}, {
    group = vim.api.nvim_create_augroup("ThemeReload", { clear = true }),
    callback = function()
      -- Check if theme file was modified
      local stat = vim.loop.fs_stat(theme_file)
      if stat then
        local last_modified = stat.mtime.sec
        if not M._last_theme_mtime or M._last_theme_mtime < last_modified then
          M._last_theme_mtime = last_modified
          if M._initialized then
            vim.notify("Theme file changed, reloading...", vim.log.levels.INFO)
            palette_loader = nil
            apply_theme()
          else
            M._initialized = true
          end
        end
      end
    end,
  })
  
  -- Keymap to manually reload theme
  vim.keymap.set("n", "<leader>uC", function()
    vim.notify("Reloading theme...", vim.log.levels.INFO)
    palette_loader = nil
    apply_theme()
    vim.notify("Theme reloaded!", vim.log.levels.INFO)
  end, { desc = "Reload colorscheme" })
end

return M