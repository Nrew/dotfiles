local M = {}

function M.setup()
  local ok, surround = pcall(require, "nvim-surround")
  if not ok then return end

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
    indent_lines = function(start, stop) 
      return start == stop 
    end,
  })
end

return M