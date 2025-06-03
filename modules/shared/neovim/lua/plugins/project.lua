local utils = require("core.utils")
local M = {}

function M.load()
  return {
    event = "DeferredUIEnter"
  }
end

function M.setup()
  local project = utils.safe_require("project_nvim")
  if not project then return end

  utils.safe_call(function()
    project.setup({
      manual_mode = false,
      detection_methods = { "lsp", "pattern" },
      patterns = { ".git", "_darcs", ".hg", ".bzr", ".svn", "Makefile", "package.json" },
      ignore_lsp = {},
      exclude_dirs = {},
      show_hidden = false,
      silent_chdir = true,
      scope_chdir = "global",
      datapath = vim.fn.stdpath("data"),
    })
  end, "project setup")
end

return M
