local M = {}

function M.setup()
  local augroup = vim.api.nvim_create_augroup
  local autocmd = vim.api.nvim_create_autocmd

  local user_aucmds = augroup("UserAutoCommands", { clear = true })

  -- Check if we need to reload the file when it changed
  autocmd({"FocusGained", "TermClose", "TermLeave"}, {
    group = user_aucmds,
    callback = function ()
      if vim.bo.buftype ~= "nofile" then
        vim.cmd("checktime")
      end
    end,
    desc = "Check if file has changed when gaining focus",
  })

  -- Highlight on yank
  autocmd("TextYankPost", {
    group = user_aucmds,
    callback = function()
      (vim.h1 or vim.highlight).on_yank()
    end,
    desc = "Highlight on yank",
  })

  -- Resize splits if window got resized
  autocmd({ "VimResized" }, {
    group = user_aucmds,
    callback = function()
      local current_tab = vim.fn.tabpagenr()
      vim.cmd("tabdo wincmd =")
      vim.cmd("tabnext " .. current_tab)
    end,
    desc = "Resize splits on window resize",
  })

  -- Go to last loc when opening a buffer
  autocmd("BufReadPost", {
    group = user_aucmds,
    callback = function(event)
      local exclude = { "gitcommit" }
      local buf = event.buf
      if vim.tbl_contains(exclude, vim.bo[buf].filetype) or vim.b[buf].lazyvim_last_loc then
        return
      end
      vim.b[buf].lazyvim_last_loc = true
      local mark = vim.api.nvim_buf_get_mark(buf, '"')
      local lcount = vim.api.nvim_buf_line_count(buf)
      if mark[1] > 0 and mark[1] <= lcount then
        pcall(vim.api.nvim_win_set_cursor, 0, mark)
      end
    end,
    desc = "Go to last location when opening a buffer",
  })

  -- close the following pattern with <q>
  autocmd('FileType', {
    group = user_aucmds,
    pattern = {
      "PlenaryTestPopup",
      "checkhealth",
      "dbout",
      "gitsigns-blame",
      "grug-far",
      "man",
      "help",
      "lspinfo",
      "neotest-output",
      "neotest-output-panel",
      "neotest-summary",
      "notify",
      "qf",
      "spectre_panel",
      "startuptime",
      "tsplayground",
    },
    callback = function(event)
      vim.bo[event.buf].buflisted = false
      vim.schedule(function()
        vim.keymap.set("n", "q", "<cmd>close<CR>", {
          buffer = event.buf,
          silent = true,
          desc = "Quit buffer",
        })
      end)
    end,
    desc = "Setup 'q' to close certain buffer types"
  })

  -- Make it easier to close man-files when opened inline
  autocmd("FileType", {
    group = user_aucmds,
    pattern = { "man" },
    callback = function(event) 
      vim.bo[event.buf].buflisted = false
    end,
    desc = "Close inline man-files with ease."
  })

  autocmd("FileType", {
    group = user_aucmds,
    pattern = { "text", "plaintex", "typst", "gitcommit", "markdown" },
    callback = function()
      vim.opt_local.wrap = true
      vim.opt_local.spell = true
    end,
    desc = "Enable wrap and spell for text files",
  })

  -- Fix conceallevel for json files
  autocmd({ "FileType" }, {
    group = user_aucmds,
    pattern = { "json", "jsonc", "json5" },
    callback = function()
      vim.opt_local.conceallevel = 0
    end,
    desc = "Set conceallevel to 0 for JSON files",
  })

  autocmd({"BufWritePre"}, {
    group = user_aucmds,
    callback = function(event)
      if event.match:match("^%w%w+:[\\/][\\/]") then
        return
      end
      local file = vim.uv.fs_realpath(event.match) or event.match
      vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
    end,
    desc = "Auto create directory when saving a file",
  })
end

return M
