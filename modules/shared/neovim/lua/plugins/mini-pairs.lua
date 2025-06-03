local utils = require("core.utils")
local M = {}

function M.load()
  return {
    event = "InsertEnter",
  }
end

function M.setup()
  local mini_pairs = utils.safe_require("mini.pairs")
  if not mini_pairs then return end

  utils.safe_call(function()
    mini_pairs.setup({
      modes = { insert = true, command = false, terminal = false },
      skip_next = [=[[%w%%%'%[%"%.%`%$]]=],
      skip_ts = { "string" },
      skip_unbalanced = true,
      markdown = true,
    })
  end, "mini.pairs setup")
end

return M
