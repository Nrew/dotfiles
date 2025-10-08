local augroup = vim.api.nvim_create_augroup("UserAutoCommands", { clear = true })
local autocmd = vim.api.nvim_create_autocmd

-- Check for file changes
autocmd({"FocusGained", "TermClose", "TermLeave"}, {
  group = augroup,
  callback = function()
    if vim.bo.buftype ~= "nofile" then vim.cmd("checktime") end
  end,
})

-- Highlight on yank
autocmd("TextYankPost", {
  group = augroup,
  callback = function() vim.highlight.on_yank() end,
})

-- Resize splits when window is resized
autocmd("VimResized", {
  group = augroup,
  callback = function()
    local current_tab = vim.fn.tabpagenr()
    vim.cmd("tabdo wincmd =")
    vim.cmd("tabnext " .. current_tab)
  end,
})

-- Go to last location when opening buffer
autocmd("BufReadPost", {
  group = augroup,
  callback = function(event)
    local exclude = { "gitcommit" }
    local buf = event.buf
    if vim.tbl_contains(exclude, vim.bo[buf].filetype) then return end

    local mark = vim.api.nvim_buf_get_mark(buf, '"')
    local lcount = vim.api.nvim_buf_line_count(buf)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- Close certain filetypes with 'q'
autocmd("FileType", {
  group = augroup,
  pattern = {
    "help", "lspinfo", "man", "notify", "qf", "spectre_panel",
    "startuptime", "checkhealth", "PlenaryTestPopup"
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<cr>", {
      buffer = event.buf,
      silent = true
    })
  end,
})

-- Enable wrap and spell for text files
autocmd("FileType", {
  group = augroup,
  pattern = { "text", "plaintex", "gitcommit", "markdown" },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = true
  end,
})

-- Auto create directories when saving
autocmd("BufWritePre", {
  group = augroup,
  callback = function(event)
    if event.match:match("^%w%w+:[\\/][\\/]") then return end
    local file = vim.uv.fs_realpath(event.match) or event.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
  end,
})

local format_augroup = vim.api.nvim_create_augroup("FormatOnSave", { clear = true })
autocmd("BufWritePre", {
  group = format_augroup,
  pattern = "*",
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)

    if client and client.server_capabilities.documentFormattingProvider then
      vim.lsp.buf.format({
        bufnr = args.buf,
        async = false,
      })
    end
  end,
})

local lsp_attach_augroup = vim.api.nvim_create_augroup("LspAttachEnhancements", { clear = true })
autocmd("LspAttach", {
  group = lsp_attach_augroup,
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)

    if client and client.server_capabilities.inlayHintProvider then
      vim.lsp.inlay_hint.enable(true, { bufnr = args.buf })
    end
  end,
})