local M = {}

function M.setup()
  local ok, persistence = pcall(require, "persistence")
  if not ok then return end

  persistence.setup({
    dir = vim.fn.stdpath("state") .. "/sessions/",
    options = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp" },
    pre_save = nil,
    save_empty = false,
  })

  -- Keymaps
  vim.keymap.set("n", "<leader>qs", function() persistence.load() end, { desc = "Restore Session" })
  vim.keymap.set("n", "<leader>ql", function() persistence.load({ last = true }) end, { desc = "Restore Last Session" })
  vim.keymap.set("n", "<leader>qd", function() persistence.stop() end, { desc = "Don't Save Current Session" })
end

return M