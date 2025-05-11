-- Copilot Configuration

-- Enable Copilot for all files
vim.api.nvim_create_autocmd("InsertEnter", {
  callback = function()
    vim.g.copilot_enabled = true
  end,
})

vim.api.nvim_create_autocmd("BufReadPost", {
  callback = function()
    vim.b.copilot_enabled = true
  end,
})

-- Key mappings
vim.api.nvim_set_keymap('i', '<C-J>', 'copilot#Accept("<CR>")', {expr=true, silent=true})
vim.api.nvim_set_keymap('i', '<C-H>', 'copilot#Previous()', {expr=true, silent=true})
vim.api.nvim_set_keymap('i', '<C-K>', 'copilot#Next()', {expr=true, silent=true})
vim.api.nvim_set_keymap('i', '<C-L>', 'copilot#Dismiss()', {expr=true, silent=true})
vim.g.copilot_no_tab_map = true
