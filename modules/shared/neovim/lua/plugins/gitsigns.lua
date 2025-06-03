local utils = require("core.utils")
local M = {}

function M.load()
  return {
    event = "DeferredUIEnter",
  }
end

function M.setup()
  local gitsigns = utils.safe_require("gitsigns")
  if not gitsigns then return end

  utils.safe_call(function()
    gitsigns.setup({
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
      watch_gitdir = { follow_files = true },
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
        local map = utils.keymap
        local opts = { buffer = bufnr }

        map("n", "]c", function()
          if vim.wo.diff then return "]c" end
          vim.schedule(function() gs.next_hunk() end)
          return "<Ignore>"
        end, utils.merge_tables(opts, { expr = true, desc = "Next hunk" }))

        map("n", "[c", function()
          if vim.wo.diff then return "[c" end
          vim.schedule(function() gs.prev_hunk() end)
          return "<Ignore>"
        end, utils.merge_tables(opts, { expr = true, desc = "Previous hunk" }))

        map("n", "<leader>hs", gs.stage_hunk, utils.merge_tables(opts, { desc = "Stage hunk" }))
        map("n", "<leader>hr", gs.reset_hunk, utils.merge_tables(opts, { desc = "Reset hunk" }))
        map("v", "<leader>hs", function() gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") }) end, utils.merge_tables(opts, { desc = "Stage hunk" }))
        map("v", "<leader>hr", function() gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") }) end, utils.merge_tables(opts, { desc = "Reset hunk" }))
        map("n", "<leader>hS", gs.stage_buffer, utils.merge_tables(opts, { desc = "Stage buffer" }))
        map("n", "<leader>hu", gs.undo_stage_hunk, utils.merge_tables(opts, { desc = "Undo stage hunk" }))
        map("n", "<leader>hR", gs.reset_buffer, utils.merge_tables(opts, { desc = "Reset buffer" }))
        map("n", "<leader>hp", gs.preview_hunk, utils.merge_tables(opts, { desc = "Preview hunk" }))
        map("n", "<leader>hb", function() gs.blame_line({ full = true }) end, utils.merge_tables(opts, { desc = "Blame line" }))
        map("n", "<leader>tb", gs.toggle_current_line_blame, utils.merge_tables(opts, { desc = "Toggle blame" }))
        map("n", "<leader>hd", gs.diffthis, utils.merge_tables(opts, { desc = "Diff this" }))
        map("n", "<leader>hD", function() gs.diffthis("~") end, utils.merge_tables(opts, { desc = "Diff this ~" }))
        map("n", "<leader>td", gs.toggle_deleted, utils.merge_tables(opts, { desc = "Toggle deleted" }))

        map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", utils.merge_tables(opts, { desc = "Select hunk" }))
      end,
    })
  end, "gitsigns setup")
end

return M
