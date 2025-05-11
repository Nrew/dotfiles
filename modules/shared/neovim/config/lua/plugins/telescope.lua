-- Telescope Configuration

require('telescope').setup({
  defaults = {
    file_ignore_patterns = { "node_modules", ".git" },
    layout_strategy = 'horizontal',
    layout_config = {
      horizontal = {
        preview_width = 0.6,
        results_width = 0.4,
      },
      vertical = {
        mirror = false,
      },
      width = 0.90,
      height = 0.85,
      preview_cutoff = 120,
    },
    mappings = {
      i = {
        ["<C-n>"] = require('telescope.actions').cycle_history_next,
        ["<C-p>"] = require('telescope.actions').cycle_history_previous,
        ["<C-j>"] = require('telescope.actions').move_selection_next,
        ["<C-k>"] = require('telescope.actions').move_selection_previous,
        ["<C-c>"] = require('telescope.actions').close,
        ["<Down>"] = require('telescope.actions').move_selection_next,
        ["<Up>"] = require('telescope.actions').move_selection_previous,
        ["<CR>"] = require('telescope.actions').select_default,
        ["<C-x>"] = require('telescope.actions').select_horizontal,
        ["<C-v>"] = require('telescope.actions').select_vertical,
        ["<C-t>"] = require('telescope.actions').select_tab,
        ["<C-u>"] = require('telescope.actions').preview_scrolling_up,
        ["<C-d>"] = require('telescope.actions').preview_scrolling_down,
        ["<PageUp>"] = require('telescope.actions').results_scrolling_up,
        ["<PageDown>"] = require('telescope.actions').results_scrolling_down,
      },
    },
  },
  extensions = {
    ["ui-select"] = {
      require("telescope.themes").get_dropdown({})
    },
    fzf = {
      fuzzy = true,
      override_generic_sorter = true,
      override_file_sorter = true,
      case_mode = "smart_case",
    }
  },
})

require('telescope').load_extension('fzf')
require('telescope').load_extension('ui-select')
require('telescope').load_extension('projects')
