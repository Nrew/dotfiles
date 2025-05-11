-- Initialize plugins and set up theme

-- Rose Pine Theme Setup
require('rose-pine').setup({
  variant = 'main',
  dark_variant = 'main',
  bold_vert_split = false,
  dim_nc_background = false,
  disable_background = false,
  disable_float_background = false,
  disable_italics = false,
  
  groups = {
    background = '#191724',
    background_nc = '#191724',
    panel = '#1f1d2e',
    panel_nc = '#1f1d2e',
    border = '#26233a',
    comment = '#6e6a86',
    link = '#31748f',
    punctuation = '#908caa',
    
    error = '#eb6f92',
    hint = '#c4a7e7',
    info = '#9ccfd8',
    warn = '#f6c177',
    
    headings = {
      h1 = '#c4a7e7',
      h2 = '#9ccfd8',
      h3 = '#ebbcba',
      h4 = '#f6c177',
      h5 = '#31748f',
      h6 = '#9ccfd8',
    }
  },
  
  highlight_groups = {
    ColorColumn = { bg = '#1f1d2e' },
    CursorLine = { bg = 'none' },
    StatusLine = { fg = '#e0def4', bg = '#1f1d2e' },
    
    TelescopeBorder = { fg = '#26233a', bg = '#191724' },
    TelescopeNormal = { bg = '#191724' },
    TelescopePromptNormal = { bg = '#1f1d2e' },
    TelescopeResultsNormal = { fg = '#908caa', bg = '#191724' },
    TelescopeSelection = { fg = '#e0def4', bg = '#26233a' },
    TelescopeResultsDiffAdd = { fg = '#9ccfd8' },
    TelescopeResultsDiffChange = { fg = '#f6c177' },
    TelescopeResultsDiffDelete = { fg = '#eb6f92' },
  }
})

vim.cmd('colorscheme rose-pine')

-- Plugin configurations
require('plugins.treesitter')
require('plugins.telescope')
require('plugins.which-key')
require('plugins.neo-tree')
require('plugins.bufferline')
require('plugins.lualine')
require('plugins.indent-blankline')
require('plugins.trouble')
require('plugins.dressing')
require('plugins.project')
require('plugins.copilot')
require('plugins.yanky')
require('plugins.flash')
require('plugins.other')
