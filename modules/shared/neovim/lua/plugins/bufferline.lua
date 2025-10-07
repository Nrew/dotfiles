local M = {}

function M.setup()
  local ok, bufferline = pcall(require, "bufferline")
  if not ok then return end

  -- Load dynamic palette
  local palette_ok, palette_loader = pcall(require, "theme.palette")
  local palette = palette_ok and palette_loader.get() or {
    base = "#191724",
    mantle = "#1f1d2e",
    surface = "#26233a",
    overlay = "#403d52",
    text = "#e0def4",
    subtext0 = "#908caa",
    muted = "#6e6a86",
    primary = "#c4a7e7",
  }

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
      fill = { bg = palette.base },
      background = { fg = palette.muted, bg = palette.mantle },
      buffer_visible = { fg = palette.subtext0, bg = palette.mantle },
      buffer_selected = { fg = palette.text, bg = palette.surface, bold = true },
      indicator_selected = { fg = palette.primary, bg = palette.surface },
      separator = { fg = palette.base, bg = palette.mantle },
      separator_selected = { fg = palette.base, bg = palette.surface },
      separator_visible = { fg = palette.base, bg = palette.mantle },
      modified = { fg = palette.primary, bg = palette.mantle },
      modified_selected = { fg = palette.primary, bg = palette.surface },
      modified_visible = { fg = palette.primary, bg = palette.mantle },
      close_button = { fg = palette.muted, bg = palette.mantle },
      close_button_selected = { fg = palette.text, bg = palette.surface },
      close_button_visible = { fg = palette.subtext0, bg = palette.mantle },
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