local M = {}

function M.setup()
  if not nixCats("general") then
    return
  end
  
  -- Disable tab mapping to let other completion handle it
  vim.g.copilot_no_tab_map = true
  vim.g.copilot_assume_mapped = true
  vim.g.copilot_tab_fallback = ""
  
  -- Custom copilot mappings
  vim.keymap.set("i", "<C-J>", "copilot#Accept('\\<CR>')", 
    { expr = true, silent = true, desc = "Accept copilot suggestion" })
  vim.keymap.set("i", "<C-\\>", "copilot#Suggest()", 
    { expr = true, silent = true, desc = "Trigger copilot suggestion" })
  vim.keymap.set("i", "<C-]>", "copilot#Dismiss()", 
    { expr = true, silent = true, desc = "Dismiss copilot suggestion" })
  
  -- Auto commands for enabling/disabling copilot
  vim.api.nvim_create_autocmd("InsertEnter", {
    callback = function()
      vim.g.copilot_enabled = true
    end,
    desc = "Enable copilot in insert mode",
  })
  
  vim.api.nvim_create_autocmd("InsertLeave", {
    callback = function()
      vim.g.copilot_enabled = false
    end,
    desc = "Disable copilot in normal mode",
  })
  
  -- Commands for toggling copilot
  vim.api.nvim_create_user_command("CopilotEnable", function()
    vim.cmd("Copilot enable")
    vim.notify("Copilot enabled", vim.log.levels.INFO)
  end, { desc = "Enable Copilot" })
  
  vim.api.nvim_create_user_command("CopilotDisable", function()
    vim.cmd("Copilot disable")
    vim.notify("Copilot disabled", vim.log.levels.INFO)
  end, { desc = "Disable Copilot" })
  
  vim.api.nvim_create_user_command("CopilotToggle", function()
    vim.cmd("Copilot toggle")
    local status = vim.fn["copilot#Enabled"]() and "enabled" or "disabled"
    vim.notify("Copilot " .. status, vim.log.levels.INFO)
  end, { desc = "Toggle Copilot" })
end

return M
