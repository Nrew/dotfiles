local utils = require("utils")
local M = {}

function M.setup()
  local lspconfig = require("lspconfig")
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  
  -- Enhanced capabilities from blink.cmp
  capabilities = require("blink.cmp").get_lsp_capabilities(capabilities)
  
  -- LSP server configurations
  local servers = {
    lua_ls = {
      condition = function() return utils("lua") end,
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
      condition = function() return utils.nixcats("nix") end,
      settings = {
        nixd = {
          nixpkgs = { expr = "import <nixpkgs> { }" },
          formatting = { command = { "nixfmt" } },
        },
      },
    },
    
    tsserver = {
      condition = function() return utils.nixcats("typescript") end,
      on_attach = function(client, bufnr)
        client.server_capabilities.documentFormattingProvider = false
      end,
    },
    
    pyright = {
      condition = function() return utils.nixcats("python") end,
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
      condition = function() return utils.nixcats("rust") end,
      settings = {
        ["rust-analyzer"] = {
          cargo = { allFeatures = true },
          procMacro = { enable = true },
        },
      },
    },
    
    gopls = {
      condition = function() return utils.nixcats("go") end,
      settings = {
        gopls = {
          analyses = { unusedparams = true },
          staticcheck = true,
        },
      },
    },
    
    clangd = {
      condition = function() return utils.nixcats("c") end,
      cmd = { "clangd", "--background-index" },
    },
  }
  
  -- Common on_attach function
  local function on_attach(client, bufnr)
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
  
  -- Setup each LSP server
  for server_name, config in pairs(servers) do
    if not config.condition or config.condition() then
      local setup_config = {
        capabilities = capabilities,
        on_attach = config.on_attach or on_attach,
      }
      
      -- Merge server-specific settings
      for key, value in pairs(config) do
        if key ~= "condition" then
          setup_config[key] = value
        end
      end
      
      lspconfig[server_name].setup(setup_config)
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
  
  -- Configure hover and signature help windows
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
