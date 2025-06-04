local M = {}

function M.setup()
  local ok, yazi = pcall(require, "yazi")
  if not ok then return end

  yazi.setup({
    open_for_directories = false,
    open_multiple_tabs = false,
    floating_window_scaling_factor = 0.9,
    yazi_floating_window_winblend = 0,
    yazi_floating_window_border = "rounded",
    keymaps = {
      show_help = "<f1>",
      open_file_in_vertical_split = "<c-v>",
      open_file_in_horizontal_split = "<c-x>",
      open_file_in_tab = "<c-t>",
      grep_in_directory = "<c-s>",
      replace_in_directory = "<c-g>",
      cycle_open_buffers = "<tab>",
      copy_relative_path_to_selected_files = "<c-y>",
      send_to_quickfix_list = "<c-q>",
    },
  })

  -- Keymaps
  vim.keymap.set("n", "<leader>-", "<cmd>Yazi<CR>", { desc = "Open yazi at the current file" })
  vim.keymap.set("n", "<leader>cw", "<cmd>Yazi cwd<CR>", { desc = "Open the file manager in nvim's working directory" })
end

return M