local utils = require("core.utils")
local M = {}

function M.setup()
  local lspconfig = utils.safe_require("lspconfig")
  assert(lspconfig, "CRITICAL: nvim-lspconfig is required but not available")
  
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  
  local blink_cmp = utils.safe_require("blink.cmp")
  if blink_cmp and blink_cmp.get_lsp_capabilities then
    capabilities = blink_cmp.get_lsp_capabilities(capabilities)
  end
  
  local servers = {
    lua_ls = {
      condition = function() return utils.has_category("lua") end,
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
    
    nixd = {
      condition = function() return utils.has_category("nix") end,
      settings = {
        nixd = {
          nixpkgs = { expr = "import <nixpkgs> { }" },
          formatting = { command = { "nixfmt" } },
        },
      },
    },
    
    tsserver = {
      condition = function() return utils.has_category("typescript") end,
      on_attach = function(client, bufnr)
        assert(client and client.server_capabilities, "LSP client must have server_capabilities")
        client.server_capabilities.documentFormattingProvider = false
      end,
    },
    
    pyright = {
      condition = function() return utils.has_category("python") end,
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
    
    rust_analyzer = {
      condition = function() return utils.has_category("rust") end,
      settings = {
        ["rust-analyzer"] = {
          cargo = { allFeatures = true },
          procMacro = { enable = true },
        },
      },
    },
    
    gopls = {
      condition = function() return utils.has_category("go") end,
      settings = {
        gopls = {
          analyses = { unusedparams = true },
          staticcheck = true,
        },
      },
    },
    
    clangd = {
      condition = function() return utils.has_category("c") end,
      cmd = { "clangd", "--background-index" },
    },
  }
  
  local function on_attach(client, bufnr)
    assert(client, "LSP client cannot be nil")
    assert(type(bufnr) == "number" and bufnr > 0, "Buffer number must be a positive integer")
    
    local map = utils.keymap
    local opts = { buffer = bufnr }
    
    map("n", "gD", vim.lsp.buf.declaration, utils.merge_tables(opts, { desc = "Go to declaration" }))
    map("n", "gd", vim.lsp.buf.definition, utils.merge_tables(opts, { desc = "Go to definition" }))
    map("n", "K", vim.lsp.buf.hover, utils.merge_tables(opts, { desc = "Hover documentation" }))
    map("n", "gi", vim.lsp.buf.implementation, utils.merge_tables(opts, { desc = "Go to implementation" }))
    map("n", "<C-k>", vim.lsp.buf.signature_help, utils.merge_tables(opts, { desc = "Signature help" }))
    map("n", "<leader>D", vim.lsp.buf.type_definition, utils.merge_tables(opts, { desc = "Type definition" }))
    map("n", "<leader>rn", vim.lsp.buf.rename, utils.merge_tables(opts, { desc = "Rename symbol" }))
    map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, utils.merge_tables(opts, { desc = "Code action" }))
    map("n", "gr", vim.lsp.buf.references, utils.merge_tables(opts, { desc = "References" }))
    map("n", "<leader>cf", function()
      vim.lsp.buf.format({ async = true })
    end, utils.merge_tables(opts, { desc = "Format code" }))
  end
  
  for server_name, config in pairs(servers) do
    assert(type(config) == "table", string.format("Server '%s' config must be a table", server_name))
    
    if not config.condition or config.condition() then
      assert(lspconfig[server_name], string.format("lspconfig does not support server '%s'", server_name))
      
      local setup_config = {
        capabilities = capabilities,
        on_attach = config.on_attach or on_attach,
      }
      
      for key, value in pairs(config) do
        if key ~= "condition" then
          setup_config[key] = value
        end
      end
      
      utils.safe_call(
        function() lspconfig[server_name].setup(setup_config) end,
        string.format("LSP server '%s' setup", server_name)
      )
    end
  end
  
  assert(vim.diagnostic, "vim.diagnostic API not available")
  
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
  
  assert(vim.lsp.handlers, "vim.lsp.handlers not available")
  
  vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
    vim.lsp.handlers.hover,
    { border = "rounded" }
  )
  
  vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
    vim.lsp.handlers.signature_help,
    { border = "rounded" }
  )
end

return M