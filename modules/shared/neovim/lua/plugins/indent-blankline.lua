local utils = require("core.utils")
local M = {}

function M.setup()
  local indent_blankline = utils.safe_require("ibl")
  if not indent_blankline then return end

  utils.safe_call(function()
    indent_blankline.setup({
      indent = { char = "│", tab_char = "│" },
      whitespace = { highlight = { "Whitespace", "NonText" } },
      scope = { enabled = true, show_start = true, show_end = false },
      exclude = {
        filetypes = {
          "help", "alpha", "dashboard", "neo-tree", "Trouble", "trouble",
          "lazy", "mason", "notify", "toggleterm", "lazyterm",
        },
        buftypes = { "terminal", "nofile" },
      },
    })
  end, "indent-blankline setup")
end

return M