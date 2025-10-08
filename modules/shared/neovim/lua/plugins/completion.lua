local M = {}

function M.setup()
  local ok, blink = pcall(require, "blink.cmp")
  if not ok then 
    vim.notify("blink.cmp not found", vim.log.levels.ERROR)
    return 
  end

  blink.setup({
    keymap = { preset = "super-tab" },
    appearance = { 
      nerd_font_variant = "mono",
      kind_icons = {
        Text = '󰉿',
        Method = '󰊕',
        Function = '󰊕',
        Constructor = '󰒓',
        Field = '󰜢',
        Variable = '󰆦',
        Class = '󱡠',
        Interface = '󱡠',
        Module = '󰅩',
        Property = '󰖷',
        Unit = '󰪚',
        Value = '󰦨',
        Enum = '󰦨',
        Keyword = '󰻾',
        Snippet = '󱄽',
        Color = '󰏘',
        File = '󰈔',
        Reference = '󰬲',
        Folder = '󰉋',
        EnumMember = '󰦨',
        Constant = '󰏿',
        Struct = '󱡠',
        Event = '󱐋',
        Operator = '󰪚',
        TypeParameter = '󰬛',
      },
    },

    sources = {
      default = { "lsp", "path", "snippets", "buffer" },
      providers = {
        buffer = { 
          min_keyword_length = 4,
          max_items = 5,
        },
        snippets = { 
          min_keyword_length = 2,
          max_items = 10,
        },
        path = {
          max_items = 10,
        },
        lsp = {
          max_items = 20,
        },
      },
    },

    completion = {
      accept = { auto_brackets = { enabled = true } },
      list = {
        selection = { behavior = "auto_insert" },
      },
      documentation = {
        auto_show = true,
        auto_show_delay_ms = 200,
        window = { border = "rounded" },
      },
      menu = { 
        border = "rounded",
        draw = {
          columns = { { "kind_icon" }, { "label", "label_description", gap = 1 } },
        },
      },
    },

    signature = {
      enabled = true,
      window = { border = "rounded" },
    },

    snippets = {
      keymap = {
        expand_or_next = "<C-l>",
        prev = "<C-h>",
      },
    },
  })
end

return M
