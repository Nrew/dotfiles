local M = {}

function M.setup()
  local ok, which_key = pcall(require, "which-key")
  if not ok then return end

  which_key.setup({
    preset = "modern",
    delay = 500,
    icons = {
      mappings = true,
      keys = {},
    },
    spec = {
      { "<leader>f", group = "find" },
      { "<leader>g", group = "git" },
      { "<leader>c", group = "code" },
      { "<leader>w", group = "windows" },
      { "<leader>x", group = "diagnostics" },
      { "<leader>b", group = "buffers" },
      { "<leader>h", group = "git hunks" },
      { "<leader>t", group = "toggle" },
      { "<leader>q", group = "quit/session" },
    },
  })
end

return M