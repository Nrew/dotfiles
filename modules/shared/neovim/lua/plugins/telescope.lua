local M = {}

function M.setup()
  local ok, telescope = pcall(require, "telescope")
  if not ok then return end

  local actions = require("telescope.actions")

  pcall(telescope.load_extension, "fzf")

  telescope.setup({
    defaults = {
      prompt_prefix = " ",
      selection_caret = " ",
      path_display = { "truncate" },
      sorting_strategy = "ascending",
      layout_strategy = "horizontal",
      layout_config = {
        horizontal = { prompt_position = "top", preview_width = 0.6 },
        width = 0.9,
        height = 0.8,
      },
      file_ignore_patterns = { "%.git/", "node_modules/", "__pycache__/" },
      sorter = require("telescope.sorters").get_fzf_sorter(),
      mappings = {
        i = {
          ["<esc>"] = actions.close,
          ["<C-j>"] = actions.move_selection_next,
          ["<C-k>"] = actions.move_selection_previous,
          ["<C-q>"] = actions.send_to_qflist, actions.open_qflist,
        },
      },
    },
    pickers = {
      find_files = { theme = "dropdown", previewer = false },
      buffers = { theme = "dropdown", previewer = false },
      live_grep = { theme = "ivy" },
    },
    extensions = {
      fzf = {
        fuzzy = true,
        override_generic_sorter = true,
        override_file_sorter = true,
        case_mode = "smart_case",
      },
    },
  })

  -- Load fzf extension if available
  pcall(telescope.load_extension, "fzf")

  local sorter_ok, sorters = pcall(require, "telescope.sorters")
  if sorter_ok and sorters.get_fzf_sorter then
    telescope_config.defaults.sorter = sorters.get_fzf_sorter()
  else
    vim.notify("Telescope: FZF native sorter not available.", vim.log.level.WARN)
  end

  telescope.setup(telescope_config)
end

return M
