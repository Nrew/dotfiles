local M = {}

function M.setup()
  if not nixCats("general") then
    return
  end
  
  -- Rose Pine configuration
  require("rose-pine").setup({
    variant = "auto", -- auto, main, moon, or dawn
    dark_variant = "main", -- main, moon, or dawn
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
      }
    },
    
    highlight_groups = {
      -- Transparency
      Normal = { bg = "none" },
      NormalFloat = { bg = "none" },
      NormalNC = { bg = "none" },
      CursorLine = { bg = "foam", blend = 10 },
      CursorLineNr = { fg = "iris" },
      LineNr = { fg = "muted" },
      
      -- Better visual selection
      Visual = { bg = "highlight_high" },
      
      -- Improved diff colors
      DiffAdd = { bg = "pine", blend = 20 },
      DiffChange = { bg = "foam", blend = 20 },
      DiffDelete = { bg = "love", blend = 20 },
      DiffText = { bg = "gold", blend = 20 },
      
      -- Better telescope colors
      TelescopeBorder = { fg = "highlight_high", bg = "none" },
      TelescopeNormal = { bg = "none" },
      TelescopePromptNormal = { bg = "base" },
      TelescopeResultsNormal = { fg = "subtle", bg = "none" },
      TelescopeSelection = { fg = "text", bg = "base" },
      TelescopeSelectionCaret = { fg = "rose" },
      
      -- Which-key
      WhichKey = { fg = "iris" },
      WhichKeyGroup = { fg = "foam" },
      WhichKeyDesc = { fg = "gold" },
      WhichKeySeperator = { fg = "subtle" },
      WhichKeySeparator = { fg = "subtle" },
      WhichKeyFloat = { bg = "surface" },
      WhichKeyValue = { fg = "rose" },
      
      -- Neo-tree
      NeoTreeNormal = { fg = "text", bg = "none" },
      NeoTreeNormalNC = { fg = "text", bg = "none" },
      
      -- StatusLine
      StatusLine = { fg = "subtle", bg = "surface" },
      StatusLineNC = { fg = "muted", bg = "surface" },
      
      -- Completion menu
      Pmenu = { fg = "subtle", bg = "surface" },
      PmenuSel = { fg = "text", bg = "overlay" },
      PmenuSbar = { bg = "highlight_low" },
      PmenuThumb = { bg = "highlight_med" },
      
      -- Diagnostic colors
      DiagnosticError = { fg = "love" },
      DiagnosticWarn = { fg = "gold" },
      DiagnosticInfo = { fg = "foam" },
      DiagnosticHint = { fg = "iris" },
      
      -- Git signs
      GitSignsAdd = { fg = "pine" },
      GitSignsChange = { fg = "foam" },
      GitSignsDelete = { fg = "love" },
    },
  })
  
  -- Apply colorscheme
  vim.cmd("colorscheme rose-pine")
  
  -- Additional highlight tweaks
  vim.defer_fn(function()
    -- Ensure transparency works correctly
    vim.cmd([[
      highlight Normal guibg=NONE ctermbg=NONE
      highlight NonText guibg=NONE ctermbg=NONE
      highlight SignColumn guibg=NONE ctermbg=NONE
      highlight EndOfBuffer guibg=NONE ctermbg=NONE
    ]])
  end, 100)
end

return M
