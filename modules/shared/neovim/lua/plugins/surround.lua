local utils = require("core.utils")
local M = {}

function M.setup()
  local surround = utils.safe_require("nvim-surround")
  if not surround then return end

  utils.safe_call(function()
    surround.setup({
      keymaps = {
        insert = "<C-g>s",
        insert_line = "<C-g>S",
        normal = "ys",
        normal_cur = "yss",
        normal_line = "yS",
        normal_cur_line = "ySS",
        visual = "S",
        visual_line = "gS",
        delete = "ds",
        change = "cs",
        change_line = "cS",
      },
      aliases = {
        ["a"] = ">",
        ["b"] = ")",
        ["B"] = "}",
        ["r"] = "]",
        ["q"] = { '"', "'", "`" },
        ["s"] = { "}", "]", ")", ">", '"', "'", "`" },
      },
      highlight = { duration = 0 },
      move_cursor = "begin",
      indent_lines = function(start, stop) return start == stop end,
    })
  end, "nvim-surround setup")
end

return M