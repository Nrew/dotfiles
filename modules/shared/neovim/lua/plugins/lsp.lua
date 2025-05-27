local M = {}

-- LSP server configurations
local LSP_SERVERS = {
  lua = {
    condition = function() return nixCats("lua") end,
    server = "lua_ls",
    settings = {
      Lua = {
        runtime = { version = "LuaJIT" },
        diagnostics = { globals = { "vim", "nixCats" } },
        workspace = { 
          library = vim.api.nvim_get_runtime_file("", true),
          checkThirdParty = false,
        },
        telemetry = { enable = false },
      },
    },
  },
  
  nix = {
    condition = function() return nixCats("nix") end,
    server = "nixd",
    settings = {
      nixd = {
        nixpkgs = { expr = "import <nixpkgs> { }" },
        formatting = { command = { "nixfmt" } },
      },
    },
  },
  
  typescript = {
    condition = function() return nixCats("typescript") end,
    server = "ts_ls",
    on_attach = function(client, bufnr)
      -- Disable ts_ls formatting in favor of prettierd
      client.server_capabilities.documentFormattingProvider = false
    end,
  },
  
  python = {
    condition = function() return nixCats("python") end,
    server = "pyright",
    settings = {
      python = {
        analysis = {
          autoSearchPaths = true,
          useLibraryCodeForTypes = true,
          typeCheckingMode = "strict",
        },
      },
    },
  },
  
  rust = {
    condition = function() return nixCats("rust") end,
    server = "rust_analyzer",
    settings = {
      ["rust-analyzer"] = {
        cargo = { allFeatures = true },
        procMacro = { enable = true },
      },
    },
  },
  
  go = {
    condition = function() return nixCats("go") end,
    server = "gopls",
    settings = {
      gopls = {
        analyses = { unusedparams = true },
        staticcheck = true,
      },
    },
  },
  
  c = {
    condition = function() return nixCats("c") end,
    server = "clangd",
    cmd = { "clangd", "--background-index" },
  },
}

-- Common on_attach function
local function on_attach(client, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  vim.bo[bufnr].omnifunc = "v:lua.vim.lsp.omnifunc"
  
  -- LSP key mappings
  local opts = { noremap = true, silent = true, buffer = bufnr }
  vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
  vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
  vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
  vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
  vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
  vim.keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, opts)
  vim.keymap.set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, opts)
  vim.keymap.set("n", "<leader>wl", function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, opts)
  vim.keymap.set("n", "<leader>D", vim.lsp.buf.type_definition, opts)
  vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
  vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)
  vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
  vim.keymap.set("n", "<leader>cf", function()
    vim.lsp.buf.format({ async = true })
  end, opts)
end

function M.setup()
  if not nixCats("general") then
    return
  end
  
  local lspconfig = require("lspconfig")
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  
  -- Enhanced capabilities from blink.cmp
  capabilities = require("blink.cmp").get_lsp_capabilities(capabilities)
  
  -- Set up each LSP server
  for name, config in pairs(LSP_SERVERS) do
    if config.condition() then
      local setup_config = {
        capabilities = capabilities,
        on_attach = config.on_attach or on_attach,
      }
      
      -- Merge server-specific settings
      for key, value in pairs(config) do
        if key ~= "condition" and key ~= "server" then
          setup_config[key] = value
        end
      end
      
      lspconfig[config.server].setup(setup_config)
    end
  end
  
  -- Configure LSP UI
  vim.diagnostic.config({
    virtual_text = {
      prefix = "●",
      source = "if_many",
    },
    float = {
      source = "always",
      border = "rounded",
    },
    signs = true,
    underline = true,
    update_in_insert = false,
    severity_sort = true,
  })
  
  -- Set diagnostic signs
  local signs = {
    Error = " ",
    Warn = " ",
    Hint = " ",
    Info = " ",
  }
  
  for type, icon in pairs(signs) do
    local hl = "DiagnosticSign" .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
  end
  
  -- Configure hover window
  vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
    vim.lsp.handlers.hover,
    { border = "rounded" }
  )
  
  -- Configure signature help window
  vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
    vim.lsp.handlers.signature_help,
    { border = "rounded" }
  )
end

return M
