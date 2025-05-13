local M = {}

function M.setup()
  if not nixCats("general") then
    return
  end
  
  -- Keymaps
  vim.keymap.set("n", "<leader>gg", "<cmd>LazyGit<CR>", 
    { desc = "Open LazyGit" })
  vim.keymap.set("n", "<leader>gl", "<cmd>LazyGitConfig<CR>", 
    { desc = "LazyGit config" })
  vim.keymap.set("n", "<leader>gf", "<cmd>LazyGitFilter<CR>", 
    { desc = "LazyGit filter" })
  vim.keymap.set("n", "<leader>gF", "<cmd>LazyGitFilterCurrentFile<CR>", 
    { desc = "LazyGit filter current file" })
end

return M
