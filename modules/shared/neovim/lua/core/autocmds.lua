local M = {}

function M.setup()
  -- Create a general-purpose autocommand group
  local augroup = vim.api.nvim_create_augroup("UserAutoCommands", { clear = true })
  
  -- Highlight on yank
  vim.api.nvim_create_autocmd("TextYankPost", {
    group = augroup,
    pattern = "*",
    callback = function()
      vim.highlight.on_yank({ higroup = "IncSearch", timeout = 100 })
    end,
    desc = "Highlight yanked text",
  })
  
  -- Resize splits if window got resized
  vim.api.nvim_create_autocmd("VimResized", {
    group = augroup,
    callback = function()
      vim.cmd("tabdo wincmd =")
    end,
    desc = "Resize splits on window resize",
  })
  
  -- Go to last loc when opening a buffer
  vim.api.nvim_create_autocmd("BufReadPost", {
    group = augroup,
    callback = function()
      local mark = vim.api.nvim_buf_get_mark(0, '"')
      local lcount = vim.api.nvim_buf_line_count(0)
      if mark[1] > 0 and mark[1] <= lcount then
        pcall(vim.api.nvim_win_set_cursor, 0, mark)
      end
    end,
    desc = "Go to last location when opening a buffer",
  })
  
  -- Close some filetypes with <q>
  vim.api.nvim_create_autocmd("FileType", {
    group = augroup,
    pattern = {
      "PlenaryTestPopup",
      "help",
      "lspinfo",
      "man",
      "notify",
      "qf",
      "spectre_panel",
      "startuptime",
      "tsplayground",
      "checkhealth",
    },
    callback = function(event)
      vim.bo[event.buf].buflisted = false
      vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
    end,
    desc = "Close certain file types with q",
  })
  
  -- Wrap and check for spell in text filetypes
  vim.api.nvim_create_autocmd("FileType", {
    group = augroup,
    pattern = { "gitcommit", "markdown" },
    callback = function()
      vim.opt_local.wrap = true
      vim.opt_local.spell = true
    end,
    desc = "Enable wrap and spell for text files",
  })
  
  -- Auto create dir when saving file in non-existent directory
  vim.api.nvim_create_autocmd("BufWritePre", {
    group = augroup,
    callback = function(event)
      if event.match:match("^%w%w+://") then
        return
      end
      local file = vim.uv.fs_realpath(event.match) or event.match
      vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
    end,
    desc = "Auto create directory when saving a file",
  })
  
  -- Check if we need to reload the file when it changed
  vim.api.nvim_create_autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
    group = augroup,
    callback = function()
      if vim.o.buftype ~= "nofile" then
        vim.cmd("checktime")
      end
    end,
    desc = "Check if file has changed when gaining focus",
  })
  
  -- Set filetype for certain extensions
  vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
    group = augroup,
    pattern = "*.env.*",
    callback = function()
      vim.bo.filetype = "sh"
    end,
    desc = "Set filetype for .env files",
  })
  
  -- Disable automatic comment insertion
  vim.api.nvim_create_autocmd("BufEnter", {
    group = augroup,
    pattern = "*",
    callback = function()
      vim.opt.formatoptions:remove({ "c", "r", "o" })
    end,
    desc = "Disable automatic comment insertion",
  })
  
  -- Show cursor line only in active window
  vim.api.nvim_create_autocmd({ "InsertLeave", "WinEnter" }, {
    group = augroup,
    callback = function()
      if vim.bo.buftype == "" then
        vim.opt_local.cursorline = true
      end
    end,
    desc = "Show cursor line in active window",
  })
  
  vim.api.nvim_create_autocmd({ "InsertEnter", "WinLeave" }, {
    group = augroup,
    callback = function()
      vim.opt_local.cursorline = false
    end,
    desc = "Hide cursor line in inactive window",
  })
  
  -- Terminal settings
  vim.api.nvim_create_autocmd("TermOpen", {
    group = augroup,
    callback = function()
      vim.opt_local.number = false
      vim.opt_local.relativenumber = false
      vim.cmd("startinsert")
    end,
    desc = "Terminal settings",
  })
end

return M
