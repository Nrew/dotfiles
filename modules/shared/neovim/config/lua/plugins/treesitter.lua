-- Treesitter Configuration

require('nvim-treesitter.configs').setup({
  ensure_installed = {
    'nix',
    'vim',
    'bash',
    'lua',
    'python',
    'rust',
    'json',
    'javascript',
    'typescript',
    'tsx',
    'html',
    'css',
    'go',
    'yaml',
    'toml',
    'markdown',
    'c',
    'cpp',
  },
  auto_install = true,
  
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
  
  indent = {
    enable = true,
  },
  
  autotag = {
    enable = true,
  },
  
  context_commentstring = {
    enable = true,
    enable_autocmd = false,
  },
  
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "gnn",
      node_incremental = "grn",
      scope_incremental = "grc",
      node_decremental = "grm",
    },
  },
})

-- Treesitter context
require('treesitter-context').setup({
  enable = true,
  max_lines = 0,
  patterns = {
    default = {
      'class',
      'function',
      'method',
      'for',
      'while',
      'if',
      'switch',
      'case',
    },
  },
})
