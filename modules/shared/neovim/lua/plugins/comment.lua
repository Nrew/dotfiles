local utils = require("core.utils")
local M = {}

function M.load()
  return {
    keys = { 
      { "gc", mode = { "n", "v" }, desc = "Toggle comment" },
      { "gb", mode = { "n", "v" }, desc = "Toggle block comment" },
    },
  }
end

function M.setup()
  local comment = utils.safe_require("Comment")
  if not comment then return end

  utils.safe_call(function()
    comment.setup({
      padding = true,
      sticky = true,
      ignore = "^$",
      toggler = { line = "gcc", block = "gbc" },
      opleader = { line = "gc", block = "gb" },
      extra = { above = "gcO", below = "gco", eol = "gcA" },
      mappings = { basic = true, extra = true },
      pre_hook = nil,
      post_hook = nil,
    })
  end, "comment setup")
end

return M
