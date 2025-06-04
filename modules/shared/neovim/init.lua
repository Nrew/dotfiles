-- init.lua - Streamlined plugin loading with preserved customizations
require("core.options")
require("core.keymaps")
require("core.autocmds")

local function safe_setup(module_name)
  local ok, module = pcall(require, module_name)
  if ok and type(module.setup) == "function" then
    pcall(module.setup)
  end
end

-- Essential (immediate load)
safe_setup("plugins.theme")
safe_setup("plugins.treesitter")

-- LSP ecosystem (on file open)
vim.api.nvim_create_autocmd({"BufReadPre", "BufNewFile"}, {
  once = true,
  callback = function()
    safe_setup("plugins.lsp")
    safe_setup("plugins.completion")
    safe_setup("plugins.trouble")
  end
})

-- UI (deferred 50ms)
vim.defer_fn(function()
  safe_setup("plugins.telescope")
  safe_setup("plugins.neo-tree")
  safe_setup("plugins.lualine")
  safe_setup("plugins.bufferline")
  safe_setup("plugins.which-key")
  safe_setup("plugins.gitsigns")
  safe_setup("plugins.indent-blankline")
  safe_setup("plugins.todo-comments")
end, 50)

-- Editing (on interaction)
vim.api.nvim_create_autocmd({"InsertEnter", "CmdlineEnter"}, {
  once = true,
  callback = function()
    safe_setup("plugins.comment")
    safe_setup("plugins.surround")
    safe_setup("plugins.flash")
    safe_setup("plugins.mini-pairs")
  end
})

-- Git tools (on demand)
vim.api.nvim_create_user_command("LazyGit", function()
  safe_setup("plugins.lazygit")
  vim.cmd("LazyGit")
end, {})