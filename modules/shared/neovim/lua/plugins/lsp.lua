local M = {}

local function has_category(cat)
  return type(_G.nixCats) == "function" and _G.nixCats(cat) or false
end

local function setup_keymaps(_, bufnr)
  local map = vim.keymap.set
  local opts = { buffer = bufnr, silent = true }

  map("n", "gD", vim.lsp.buf.declaration, vim.tbl_extend("force", opts, { desc = "Go to declaration" }))
  map("n", "gd", vim.lsp.buf.definition, vim.tbl_extend("force", opts, { desc = "Go to definition" }))
  map("n", "K", vim.lsp.buf.hover, vim.tbl_extend("force", opts, { desc = "Hover documentation" }))
  map("n", "gi", vim.lsp.buf.implementation, vim.tbl_extend("force", opts, { desc = "Go to implementation" }))
  map("n", "<C-k>", vim.lsp.buf.signature_help, vim.tbl_extend("force", opts, { desc = "Signature help" }))
  map("n", "<leader>D", vim.lsp.buf.type_definition, vim.tbl_extend("force", opts, { desc = "Type definition" }))
  map("n", "<leader>rn", vim.lsp.buf.rename, vim.tbl_extend("force", opts, { desc = "Rename symbol" }))
  map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, vim.tbl_extend("force", opts, { desc = "Code action" }))
  map("n", "gr", vim.lsp.buf.references, vim.tbl_extend("force", opts, { desc = "References" }))
  map("n", "<leader>cf", function() vim.lsp.buf.format({ async = true }) end, vim.tbl_extend("force", opts, { desc = "Format code" }))
end

function M.setup()
  local lspconfig = require("lspconfig")
  local capabilities = vim.lsp.protocol.make_client_capabilities()

  -- Enhance capabilities with blink.cmp if available
  local ok, blink = pcall(require, "blink.cmp")
  if ok and blink.get_lsp_capabilities then
    capabilities = blink.get_lsp_capabilities(capabilities)
  end

  local servers = {
    lua_ls = {
      condition = has_category("lua"),
      settings = {
        Lua = {
          runtime = { version = "LuaJIT" },
          diagnostics = { globals = { "vim", "nixCats" } },
          workspace = {
            library = vim.api.nvim_get_runtime_file("", true),
            checkThirdParty = false
          },
          telemetry = { enable = false },
        },
      },
    },
    nixd = {
      condition = has_category("nix"),
      settings = { 
        nixd = { 
          nixpkgs = { 
            expr = _G.nixCats("nixdExtras.nixpkgs") or "import <nixpkgs> { }"
          },
          formatting = {
            command = { "nixfmt" }
          },
          options = {
            nixos = {
              expr = '(builtins.getFlake "/home/nrew/.config/dotfiles").nixosConfigurations.default.options'
            },
            ["nix-darwin"] = {
              expr = '(builtins.getFlake "/Users/nrew/.config/dotfiles").darwinConfigurations.owl.options'
            },
            home_manager = {
              expr = '(builtins.getFlake "/home/nrew/.config/dotfiles").homeConfigurations.default.options'
            }
          }
        } 
      },
    },
    tsserver = {
      condition = has_category("typescript"),
      on_attach = function(client, bufnr)
        client.server_capabilities.documentFormattingProvider = false
        setup_keymaps(client, bufnr)
      end,
    },
    pyright = {
      condition = has_category("python"),
      settings = { python = { analysis = { typeCheckingMode = "strict" } } },
    },
    rust_analyzer = {
      condition = has_category("rust"),
      settings = { ["rust-analyzer"] = { cargo = { allFeatures = true } } },
    },
    gopls = {
      condition = has_category("go"),
      settings = { gopls = { analyses = { unusedparams = true }, staticcheck = true } },
    },
    clangd = {
      condition = has_category("c"),
      cmd = { "clangd", "--background-index" },
    },
  }

  for server, config in pairs(servers) do
    if config.condition then
      lspconfig[server].setup({
        capabilities = capabilities,
        on_attach = config.on_attach or setup_keymaps,
        settings = config.settings,
        cmd = config.cmd,
      })
    end
  end

  -- Diagnostics
  vim.diagnostic.config({
    virtual_text = { prefix = "●", source = "if_many" },
    float = { source = "always", border = "rounded" },
    signs = true,
    underline = true,
    update_in_insert = false,
    severity_sort = true,
  })

  -- LSP diagnostic signs
  local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
  for type, icon in pairs(signs) do
    vim.fn.sign_define("DiagnosticSign" .. type, { text = icon, texthl = "DiagnosticSign" .. type })
  end

  -- Handlers
  vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })
  vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" })
end

return M