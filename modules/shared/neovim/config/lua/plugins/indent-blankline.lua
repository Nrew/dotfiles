-- Indent Blankline Configuration

require("ibl").setup {
  enabled = true,
  debounce = 100,
  indent = {
    char = "┊",
    tab_char = nil,
    highlight = "IblIndent",
    smart_indent_cap = true,
    priority = 1,
  },
  whitespace = {
    highlight = "IblWhitespace",
    remove_blankline_trail = true,
  },
  scope = {
    enabled = true,
    char = nil,
    show_start = true,
    show_end = false,
    injected_languages = true,
    highlight = "IblScope",
    priority = 500,
    include = {
      node_type = {},
    },
    exclude = {
      language = {},
      node_type = {
        "comment",
        "directive",
        "type",
        "constant",
      },
    },
  },
  exclude = {
    filetypes = {
      "alpha",
      "dashboard",
      "neo-tree",
      "Trouble",
      "help",
      "lazy",
      "list",
      "mason",
      "notify",
      "text",
    },
    buftypes = {
      "terminal",
      "nofile",
      "quickfix",
      "prompt",
    },
  },
}
