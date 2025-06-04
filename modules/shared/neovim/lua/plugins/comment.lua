local M = {}

function M.setup()
  local ok, comment = pcall(require, "Comment")
  if not ok then return end

  comment.setup({
    padding = true,
    sticky = true,
    ignore = "^$",
    toggler = { 
      line = "gcc", 
      block = "gbc" 
    },
    opleader = { 
      line = "gc", 
      block = "gb" 
    },
    extra = { 
      above = "gcO", 
      below = "gco", 
      eol = "gcA" 
    },
    mappings = { 
      basic = true, 
      extra = true 
    },
    pre_hook = nil,
    post_hook = nil,
  })
end

return M