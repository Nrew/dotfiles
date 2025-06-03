local utils = require("core.utils")
local M = {}

function M.load()
  return {
    event = "DeferredUIEnter"
  }
end

function M.setup()
  local persistence = utils.safe_require("persistence")
  if not persistence then return end

  utils.safe_call(function()
    persistence.setup({
      dir = vim.fn.stdpath("state") .. "/sessions/",
      options = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp" },
      pre_save = nil,
      save_empty = false,
    })

    utils.keymap("n", "<leader>qs", function() persistence.load() end, { desc = "Restore Session" })
    utils.keymap("n", "<leader>ql", function() persistence.load({ last = true }) end, { desc = "Restore Last Session" })
    utils.keymap("n", "<leader>qd", function() persistence.stop() end, { desc = "Don't Save Current Session" })
  end, "persistence setup")
end

return M
