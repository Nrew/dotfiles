local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- General Settings
augroup("GeneralSettings", {})

-- Format on save
autocmd("BufWritePre", {
  group = "GeneralSettings",
  pattern = "*",
  callback = function()
    vim.lsp.buf.format({ async = false })
  end,
})

-- Highlight on yank
autocmd("TextYankPost", {
  group = "GeneralSettings",
  pattern = "*",
  callback = function()
    vim.highlight.on_yank({ higroup = "Visual", timeout = 200 })
  end,
})

-- Enable folding for treesitter
autocmd("BufEnter", {
  group = "GeneralSettings",
  pattern = "*",
  callback = function()
    if vim.opt.foldmethod:get() == "expr" then
      vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
    end
  end,
})

-- Hide status line for alpha
autocmd("FileType", {
  group = "GeneralSettings",
  pattern = "alpha",
  callback = function()
    vim.opt_local.laststatus = 0
  end,
})

-- Restore status line
autocmd("BufUnload", {
  group = "GeneralSettings",
  pattern = "alpha",
  callback = function()
    vim.opt_local.laststatus = 3
  end,
})

-- Auto-resize windows on vim resize
autocmd("VimResized", {
  group = "GeneralSettings",
  callback = function()
    vim.cmd("tabdo wincmd =")
  end,
})

-- Enable spell checking for certain file types
autocmd("FileType", {
  group = "GeneralSettings",
  pattern = { "gitcommit", "markdown", "text" },
  command = "setlocal spell",
})

-- Auto-create directories when saving
autocmd("BufWritePre", {
  group = "GeneralSettings",
  callback = function(args)
    if args.match:match("^%w%w+://") then
      return
    end
    local file = vim.loop.fs_realpath(args.match) or args.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
  end,
})

-- LSP Attach autocmd
autocmd("LspAttach", {
  group = augroup("UserLspConfig", {}),
  callback = function(ev)
    local opts = { buffer = ev.buf }
    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
    vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
    vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
    vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
    vim.keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, opts)
    vim.keymap.set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, opts)
    vim.keymap.set("n", "<leader>wl", function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, opts)
    vim.keymap.set("n", "<leader>D", vim.lsp.buf.type_definition, opts)
    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
    vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)
    vim.keymap.set("n", "<leader>f", function()
      vim.lsp.buf.format { async = true }
    end, opts)
  end,
})
