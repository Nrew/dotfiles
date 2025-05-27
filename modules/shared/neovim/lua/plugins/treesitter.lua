local M = {}

-- Helper function to safely check nixCats
local function safe_nixcats(category)
  if type(nixCats) == "function" then
    return nixCats(category)
  end
  return false
end

function M.setup()
  if not safe_nixcats("general") then
    return
  end
  
  require("nvim-treesitter.configs").setup({
    -- NixCats handles parser installation
    highlight = {
      enable = true,
      additional_vim_regex_highlighting = false,
    },
    
    indent = {
      enable = true,
    },
    
    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = "<Leader>v",
        node_incremental = "<Leader>v",
        scope_incremental = false,
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
          ["aa"] = "@parameter.outer",
          ["ia"] = "@parameter.inner",
        },
      },
      move = {
        enable = true,
        set_jumps = true,
        goto_next_start = {
          ["]m"] = "@function.outer",
          ["]]"] = "@class.outer",
        },
        goto_next_end = {
          ["]M"] = "@function.outer",
          ["]["] = "@class.outer",
        },
        goto_previous_start = {
          ["[m"] = "@function.outer",
          ["[["] = "@class.outer",
        },
        goto_previous_end = {
          ["[M"] = "@function.outer",
          ["[]"] = "@class.outer",
        },
      },
    },
  })
  
  -- Configure treesitter context
  require("treesitter-context").setup({
    enable = true,
    max_lines = 0,
    patterns = {
      default = {
        "class",
        "function",
        "method",
        "for",
        "while",
        "if",
        "switch",
        "case",
        "interface",
        "struct",
        "enum",
      },
    },
    zindex = 20,
    mode = "cursor",
    separator = nil,
  })
  
  -- Configure auto tag
  require("nvim-ts-autotag").setup()
end

return M
