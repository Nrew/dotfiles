local M = {}

function M.setup()
  local ok, luasnip = pcall(require, "luasnip")
  if not ok then return end

  require("luasnip.loaders.from_vscode").lazy_load()
end

return M
