local M = {}

function M.setup()
  if not nixCats("general") then
    return
  end
  
  require("yanky").setup({
    ring = {
      history_length = 100,
      storage = "shada",
      sync_with_numbered_registers = true,
      cancel_event = "update",
      ignore_registers = { "_" },
    },
    picker = {
      select = {
        action = nil,
      },
      telescope = {
        use_default_mappings = true,
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
  
  -- Keymaps
  vim.keymap.set({ "n", "x" }, "p", "<Plug>(YankyPutAfter)", 
    { desc = "Put after cursor" })
  vim.keymap.set({ "n", "x" }, "P", "<Plug>(YankyPutBefore)", 
    { desc = "Put before cursor" })
  vim.keymap.set({ "n", "x" }, "gp", "<Plug>(YankyGPutAfter)", 
    { desc = "Put after selection" })
  vim.keymap.set({ "n", "x" }, "gP", "<Plug>(YankyGPutBefore)", 
    { desc = "Put before selection" })
  vim.keymap.set("n", "<c-p>", "<Plug>(YankyPreviousEntry)", 
    { desc = "Previous yank entry" })
  vim.keymap.set("n", "<c-n>", "<Plug>(YankyNextEntry)", 
    { desc = "Next yank entry" })
  vim.keymap.set("n", "]p", "<Plug>(YankyPutIndentAfterLinewise)", 
    { desc = "Put indent after" })
  vim.keymap.set("n", "[p", "<Plug>(YankyPutIndentBeforeLinewise)", 
    { desc = "Put indent before" })
  vim.keymap.set("n", "]P", "<Plug>(YankyPutIndentAfterLinewise)", 
    { desc = "Put indent after (uppercase)" })
  vim.keymap.set("n", "[P", "<Plug>(YankyPutIndentBeforeLinewise)", 
    { desc = "Put indent before (uppercase)" })
  vim.keymap.set("n", ">p", "<Plug>(YankyPutIndentAfterShiftRight)", 
    { desc = "Put and indent right" })
  vim.keymap.set("n", "<p", "<Plug>(YankyPutIndentAfterShiftLeft)", 
    { desc = "Put and indent left" })
  vim.keymap.set("n", ">P", "<Plug>(YankyPutIndentBeforeShiftRight)", 
    { desc = "Put and indent right (before)" })
  vim.keymap.set("n", "<P", "<Plug>(YankyPutIndentBeforeShiftLeft)", 
    { desc = "Put and indent left (before)" })
  vim.keymap.set("n", "=p", "<Plug>(YankyPutAfterFilter)", 
    { desc = "Put after with filter" })
  vim.keymap.set("n", "=P", "<Plug>(YankyPutBeforeFilter)", 
    { desc = "Put before with filter" })
  
  -- Telescope integration
  vim.keymap.set("n", "<leader>fy", ":Telescope yank_history<CR>", 
    { desc = "Yank history" })
end

return M
