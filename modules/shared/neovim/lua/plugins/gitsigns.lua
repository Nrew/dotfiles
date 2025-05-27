local M = {}

-- Helper function to safely check nixCats
local function safe_nixcats(category)
  if type(nixCats) == "function" then
    return nixCats(category)
  end
  return false
end

function M.setup()
  if not safe_nixcats("general") then
    return
  end
  
  require("gitsigns").setup({
    signs = {
      add = { text = "│" },
      change = { text = "│" },
      delete = { text = "_" },
      topdelete = { text = "‾" },
      changedelete = { text = "~" },
      untracked = { text = "┆" },
    },
    signcolumn = true,
    numhl = false,
    linehl = false,
    word_diff = false,
    watch_gitdir = {
      interval = 1000,
      follow_files = true,
    },
    attach_to_untracked = true,
    current_line_blame = false,
    current_line_blame_opts = {
      virt_text = true,
      virt_text_pos = "eol",
      delay = 1000,
      ignore_whitespace = false,
    },
    sign_priority = 6,
    update_debounce = 100,
    status_formatter = nil,
    max_file_length = 40000,
    preview_config = {
      border = "rounded",
      style = "minimal",
      relative = "cursor",
      row = 0,
      col = 1,
    },
    
    on_attach = function(bufnr)
      local gs = package.loaded.gitsigns
      
      -- Navigation
      vim.keymap.set("n", "]c", function()
        if vim.wo.diff then return "]c" end
        vim.schedule(function() gs.next_hunk() end)
        return "<Ignore>"
      end, { buffer = bufnr, expr = true, desc = "Next git hunk" })
      
      vim.keymap.set("n", "[c", function()
        if vim.wo.diff then return "[c" end
        vim.schedule(function() gs.prev_hunk() end)
        return "<Ignore>"
      end, { buffer = bufnr, expr = true, desc = "Previous git hunk" })
      
      -- Actions
      vim.keymap.set("n", "<leader>gs", gs.stage_hunk, 
        { buffer = bufnr, desc = "Stage hunk" })
      vim.keymap.set("n", "<leader>gr", gs.reset_hunk, 
        { buffer = bufnr, desc = "Reset hunk" })
      vim.keymap.set("v", "<leader>gs", function()
        gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
      end, { buffer = bufnr, desc = "Stage visual selection" })
      vim.keymap.set("v", "<leader>gr", function()
        gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
      end, { buffer = bufnr, desc = "Reset visual selection" })
      vim.keymap.set("n", "<leader>gS", gs.stage_buffer, 
        { buffer = bufnr, desc = "Stage buffer" })
      vim.keymap.set("n", "<leader>gu", gs.undo_stage_hunk, 
        { buffer = bufnr, desc = "Undo stage hunk" })
      vim.keymap.set("n", "<leader>gR", gs.reset_buffer, 
        { buffer = bufnr, desc = "Reset buffer" })
      vim.keymap.set("n", "<leader>gp", gs.preview_hunk, 
        { buffer = bufnr, desc = "Preview hunk" })
      vim.keymap.set("n", "<leader>gb", function() 
        gs.blame_line({ full = true })
      end, { buffer = bufnr, desc = "Git blame line" })
      vim.keymap.set("n", "<leader>gtb", gs.toggle_current_line_blame, 
        { buffer = bufnr, desc = "Toggle line blame" })
      vim.keymap.set("n", "<leader>gd", gs.diffthis, 
        { buffer = bufnr, desc = "Diff this" })
      vim.keymap.set("n", "<leader>gD", function() 
        gs.diffthis("~") 
      end, { buffer = bufnr, desc = "Diff this ~" })
      vim.keymap.set("n", "<leader>gtd", gs.toggle_deleted, 
        { buffer = bufnr, desc = "Toggle deleted" })
      
      -- Text object
      vim.keymap.set({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", 
        { buffer = bufnr, desc = "Select git hunk" })
    end,
  })
end

return M
