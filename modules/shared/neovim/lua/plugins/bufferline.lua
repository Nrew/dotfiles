local M = {}

function M.setup()
  local ok, bufferline = pcall(require, "bufferline")
  if not ok then return end

  bufferline.setup({
    options = {
      mode = "buffers",
      style_preset = bufferline.style_preset.default,
      themable = true,
      numbers = "none",
      close_command = "bdelete! %d",
      right_mouse_command = "bdelete! %d",
      left_mouse_command = "buffer %d",
      indicator = { icon = "▎", style = "icon" },
      buffer_close_icon = "󰅖",
      modified_icon = "●",
      close_icon = "",
      left_trunc_marker = "",
      right_trunc_marker = "",
      max_name_length = 30,
      max_prefix_length = 30,
      truncate_names = true,
      tab_size = 21,
      diagnostics = "nvim_lsp",
      diagnostics_update_in_insert = false,
      color_icons = true,
      show_buffer_icons = true,
      show_buffer_close_icons = true,
      show_close_icon = true,
      show_tab_indicators = true,
      show_duplicate_prefix = true,
      separator_style = "slant",
      always_show_bufferline = true,
      hover = { enabled = true, delay = 200, reveal = { "close" } },
      sort_by = "insert_after_current",
    },
    highlights = {
      separator = { fg = "#073642", bg = "#002b36" },
      separator_selected = { fg = "#073642" },
      background = { fg = "#657b83", bg = "#002b36" },
      buffer_selected = { fg = "#fdf6e3", bold = true },
      fill = { bg = "#073642" },
    },
  })

  -- Keymaps
  vim.keymap.set("n", "<S-h>", "<cmd>BufferLineCyclePrev<cr>", { desc = "Prev buffer" })
  vim.keymap.set("n", "<S-l>", "<cmd>BufferLineCycleNext<cr>", { desc = "Next buffer" })
  vim.keymap.set("n", "[b", "<cmd>BufferLineCyclePrev<cr>", { desc = "Prev buffer" })
  vim.keymap.set("n", "]b", "<cmd>BufferLineCycleNext<cr>", { desc = "Next buffer" })
  vim.keymap.set("n", "<leader>bl", "<cmd>BufferLineCloseLeft<cr>", { desc = "Close buffers to left" })
  vim.keymap.set("n", "<leader>br", "<cmd>BufferLineCloseRight<cr>", { desc = "Close buffers to right" })
  vim.keymap.set("n", "<leader>bo", "<cmd>BufferLineCloseOthers<cr>", { desc = "Close other buffers" })
  vim.keymap.set("n", "<leader>bp", "<cmd>BufferLineTogglePin<cr>", { desc = "Toggle pin" })
end

return M