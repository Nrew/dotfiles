local M = {}

function M.setup()
  if not nixCats("general") then
    return
  end
  
  require("nvim-surround").setup({
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
    highlight = {
      duration = 0,
    },
    move_cursor = "begin",
    indent_lines = function(start, stop)
      local function_node = require("surround.buffer").get_selection({ start, stop })
      local indents = function_node and function_node.type == "function_definition"
      return indents
    end,
  })
end

return M
