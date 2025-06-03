local utils = require("core.utils")
local M = {}

function M.load()
  return {
    keys = {
      { "s", mode = { "n", "x", "o" }, desc = "Flash" },
      { "S", mode = { "n", "x", "o" }, desc = "Flash Treesitter" },
      { "r", mode = "o",               desc = "Remote Flash" },
      { "R", mode = { "o", "x" },      desc = "Treesitter Search" },
      { "<c-s>", mode = "c"            desc = "Toggle Flash Search" },
    }
  }
end

function M.setup()
  local flash = utils.safe_require("flash")
  if not flash then return end

  utils.safe_call(function()
    flash.setup({
      labels = "asdfghjklqwertyuiopzxcvbnm",
      search = { multi_window = true, forward = true, wrap = true },
      jump = { jumplist = true, pos = "start", history = false, register = false },
      label = { uppercase = true, exclude = "", current = true, after = true, before = false },
      highlight = { backdrop = true, matches = true, priority = 5000, groups = {} },
      action = nil,
      pattern = "",
      continue = false,
      config = nil,
      prompt = { enabled = true, prefix = { { "⚡", "FlashPromptIcon" } } },
      remote_op = { restore = true, motion = true },
    })

    utils.keymap({ "n", "x", "o" }, "s", function() flash.jump() end, { desc = "Flash" })
    utils.keymap({ "n", "x", "o" }, "S", function() flash.treesitter() end, { desc = "Flash Treesitter" })
    utils.keymap("o", "r", function() flash.remote() end, { desc = "Remote Flash" })
    utils.keymap("c", "<c-s>", function() flash.toggle() end, { desc = "Toggle Flash Search" })
  end, "flash setup")
end

return M
