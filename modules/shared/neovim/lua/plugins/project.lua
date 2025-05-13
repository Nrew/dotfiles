local M = {}

function M.setup()
  if not nixCats("general") then
    return
  end
  
  require("project_nvim").setup({
    detection_methods = { "lsp", "pattern" },
    patterns = { 
      ".git", 
      "_darcs", 
      ".hg", 
      ".bzr", 
      ".svn", 
      "Makefile", 
      "package.json", 
      "Cargo.toml", 
      "flake.nix",
      "pyproject.toml",
    },
    
    ignore_lsp = {},
    exclude_dirs = { "~/.cargo/*" },
    
    show_hidden = false,
    silent_chdir = true,
    scope_chdir = "global",
    
    datapath = vim.fn.stdpath("data"),
  })
  
  -- Integration with Telescope
  require("telescope").load_extension("projects")
  
  -- Keymaps
  vim.keymap.set("n", "<leader>fp", ":Telescope projects<CR>", 
    { desc = "Find projects" })
end

return M
