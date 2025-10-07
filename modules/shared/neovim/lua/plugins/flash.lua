local M = {}

function M.setup()
  local ok, flash = pcall(require, "flash")
  if not ok then return end

  flash.setup({
    labels = "asdfghjklqwertyuiopzxcvbnm",
    search = {
      multi_window = true,
      forward = true,
      wrap = true
    },
    jump = {
      jumplist = true,
      pos = "start",
      history = false,
      register = false
    },
    label = {
      uppercase = true,
      exclude = "",
      current = true,
      after = true,
      before = false
    },
    highlight = {
      backdrop = true,
      matches = true,
      priority = 5000,
      groups = {}
    },
    prompt = {
      enabled = true,
      prefix = { { "⚡", "FlashPromptIcon" } }
    },
    remote_op = {
      restore = true,
      motion = true
    },
  })

  -- Keymaps
  vim.keymap.set({ "n", "x", "o" }, "s", function() flash.jump() end, { desc = "Flash" })
  vim.keymap.set({ "n", "x", "o" }, "S", function() flash.treesitter() end, { desc = "Flash Treesitter" })
  vim.keymap.set("o", "r", function() flash.remote() end, { desc = "Remote Flash" })
  vim.keymap.set({ "o", "x" }, "R", function() flash.treesitter_search() end, { desc = "Treesitter Search" })
  vim.keymap.set("c", "<c-s>", function() flash.toggle() end, { desc = "Toggle Flash Search" })
end

return M