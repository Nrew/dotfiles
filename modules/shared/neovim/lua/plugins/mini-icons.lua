local M = {}

function M.setup()
  local ok, mini_icons = pcall(require, "mini.icons")
  if not ok then return end
end

return M