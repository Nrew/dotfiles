local M = {}

function M.setup()
  if not nixCats("general") then
    return
  end
  
  require("persistence").setup({
    dir = vim.fn.stdpath("state") .. "/sessions/",
    options = { 
      "buffers", 
      "curdir", 
      "tabpages", 
      "winsize", 
      "help", 
      "globals", 
      "skiprtp" 
    },
    pre_save = nil,
    save_empty = false,
  })
  
  -- Keymaps
  vim.keymap.set("n", "<leader>qs", require("persistence").load, 
    { desc = "Restore Session" })
  vim.keymap.set("n", "<leader>ql", function()
    require("persistence").load({ last = true })
  end, { desc = "Restore Last Session" })
  vim.keymap.set("n", "<leader>qd", require("persistence").stop, 
    { desc = "Don't Save Current Session" })
  
  -- Auto commands
  vim.api.nvim_create_autocmd("VimEnter", {
    group = vim.api.nvim_create_augroup("Persistence", { clear = true }),
    callback = function()
      if vim.fn.argc() == 0 and not vim.g.started_with_stdin then
        require("persistence").load({ last = true })
      end
    end,
    desc = "Auto restore session on startup",
  })
end

return M
