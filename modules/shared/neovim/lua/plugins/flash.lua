local M = {}

function M.setup()
  if not nixCats("general") then
    return
  end
  
  require("flash").setup({
    labels = "asdfghjklqwertyuiopzxcvbnm",
    search = {
      multi_window = true,
      forward = true,
      wrap = true,
      mode = "exact",
      incremental = false,
    },
    jump = {
      jumplist = true,
      pos = "start",
      history = false,
      register = false,
      nohlsearch = false,
      autojump = false,
    },
    label = {
      uppercase = true,
      exclude = "",
      current = true,
      after = true,
      before = false,
      style = "overlay",
      reuse = "lowercase",
      distance = true,
      min_pattern_length = 0,
      rainbow = {
        enabled = false,
        shade = 5,
      },
    },
    highlight = {
      backdrop = true,
      matches = true,
      priority = 5000,
      groups = {
        match = "FlashMatch",
        current = "FlashCurrent",
        backdrop = "FlashBackdrop",
        label = "FlashLabel",
      },
    },
    action = nil,
    pattern = "",
    continue = false,
    config = nil,
    prompt = {
      enabled = true,
      prefix = { { " ", "FlashPromptIcon" } },
      win_config = {
        relative = "editor",
        width = 1,
        height = 1,
        row = -1,
        col = 0,
        zindex = 1000,
      },
    },
    remote_op = {
      restore = false,
      motion = false,
    },
  })
  
  -- Keymaps
  vim.keymap.set({ "n", "x", "o" }, "s", require("flash").jump, 
    { desc = "Flash" })
  vim.keymap.set({ "n", "x", "o" }, "S", require("flash").treesitter, 
    { desc = "Flash Treesitter" })
  vim.keymap.set("o", "r", require("flash").remote, 
    { desc = "Remote Flash" })
  vim.keymap.set({ "o", "x" }, "R", require("flash").treesitter_search, 
    { desc = "Treesitter Search" })
  vim.keymap.set("c", "<c-s>", require("flash").toggle, 
    { desc = "Toggle Flash Search" })
end

return M
