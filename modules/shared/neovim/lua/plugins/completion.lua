local M = {}

function M.setup()
  local ok, blink = pcall(require, "blink.cmp")
  if not ok then return end

  blink.setup({
    keymap = { preset = "super-tab" },
    appearance = { nerd_font_variant = "mono" },

    sources = {
      default = { "lsp", "path", "snippets", "buffer" },
      providers = {
        buffer = { min_keyword_length = 4 },
        snippets = { min_keyword_length = 2 },
      },
    },

    completion = {
      accept = { auto_brackets = { enabled = true } },
      documentation = {
        auto_show = true,
        auto_show_delay_ms = 500,
        window = { border = "rounded" },
      },
      menu = { border = "rounded" },
    },

    signature = {
      enabled = true,
      window = { border = "rounded" },
    },
  })
end

return M