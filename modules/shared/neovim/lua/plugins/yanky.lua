local utils = require("core.utils")
local M = {}

function M.load()
  return {
    event = "DeferredUIEnter"
  }
end

function M.setup()
  local yanky = utils.safe_require("yanky")
  if not yanky then return end

  utils.safe_call(function()
    yanky.setup({
      ring = { history_length = 100, storage = "shada", sync_with_numbered_registers = true, cancel_event = "update" },
      picker = { select = { action = nil }, telescope = { use_default_mappings = true } },
      system_clipboard = { sync_with_ring = true },
      highlight = { on_put = true, on_yank = true, timer = 500 },
      preserve_cursor_position = { enabled = true },
    })

    utils.keymap({ "n", "x" }, "p", "<Plug>(YankyPutAfter)", { desc = "Put after" })
    utils.keymap({ "n", "x" }, "P", "<Plug>(YankyPutBefore)", { desc = "Put before" })
    utils.keymap({ "n", "x" }, "gp", "<Plug>(YankyGPutAfter)", { desc = "G put after" })
    utils.keymap({ "n", "x" }, "gP", "<Plug>(YankyGPutBefore)", { desc = "G put before" })
    utils.keymap("n", "<c-p>", "<Plug>(YankyPreviousEntry)", { desc = "Previous yank" })
    utils.keymap("n", "<c-n>", "<Plug>(YankyNextEntry)", { desc = "Next yank" })
    utils.keymap("n", "]p", "<Plug>(YankyPutIndentAfterLinewise)", { desc = "Put indent after" })
    utils.keymap("n", "[p", "<Plug>(YankyPutIndentBeforeLinewise)", { desc = "Put indent before" })
  end, "yanky setup")
end

return M
