local M = {}

function M.setup()
  local ok, luasnip = pcall(require, "lussnip")
  if not ok then return end

  require("lunasnip.loaders.from_vscode").lazy_load()

  end
return M
