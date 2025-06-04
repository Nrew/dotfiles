local M = {}

function M.setup()
  local ok, indent_blankline = pcall(require, "ibl")
  if not ok then return end

  indent_blankline.setup({
    indent = {
      char = "│",
      tab_char = "│"
    },
    whitespace = {
      highlight = { "Whitespace", "NonText" }
    },
    scope = {
      enabled = true,
      show_start = true,
      show_end = false
    },
    exclude = {
      filetypes = {
        "help", "alpha", "dashboard", "neo-tree", "Trouble", "trouble",
        "lazy", "mason", "notify", "toggleterm", "lazyterm",
      },
      buftypes = { "terminal", "nofile" },
    },
  })
end

return M