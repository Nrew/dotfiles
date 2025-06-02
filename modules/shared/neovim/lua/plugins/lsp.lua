local utils = require("core.utils")
local M = {}

function M.setup()
  -- INVARIANT: nixCats must be available and properly configured
  assert(utils.has_category, "INVARIANT FAILED: utils.has_category function not available")
  assert(utils.has_category("general"), "INVARIANT FAILED: general category must be enabled for LSP")
  
  local lspconfig = utils.safe_require("lspconfig")
  assert(lspconfig, "INVARIANT FAILED: nvim-lspconfig is required but not available")

  local capabilities = vim.lsp.protocol.make_client_capabilities()
  assert(capabilities, "INVARIANT FAILED: LSP capabilities must be available")
  
  local blink = utils.safe_require("blink.cmp")
  if blink and blink.get_lsp_capabilities then
    capabilities = blink.get_lsp_capabilities(capabilities)
    assert(capabilities, "INVARIANT FAILED: blink.cmp must return valid capabilities")
  end

  local function setup_keymaps(client, bufnr)
    assert(client, "INVARIANT FAILED: LSP client cannot be nil")
    assert(type(bufnr) == "number" and bufnr > 0, "INVARIANT FAILED: buffer number must be positive integer")
    assert(client.server_capabilities, "INVARIANT FAILED: client must have server_capabilities")
    
    local map = utils.keymap
    local opts = { buffer = bufnr }
    
    assert(type(map) == "function", "INVARIANT FAILED: utils.keymap must be function")
    
    local mappings = {
      { "n", "gD", vim.lsp.buf.declaration, "Go to declaration" },
      { "n", "gd", vim.lsp.buf.definition, "Go to definition" },
      { "n", "K", vim.lsp.buf.hover, "Hover documentation" },
      { "n", "gi", vim.lsp.buf.implementation, "Go to implementation" },
      { "n", "<C-k>", vim.lsp.buf.signature_help, "Signature help" },
      { "n", "<leader>D", vim.lsp.buf.type_definition, "Type definition" },
      { "n", "<leader>rn", vim.lsp.buf.rename, "Rename symbol" },
      { { "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, "Code action" },
      { "n", "gr", vim.lsp.buf.references, "References" },
      { "n", "<leader>cf", function() vim.lsp.buf.format({ async = true }) end, "Format code" },
    }
    
    for _, mapping in ipairs(mappings) do
      -- INVARIANT: Each mapping must have required fields
      assert(#mapping >= 4, "INVARIANT FAILED: mapping must have mode, key, action, description")
      map(mapping[1], mapping[2], mapping[3], utils.merge_tables(opts, { desc = mapping[4] }))
    end
  end

  local servers = {
    lua_ls = {
      condition = function() return utils.has_category("lua") end,
      settings = {
        Lua = {
          runtime = { version = "LuaJIT" },
          diagnostics = { globals = { "vim", "nixCats" } },
          workspace = { library = vim.api.nvim_get_runtime_file("", true), checkThirdParty = false },
          telemetry = { enable = false },
        },
      },
    },
    nixd = {
      condition = function() return utils.has_category("nix") end,
      settings = { nixd = { nixpkgs = { expr = "import <nixpkgs> { }" } } },
    },
    tsserver = {
      condition = function() return utils.has_category("typescript") end,
      on_attach = function(client, bufnr)
        assert(client and client.server_capabilities, "INVARIANT FAILED: TS server must have capabilities")
        client.server_capabilities.documentFormattingProvider = false
        setup_keymaps(client, bufnr)
      end,
    },
    pyright = {
      condition = function() return utils.has_category("python") end,
      settings = { python = { analysis = { typeCheckingMode = "strict" } } },
    },
    rust_analyzer = {
      condition = function() return utils.has_category("rust") end,
      settings = { ["rust-analyzer"] = { cargo = { allFeatures = true } } },
    },
    gopls = {
      condition = function() return utils.has_category("go") end,
      settings = { gopls = { analyses = { unusedparams = true }, staticcheck = true } },
    },
    clangd = {
      condition = function() return utils.has_category("c") end,
      cmd = { "clangd", "--background-index" },
    },
  }

  for server_name, config in pairs(servers) do
    assert(type(config) == "table", string.format("INVARIANT FAILED: %s config must be table", server_name))
    assert(type(config.condition) == "function", string.format("INVARIANT FAILED: %s must have condition function", server_name))
    
    if config.condition() then
      assert(lspconfig[server_name], string.format("INVARIANT FAILED: %s not available in lspconfig", server_name))
      
      local setup_config = {
        capabilities = capabilities,
        on_attach = config.on_attach or setup_keymaps,
      }
      
      for key, value in pairs(config) do
        if key ~= "condition" and key ~= "on_attach" then
          setup_config[key] = value
        end
      end
      
      local success = utils.safe_call(
        function() lspconfig[server_name].setup(setup_config) end,
        string.format("LSP server '%s' setup", server_name)
      )
      assert(success, string.format("INVARIANT FAILED: %s setup must succeed", server_name))
    end
  end

  assert(vim.diagnostic, "INVARIANT FAILED: vim.diagnostic API not available")
  assert(vim.diagnostic.config, "INVARIANT FAILED: vim.diagnostic.config function not available")

  vim.diagnostic.config({
    virtual_text = { prefix = "●", source = "if_many" },
    float = { source = "always", border = "rounded" },
    signs = true,
    underline = true,
    update_in_insert = false,
    severity_sort = true,
  })

  local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
  for type, icon in pairs(signs) do
    assert(type(icon) == "string" and #icon > 0, string.format("INVARIANT FAILED: %s icon must be non-empty string", type))
    vim.fn.sign_define("DiagnosticSign" .. type, { text = icon, texthl = "DiagnosticSign" .. type })
  end

  assert(vim.lsp.handlers, "INVARIANT FAILED: vim.lsp.handlers not available")
  assert(vim.lsp.handlers.hover, "INVARIANT FAILED: hover handler not available")
  assert(vim.lsp.handlers.signature_help, "INVARIANT FAILED: signature_help handler not available")

  vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })
  vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" })
end

return M
