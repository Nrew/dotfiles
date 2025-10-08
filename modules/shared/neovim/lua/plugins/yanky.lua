local M = {}

function M.setup()
  local ok, yanky = pcall(require, "yanky")
  if not ok then return end

  yanky.setup({
    ring = {
      history_length = 100, 
      storage = "shada", 
      sync_with_numbered_registers = true, 
      cancel_event = "update" 
    },
    picker = { 
      select = { action = nil }, 
      telescope = { use_default_mappings = true } 
    },
    system_clipboard = { sync_with_ring = true },
    highlight = { on_put = true, on_yank = true, timer = 500 },
    preserve_cursor_position = { enabled = true },
  })

  -- Keymaps
  vim.keymap.set({ "n", "x" }, "p", "<Plug>(YankyPutAfter)", { desc = "Put after" })
  vim.keymap.set({ "n", "x" }, "P", "<Plug>(YankyPutBefore)", { desc = "Put before" })
  vim.keymap.set({ "n", "x" }, "gp", "<Plug>(YankyGPutAfter)", { desc = "G put after" })
  vim.keymap.set({ "n", "x" }, "gP", "<Plug>(YankyGPutBefore)", { desc = "G put before" })
  vim.keymap.set("n", "<c-p>", "<Plug>(YankyPreviousEntry)", { desc = "Previous yank" })
  vim.keymap.set("n", "<c-n>", "<Plug>(YankyNextEntry)", { desc = "Next yank" })
  vim.keymap.set("n", "]p", "<Plug>(YankyPutIndentAfterLinewise)", { desc = "Put indent after" })
  vim.keymap.set("n", "[p", "<Plug>(YankyPutIndentBeforeLinewise)", { desc = "Put indent before" })

  vim.keymap.set("n", "<leader>py", function()
    require("telescope").extensions.yanky_history.yanky_history({})
  end, { desc = "Yank History" })
end

return M