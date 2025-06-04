local M = {}

function M.setup()
  local ok, mini_pairs = pcall(require, "mini.pairs")
  if not ok then return end

  mini_pairs.setup({
    modes = { 
      insert = true, 
      command = false, 
      terminal = false 
    },
    skip_next = [=[[%w%%%'%[%"%.%`%$]]=],
    skip_ts = { "string" },
    skip_unbalanced = true,
    markdown = true,
  })
end

return M