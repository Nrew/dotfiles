local utils = require("core.utils")
local M = {}

function M.setup()
  local configs = utils.safe_require("nvim-treesitter.configs")
  if not configs then return end

  utils.safe_call(function()
    configs.setup({
      highlight = { enable = true, additional_vim_regex_highlighting = false },
      indent = { enable = true },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<Leader>v",
          node_incremental = "<Leader>v",
          node_decremental = "<BS>",
        },
      },
      textobjects = {
        select = {
          enable = true,
          lookahead = true,
          keymaps = {
            ["af"] = "@function.outer",
            ["if"] = "@function.inner",
            ["ac"] = "@class.outer",
            ["ic"] = "@class.inner",
          },
        },
        move = {
          enable = true,
          set_jumps = true,
          goto_next_start = { ["]m"] = "@function.outer", ["]]"] = "@class.outer" },
          goto_previous_start = { ["[m"] = "@function.outer", ["[["] = "@class.outer" },
        },
      },
    })
  end, "treesitter configs")

  local context = utils.safe_require("treesitter-context")
  if context then
    utils.safe_call(function()
      context.setup({
        enable = true,
        max_lines = 4,
        patterns = { default = { "class", "function", "method", "for", "while", "if" } },
      })
    end, "treesitter context")
  end

  local autotag = utils.safe_require("nvim-ts-autotag")
  if autotag then
    utils.safe_call(autotag.setup, "treesitter autotag")
  end
end

return M
