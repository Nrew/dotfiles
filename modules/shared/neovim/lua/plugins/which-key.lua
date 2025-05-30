local utils = require("core.utils")
local M = {}

function M.setup()
  local which_key = utils.safe_require("which-key")
  if not which_key then return end

  utils.safe_call(function()
    which_key.setup({
      plugins = {
        marks = true,
        registers = true,
        spelling = { enabled = true, suggestions = 20 },
        presets = {
          operators = false,
          motions = true,
          text_objects = true,
          windows = true,
          nav = true,
          z = true,
          g = true,
        },
      },
      window = {
        border = "rounded",
        position = "bottom",
        margin = { 1, 0, 1, 0 },
        padding = { 2, 2, 2, 2 },
        winblend = 0,
      },
      layout = {
        height = { min = 4, max = 25 },
        width = { min = 20, max = 50 },
        spacing = 3,
        align = "left",
      },
      ignore_missing = true,
      hidden = { "<silent>", "<cmd>", "<Cmd>", "<CR>", "call", "lua", "^:", "^ " },
      show_help = true,
      triggers = "auto",
      triggers_blacklist = {
        i = { "j", "k" },
        v = { "j", "k" },
      },
    })

    which_key.register({
      f = {
        name = "+find",
        f = { "<cmd>Telescope find_files<cr>", "Find files" },
        g = { "<cmd>Telescope live_grep<cr>", "Live grep" },
        b = { "<cmd>Telescope buffers<cr>", "Find buffers" },
        h = { "<cmd>Telescope help_tags<cr>", "Help tags" },
        r = { "<cmd>Telescope oldfiles<cr>", "Recent files" },
      },
      g = { name = "+git" },
      l = { name = "+lsp" },
      s = { name = "+search" },
      t = { name = "+toggle" },
      w = { name = "+windows" },
      x = { name = "+diagnostics" },
    }, { prefix = "<leader>" })
  end, "which-key setup")
end

return M