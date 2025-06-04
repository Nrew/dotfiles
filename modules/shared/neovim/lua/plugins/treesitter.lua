local M = {}

function M.setup()
  local ok, configs = pcall(require, "nvim-treesitter.configs")
  if not ok then return end

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

  -- Setup context if available
  local context_ok, context = pcall(require, "treesitter-context")
  if context_ok then
    context.setup({
      enable = true,
      max_lines = 4,
      patterns = { default = { "class", "function", "method", "for", "while", "if" } },
    })
  end

  -- Setup autotag if available
  local autotag_ok, autotag = pcall(require, "nvim-ts-autotag")
  if autotag_ok then
    autotag.setup()
  end
end

return M