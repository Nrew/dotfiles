-- Editor Enhancement Plugins

-- Auto pairs
require('nvim-autopairs').setup({})

-- Surround
require('nvim-surround').setup({})

-- Comment
require('Comment').setup({})

-- Colorizer (for colors in css, etc)
require('colorizer').setup()

-- Yanky (better yank history)
require('yanky').setup({
  ring = {
    history_length = 100,
    storage = "shada",
    sync_with_numbered_registers = true,
    cancel_event = "update",
  },
  picker = {
    select = {
      action = nil,
    },
    telescope = {
      mappings = nil,
    },
  },
  system_clipboard = {
    sync_with_ring = true,
  },
  highlight = {
    on_put = true,
    on_yank = true,
    timer = 500,
  },
  preserve_cursor_position = {
    enabled = true,
  },
})

-- Yanky keymaps
local keymap = vim.keymap.set
keymap({"n","x"}, "p", "<Plug>(YankyPutAfter)")
keymap({"n","x"}, "P", "<Plug>(YankyPutBefore)")
keymap({"n","x"}, "gp", "<Plug>(YankyGPutAfter)")
keymap({"n","x"}, "gP", "<Plug>(YankyGPutBefore)")

keymap("n", "<c-p>", "<Plug>(YankyPreviousEntry)")
keymap("n", "<c-n>", "<Plug>(YankyNextEntry)")

keymap("n", "]p", "<Plug>(YankyPutIndentAfterLinewise)")
keymap("n", "[p", "<Plug>(YankyPutIndentBeforeLinewise)")
keymap("n", "]P", "<Plug>(YankyPutIndentAfterLinewise)")
keymap("n", "[P", "<Plug>(YankyPutIndentBeforeLinewise)")

keymap("n", ">p", "<Plug>(YankyPutIndentAfterShiftRight)")
keymap("n", "<p", "<Plug>(YankyPutIndentAfterShiftLeft)")
keymap("n", ">P", "<Plug>(YankyPutIndentBeforeShiftRight)")
keymap("n", "<P", "<Plug>(YankyPutIndentBeforeShiftLeft)")

keymap("n", "=p", "<Plug>(YankyPutAfterFilter)")
keymap("n", "=P", "<Plug>(YankyPutBeforeFilter)")

-- Guess indent
require('guess-indent').setup({})

-- Flash (better quick navigation)
require('flash').setup({
  labels = "asdfghjklqwertyuiopzxcvbnm",
  search = {
    multi_window = true,
    forward = true,
    wrap = true,
    mode = "exact",
    incremental = false,
  },
  jump = {
    jumplist = true,
    pos = "start",
    history = false,
    register = false,
    nohlsearch = false,
    autojump = false,
  },
  label = {
    uppercase = true,
    exclude = "",
    current = true,
    after = true,
    before = false,
    style = "overlay",
    reuse = "lowercase",
    distance = true,
    min_pattern_length = 0,
    rainbow = {
      enabled = false,
      shade = 5,
    },
  },
  highlight = {
    backdrop = true,
    matches = true,
    priority = 5000,
    groups = {
      match = "FlashMatch",
      current = "FlashCurrent",
      backdrop = "FlashBackdrop",
      label = "FlashLabel",
    },
  },
  modes = {
    search = {
      enabled = true,
      highlight = { backdrop = false },
      jump = { history = true, register = true, nohlsearch = true },
      search = {
        mode = "search",
        incremental = true,
      },
    },
    char = {
      enabled = true,
      config = function(opts)
        opts.autohide = opts.autohide or (vim.fn.mode(true):find("no") and vim.v.operator == "y")
        opts.jump_labels = opts.jump_labels
          or opts.autohide
          or (opts.jump_labels == "smart" and vim.fn.mode(true):find("o"))
      end,
      autohide = false,
      jump_labels = false,
      multi_line = true,
      label = { exclude = "hjkliardc" },
      keys = { "f", "F", "t", "T", ";", "," },
      char_actions = function(motion)
        return {
          [";"] = "next",
          [","] = "prev",
          [motion:lower()] = "next",
          [motion:upper()] = "prev",
        }
      end,
      search = { wrap = false },
      highlight = { backdrop = true },
      jump = { register = false },
    },
    treesitter = {
      labels = "abcdefghijklmnopqrstuvwxyz",
      jump = { pos = "range" },
      search = { incremental = false },
      label = { before = true, after = true, style = "inline" },
      highlight = {
        backdrop = false,
        matches = false,
      },
    },
    treesitter_search = {
      jump = { pos = "range" },
      search = { multi_window = true, wrap = true, incremental = false },
      remote_op = { restore = true },
      label = { before = true, after = true, style = "inline" },
    },
    remote = {
      remote_op = { restore = true, motion = true },
    },
  },
})

-- UFO (better folding)
require('ufo').setup({
  provider_selector = function(bufnr, filetype, buftype)
    return {'treesitter', 'indent'}
  end
})

-- Stabilize (better scrolling)
require("stabilize").setup()

-- Persistence (session management)
require('persistence').setup({
  dir = vim.fn.expand(vim.fn.stdpath("state") .. "/sessions/"),
  options = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp" },
  pre_save = nil,
})

-- Session commands
vim.api.nvim_create_user_command("SessionRestore", function()
  require("persistence").load()
end, {})

vim.api.nvim_create_user_command("SessionLast", function()
  require("persistence").load({ last = true })
end, {})

vim.api.nvim_create_user_command("SessionStop", function()
  require("persistence").stop()
end, {})
