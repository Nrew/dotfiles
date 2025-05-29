local M = {}

local utils = require("core.utils")

function M.setup()

  local rose_pine_status_ok, rose_pine = utils.safe_require("rose-pine")

  if not rose_pine_status_ok or not rose_pine then
    vim.notify("rose-pine plugin not found, cannot set up theme.", vim.log.levels.ERROR, { title = "Theme Setup" })
    return
  end

  local rose_pine_config = {
    variant = "main", -- Choose from 'main', 'moon', 'dawn'
    dark_variant = "main",
    bold_vert_split = false,
    dim_nc_background = false,
    disable_background = false,
    disable_float_background = false,
    disable_italics = false,

    groups = {
      background = "#191724",
      background_nc = "#191724", 
      panel = "#1f1d2e",
      panel_nc = "#1f1d2e",
      border = "#26233a",
      comment = "#6e6a86",
      link = "#31748f",
      punctuation = "#908caa",

      error = "#eb6f92",
      hint = "#c4a7e7",
      info = "#9ccfd8",
      warn = "#f6c177",

      headings = {
        h1 = "#c4a7e7",
        h2 = "#9ccfd8",
        h3 = "#ebbcba",
        h4 = "#f6c177",
        h5 = "#31748f",
        h6 = "#9ccfd8",
      },
    },

    highlight_groups = { 
      ColorColumn = { bg = "#1f1d2e" },
      CursorLine = { bg = "none" }, -- Or a subtle background like "#232136"
      StatusLine = { fg = "#e0def4", bg = "#1f1d2e" },
      StatusLineNC = { fg = "#6e6a86", bg = "#191724" },

      -- Telescope
      TelescopeBorder = { fg = "#26233a", bg = "#191724" },
      TelescopeNormal = { bg = "#191724" },
      TelescopePromptNormal = { bg = "#1f1d2e" },
      TelescopeResultsNormal = { fg = "#908caa", bg = "#191724" },
      TelescopeSelection = { fg = "#e0def4", bg = "#26233a", bold = true },
      TelescopeResultsDiffAdd = { fg = "#9ccfd8" },
      TelescopeResultsDiffChange = { fg = "#f6c177" },
      TelescopeResultsDiffDelete = { fg = "#eb6f92" },

      -- LSP Diagnostics
      DiagnosticError = { fg = "#eb6f92" },
      DiagnosticWarn = { fg = "#f6c177" },
      DiagnosticInfo = { fg = "#9ccfd8" },
      DiagnosticHint = { fg = "#c4a7e7" },
      DiagnosticVirtualTextError = { fg = "#eb6f92", bg = "#2a273f" },
      DiagnosticVirtualTextWarn = { fg = "#f6c177", bg = "#2a273f" },
      DiagnosticVirtualTextInfo = { fg = "#9ccfd8", bg = "#2a273f" },
      DiagnosticVirtualTextHint = { fg = "#c4a7e7", bg = "#2a273f" },

      -- Floating windows (general)
      NormalFloat = { bg = "#1f1d2e" }, -- Match panel background
      FloatBorder = { fg = "#26233a", bg = "#1f1d2e" },

      -- Which-key
      WhichKeyFloat = { bg = "#1f1d2e" }, -- Match panel background
      WhichKeyBorder = { fg = "#26233a", bg = "#1f1d2e" },
      WhichKeySeparator = { fg = "#31748f" },
      WhichKeyGroup = { fg = "#c4a7e7" },

      -- Add more overrides as needed
      ["@comment.documentation"] = { italic = true },
    },
  }

  local rose_pine_setup_success = utils.safe_call(function()
    rose_pine.setup(rose_pine_config)
    vim.cmd.colorscheme("rose-pine")
  end, "rose-pine theme configuration")

  if not rose_pine_setup_success then
    vim.notify("Failed to configure or apply rose-pine theme.", vim.log.levels.ERROR, { title = "Theme Setup" })
    return
  end

  local custom_highlights = {
    LineNr = { fg = "#575279" },
    LineNrAbove = { fg = "#575279" },
    LineNrBelow = { fg = "#575279" },
    CursorLineNr = { fg = "#e0def4", bold = true },

    Folded = { fg = "#908caa", bg = "#232136" }, -- Slightly different bg for folded text
    FoldColumn = { fg = "#6e6a86", bg = "none" }, -- Use editor background

    IncSearch = { fg = "#191724", bg = "#ebbcba", bold = true }, -- Use a rose-pine accent
    Search = { fg = "#191724", bg = "#f6c177" },               -- Keep this or use another accent

    DiffAdd = { bg = "#283b30" }, -- Darker, less saturated green background
    DiffChange = { bg = "#2a3a42" }, -- Darker, less saturated blue/cyan background
    DiffDelete = { bg = "#422d33" }, -- Darker, less saturated red background
    DiffText = { bg = "#4d4842", fg = "#f6c177", bold = true }, -- Emphasize changed text itself

    -- Example: Subtle visual bell
    VisualBell = { bg = "#31748f" },

    -- Ensure comments are not too dim if `comment` group from rose-pine is too subtle
    -- Comment = { fg = "#74708d", italic = true }, -- Slightly brighter comment
  }

  -- Apply custom highlights safely
  utils.safe_call(function()
    for group, opts in pairs(custom_highlights) do
      vim.api.nvim_set_hl(0, group, opts)
    end
  end, "applying custom highlights")

  vim.notify("Rose-pine theme and custom highlights applied.", vim.log.levels.INFO, { title = "Theme Setup" })
end

return M