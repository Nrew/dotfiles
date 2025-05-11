-- Bufferline Configuration

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
