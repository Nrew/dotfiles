-- Yanky Configuration

require('yanky').setup({
  ring = {
    history_length = 100,
    storage = "shada",
    sync_with_numbered_registers = true,
    cancel_event = "update",
  },
  picker = {
    select = {
      action = nil,
    },
    telescope = {
      mappings = nil,
    },
  },
  system_clipboard = {
    sync_with_ring = true,
  },
  highlight = {
    on_put = true,
    on_yank = true,
    timer = 500,
  },
  preserve_cursor_position = {
    enabled = true,
  },
})

-- Keymaps
local keymap = vim.keymap.set
keymap({"n","x"}, "p", "<Plug>(YankyPutAfter)")
keymap({"n","x"}, "P", "<Plug>(YankyPutBefore)")
keymap({"n","x"}, "gp", "<Plug>(YankyGPutAfter)")
keymap({"n","x"}, "gP", "<Plug>(YankyGPutBefore)")

keymap("n", "<c-p>", "<Plug>(YankyPreviousEntry)")
keymap("n", "<c-n>", "<Plug>(YankyNextEntry)")

keymap("n", "]p", "<Plug>(YankyPutIndentAfterLinewise)")
keymap("n", "[p", "<Plug>(YankyPutIndentBeforeLinewise)")
keymap("n", "]P", "<Plug>(YankyPutIndentAfterLinewise)")
keymap("n", "[P", "<Plug>(YankyPutIndentBeforeLinewise)")

keymap("n", ">p", "<Plug>(YankyPutIndentAfterShiftRight)")
keymap("n", "<p", "<Plug>(YankyPutIndentAfterShiftLeft)")
keymap("n", ">P", "<Plug>(YankyPutIndentBeforeShiftRight)")
keymap("n", "<P", "<Plug>(YankyPutIndentBeforeShiftLeft)")

keymap("n", "=p", "<Plug>(YankyPutAfterFilter)")
keymap("n", "=P", "<Plug>(YankyPutBeforeFilter)")
