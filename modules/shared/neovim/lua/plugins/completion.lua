local M = {}

function M.setup()
  if not nixCats("general") then
    return
  end
  
  require("blink.cmp").setup({
    keymap = { preset = "super-tab" },
    
    appearance = {
      use_nvim_cmp_as_default = true,
      nerd_font_variant = "mono",
    },
    
    sources = {
      default = { "lsp", "path", "snippets", "buffer" },
      providers = {
        snippets = {
          min_keyword_length = 2,
        },
        buffer = {
          min_keyword_length = 4,
          get_bufnrs = function()
            return vim.api.nvim_list_bufs()
          end,
        },
      },
    },
    
    completion = {
      accept = { auto_brackets = { enabled = true } },
      documentation = { 
        auto_show = true, 
        auto_show_delay_ms = 500,
        window = {
          border = "rounded",
        },
      },
      menu = {
        border = "rounded",
        draw = {
          treesitter = { "lsp" },
        },
      },
      list = {
        selection = "auto_insert",
      },
    },
    
    signature = { 
      enabled = true,
      window = {
        border = "rounded",
      },
    },
  })
end

return M
