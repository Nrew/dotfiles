local M = {}

function M.setup()
  if not nixCats("general") then
    return
  end
  
  require("which-key").setup({
    preset = "helix",
    delay = 500,
    plugins = {
      marks = true,
      registers = true,
      spelling = {
        enabled = true,
        suggestions = 20,
      },
    },
    win = {
      border = "rounded",
      position = "bottom",
      margin = { 1, 0, 1, 0 },
      padding = { 1, 2, 1, 2 },
      winblend = 0,
      zindex = 1000,
    },
    layout = {
      height = { min = 4, max = 25 },
      width = { min = 20, max = 50 },
      spacing = 3,
      align = "left",
    },
    keys = {
      scroll_down = "<c-d>",
      scroll_up = "<c-u>",
    },
    spec = {
      { "<leader>f", group = "Find" },
      { "<leader>b", group = "Buffer" },
      { "<leader>c", group = "Code" },
      { "<leader>g", group = "Git" },
      { "<leader>l", group = "LSP" },
      { "<leader>n", group = "Neotree" },
      { "<leader>q", group = "Quit" },
      { "<leader>s", group = "Search/Replace" },
      { "<leader>w", group = "Window" },
      { "<leader>x", group = "Diagnostics" },
    },
  })
end

return M
