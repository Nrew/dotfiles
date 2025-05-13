local M = {}

function M.setup()
  if not nixCats("general") then
    return
  end
  
  require("mini.pairs").setup({
    modes = { insert = true, command = false, terminal = false },
    skip_next = [=[[%w%%%'%[%"%.%`%$]]=],
    skip_ts = { "string" },
    skip_unbalanced = true,
    markdown = true,
  })
end

return M
