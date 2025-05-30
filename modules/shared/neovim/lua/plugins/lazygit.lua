local utils = require("core.utils")
local M = {}

function M.setup()
  local lazygit = utils.safe_require("lazygit")
  if not lazygit then return end

  utils.safe_call(function()
    utils.keymap("n", "<leader>gg", "<cmd>LazyGit<cr>", { desc = "LazyGit" })
  end, "lazygit setup")
end

return M