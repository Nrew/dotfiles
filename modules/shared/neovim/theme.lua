-- Theme Configuration
-- Rose Pine theme setup with custom highlights

local M = {}

function M.setup()
  -- Rose Pine configuration
  require("rose-pine").setup({
    variant = "main",
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
      }
    },
    
    highlight_groups = {
      ColorColumn = { bg = "#1f1d2e" },
      CursorLine = { bg = "none" },
      StatusLine = { fg = "#e0def4", bg = "#1f1d2e" },
      
      -- Telescope
      TelescopeBorder = { fg = "#26233a", bg = "#191724" },
      TelescopeNormal = { bg = "#191724" },
      TelescopePromptNormal = { bg = "#1f1d2e" },
      TelescopeResultsNormal = { fg = "#908caa", bg = "#191724" },
      TelescopeSelection = { fg = "#e0def4", bg = "#26233a" },
      TelescopeResultsDiffAdd = { fg = "#9ccfd8" },
      TelescopeResultsDiffChange = { fg = "#f6c177" },
      TelescopeResultsDiffDelete = { fg = "#eb6f92" },
      
      -- LSP
      DiagnosticError = { fg = "#eb6f92" },
      DiagnosticWarn = { fg = "#f6c177" },
      DiagnosticInfo = { fg = "#9ccfd8" },
      DiagnosticHint = { fg = "#c4a7e7" },
      DiagnosticVirtualTextError = { fg = "#eb6f92", bg = "#1f1d2e" },
      DiagnosticVirtualTextWarn = { fg = "#f6c177", bg = "#1f1d2e" },
      DiagnosticVirtualTextInfo = { fg = "#9ccfd8", bg = "#1f1d2e" },
      DiagnosticVirtualTextHint = { fg = "#c4a7e7", bg = "#1f1d2e" },
      
      -- Floating windows
      NormalFloat = { bg = "#191724" },
      FloatBorder = { fg = "#26233a", bg = "#191724" },
      
      -- Which-key
      WhichKeyFloat = { bg = "#191724" },
    }
  })
  
  -- Apply the colorscheme
  vim.cmd.colorscheme("rose-pine")
  
  -- Additional highlight customizations
  local highlight_groups = {
    -- Make line numbers more subtle
    LineNr = { fg = "#6e6a86" },
    LineNrAbove = { fg = "#6e6a86" },
    LineNrBelow = { fg = "#6e6a86" },
    CursorLineNr = { fg = "#e0def4", bold = true },
    
    -- Better fold highlighting
    Folded = { fg = "#908caa", bg = "#26233a" },
    FoldColumn = { fg = "#908caa", bg = "#191724" },
    
    -- Better search highlighting
    IncSearch = { fg = "#191724", bg = "#f6c177" },
    Search = { fg = "#191724", bg = "#f6c177" },
    
    -- Better git diff
    DiffAdd = { bg = "#2d3f2d" },
    DiffChange = { bg = "#2d3d3f" },
    DiffDelete = { bg = "#3f2d2d" },
    DiffText = { bg = "#3d3f2d" },
  }
  
  for group, opts in pairs(highlight_groups) do
    vim.api.nvim_set_hl(0, group, opts)
  end
end

return M