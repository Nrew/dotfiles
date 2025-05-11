-- UI Plugin Configurations

-- Lualine
require('lualine').setup({
  options = {
    theme = 'rose-pine',
    component_separators = { left = '', right = ''},
    section_separators = { left = '', right = ''},
    disabled_filetypes = {
      statusline = {},
      winbar = {},
    },
    ignore_focus = {},
    always_divide_middle = true,
    globalstatus = true,
    refresh = {
      statusline = 1000,
      tabline = 1000,
      winbar = 1000,
    }
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {'branch', 'diff', 'diagnostics'},
    lualine_c = {'filename'},
    lualine_x = {'encoding', 'fileformat', 'filetype'},
    lualine_y = {'progress'},
    lualine_z = {'location'}
  },
})

-- Bufferline
require('bufferline').setup({
  options = {
    mode = "buffers",
    numbers = "none",
    close_command = "bdelete! %d",
    right_mouse_command = "bdelete! %d",
    left_mouse_command = "buffer %d",
    middle_mouse_command = nil,
    indicator = {
      icon = '▎',
      style = 'icon',
    },
    buffer_close_icon = '󰅖',
    modified_icon = '●',
    close_icon = '',
    left_trunc_marker = '',
    right_trunc_marker = '',
    max_name_length = 18,
    max_prefix_length = 15,
    tab_size = 18,
    diagnostics = "nvim_lsp",
    diagnostics_update_in_insert = false,
    color_icons = true,
    show_buffer_icons = true,
    show_buffer_close_icons = true,
    show_close_icon = true,
    show_tab_indicators = true,
    persist_buffer_sort = true,
    separator_style = "slant",
    enforce_regular_tabs = false,
    always_show_bufferline = true,
    sort_by = 'insert_after_current',
  },
  highlights = {
    fill = {
      fg = '#908caa',
      bg = '#1f1d2e',
    },
    background = {
      fg = '#908caa',
      bg = '#1f1d2e',
    },
    buffer_selected = {
      fg = '#e0def4',
      bg = '#191724',
      bold = true,
      italic = false,
    },
    buffer_visible = {
      fg = '#908caa',
      bg = '#1f1d2e',
    },
    close_button = {
      fg = '#908caa',
      bg = '#1f1d2e',
    },
    close_button_visible = {
      fg = '#908caa',
      bg = '#1f1d2e',
    },
    close_button_selected = {
      fg = '#eb6f92',
      bg = '#191724',
    },
    tab_selected = {
      fg = '#e0def4',
      bg = '#191724',
    },
    tab = {
      fg = '#908caa',
      bg = '#1f1d2e',
    },
    tab_close = {
      fg = '#eb6f92',
      bg = '#1f1d2e',
    },
    duplicate_selected = {
      fg = '#e0def4',
      bg = '#191724',
      italic = false,
    },
    duplicate_visible = {
      fg = '#908caa',
      bg = '#1f1d2e',
      italic = false,
    },
    duplicate = {
      fg = '#908caa',
      bg = '#1f1d2e',
      italic = false,
    },
    modified_selected = {
      fg = '#9ccfd8',
      bg = '#191724',
    },
    modified_visible = {
      fg = '#9ccfd8',
      bg = '#1f1d2e',
    },
    modified = {
      fg = '#9ccfd8',
      bg = '#1f1d2e',
    },
    separator_selected = {
      fg = '#191724',
      bg = '#191724',
    },
    separator_visible = {
      fg = '#1f1d2e',
      bg = '#1f1d2e',
    },
    separator = {
      fg = '#1f1d2e',
      bg = '#1f1d2e',
    },
    indicator_selected = {
      fg = '#c4a7e7',
      bg = '#191724',
    },
  },
})

-- Indent blank line
require("ibl").setup {
  enabled = true,
  debounce = 100,
  indent = {
    char = "┊",
    tab_char = nil,
    highlight = "IblIndent",
    smart_indent_cap = true,
    priority = 1,
  },
  whitespace = {
    highlight = "IblWhitespace",
    remove_blankline_trail = true,
  },
  scope = {
    enabled = true,
    char = nil,
    show_start = true,
    show_end = false,
    injected_languages = true,
    highlight = "IblScope",
    priority = 500,
    include = {
      node_type = {},
    },
    exclude = {
      language = {},
      node_type = {
        "comment",
        "directive",
        "type",
        "constant",
      },
    },
  },
  exclude = {
    filetypes = {
      "alpha",
      "dashboard",
      "neo-tree",
      "Trouble",
      "help",
      "lazy",
      "list",
      "mason",
      "notify",
      "text",
    },
    buftypes = {
      "terminal",
      "nofile",
      "quickfix",
      "prompt",
    },
  },
}

-- Dressing (better UI inputs)
require('dressing').setup({
  input = {
    enabled = true,
    default_prompt = "Input:",
    prompt_align = "left",
    insert_only = true,
    start_in_insert = true,
    anchor = "SW",
    border = "rounded",
    relative = "cursor",
    prefer_width = 40,
    width = nil,
    max_width = { 140, 0.9 },
    min_width = { 20, 0.2 },
    buf_options = {},
    win_options = {
      winblend = 10,
      wrap = false,
    },
    mappings = {
      n = {
        ["<Esc>"] = "Close",
        ["<CR>"] = "Confirm",
      },
      i = {
        ["<C-c>"] = "Close",
        ["<CR>"] = "Confirm",
        ["<Up>"] = "HistoryPrev",
        ["<Down>"] = "HistoryNext",
      },
    },
    override = function(conf)
      return conf
    end,
    get_config = nil,
  },
  select = {
    enabled = true,
    backend = { "telescope", "fzf_lua", "fzf", "builtin", "nui" },
    trim_prompt = true,
    telescope = nil,
    fzf = {
      window = {
        width = 0.5,
        height = 0.4,
      },
    },
    fzf_lua = {},
    nui = {
      position = "50%",
      size = nil,
      relative = "editor",
      border = {
        style = "rounded",
      },
      buf_options = {
        swapfile = false,
        filetype = "DressingSelect",
      },
      win_options = {
        winblend = 10,
      },
      max_width = 80,
      max_height = 40,
      min_width = 40,
      min_height = 10,
    },
    builtin = {
      anchor = "NW",
      border = "rounded",
      relative = "editor",
      buf_options = {},
      win_options = {
        winblend = 10,
      },
      width = nil,
      max_width = { 140, 0.8 },
      min_width = { 40, 0.2 },
      height = nil,
      max_height = 0.9,
      min_height = { 10, 0.2 },
      mappings = {
        ["<Esc>"] = "Close",
        ["<C-c>"] = "Close",
        ["<CR>"] = "Confirm",
      },
      override = function(conf)
        return conf
      end,
    },
    format_item_override = {},
    get_config = nil,
  },
})
