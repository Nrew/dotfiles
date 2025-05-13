local M = {}

function M.setup()
  if not nixCats("general") then
    return
  end
  
  require("bufferline").setup({
    options = {
      mode = "buffers",
      style_preset = "minimal",
      themable = true,
      numbers = "none",
      indicator = {
        icon = "▎",
        style = "icon",
      },
      buffer_close_icon = "󰅘",
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
      diagnostics_indicator = function(count, level, diagnostics_dict, context)
        local icon = level:match("error") and " " or " "
        return " " .. icon .. count
      end,
      offsets = {
        {
          filetype = "neo-tree",
          text = "Neo-tree",
          text_align = "left",
          separator = true,
        },
      },
      color_icons = true,
      show_buffer_icons = true,
      show_buffer_close_icons = true,
      show_buffer_default_icon = true,
      show_close_icon = true,
      show_tab_indicators = true,
      show_duplicate_prefix = true,
      persist_buffer_sort = true,
      move_wraps_at_ends = false,
      separator_style = "slant",
      enforce_regular_tabs = true,
      always_show_bufferline = false,
      hover = {
        enabled = true,
        delay = 200,
        reveal = { "close" },
      },
      sort_by = "insert_at_end",
    },
  })
  
  -- Buffer navigation keymaps
  vim.keymap.set("n", "<S-l>", ":BufferLineCycleNext<CR>", 
    { desc = "Next buffer" })
  vim.keymap.set("n", "<S-h>", ":BufferLineCyclePrev<CR>", 
    { desc = "Previous buffer" })
  vim.keymap.set("n", "<leader>bc", ":BufferLineTogglePin<CR>", 
    { desc = "Pin buffer" })
  vim.keymap.set("n", "<leader>bd", ":bdelete<CR>", 
    { desc = "Delete buffer" })
  vim.keymap.set("n", "<leader>bD", ":BufferLineCloseOthers<CR>", 
    { desc = "Delete other buffers" })
end

return M
