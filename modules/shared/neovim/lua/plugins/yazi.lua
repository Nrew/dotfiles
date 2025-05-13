local M = {}

function M.setup()
  if not nixCats("general") then
    return
  end
  
  -- Keymaps for yazi
  vim.keymap.set("n", "<leader>e", "<cmd>Yazi<CR>", 
    { desc = "Open yazi in current directory" })
  vim.keymap.set("n", "<leader>E", "<cmd>Yazi toggle<CR>", 
    { desc = "Resume last yazi session" })
  vim.keymap.set("n", "<leader>Y", function()
    vim.cmd("Yazi " .. vim.fn.expand("%:p:h"))
  end, { desc = "Open yazi in current file's directory" })
end

return M
