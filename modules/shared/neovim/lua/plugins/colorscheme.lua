local M = {}

function M.setup()
  if not nixCats("general") then
    return
  end
  
  -- Configure rose-pine theme
  require("rose-pine").setup({
    variant = "auto",
    dark_variant = "moon",
    bold_vert_split = false,
    dim_nc_background = false,
    disable_background = false,
    disable_float_background = false,
    disable_italics = false,
    
    groups = {
      background = "base",
      background_nc = "_experimental_nc",
      panel = "surface",
      panel_nc = "base",
      border = "highlight_med",
      comment = "muted",
      link = "iris",
      punctuation = "subtle",
      
      error = "love",
      hint = "iris",
      info = "foam",
      warn = "gold",
      
      headings = {
        h1 = "iris",
        h2 = "foam",
        h3 = "rose",
        h4 = "gold",
        h5 = "pine",
        h6 = "foam",
      },
    },
    
    highlight_groups = {
      Normal = { bg = "none" },
      NormalFloat = { bg = "surface" },
      FloatBorder = { fg = "highlight_med", bg = "none" },
      ColorColumn = { bg = "rose" },
      CursorLine = { bg = "overlay" },
      TelescopeNormal = { bg = "none" },
      TelescopeBorder = { fg = "highlight_med" },
      
      -- LSP diagnostics
      DiagnosticError = { fg = "love" },
      DiagnosticWarn = { fg = "gold" },
      DiagnosticInfo = { fg = "foam" },
      DiagnosticHint = { fg = "iris" },
    },
  })
  
  -- Apply colorscheme
  vim.cmd.colorscheme("rose-pine")
end

return M
