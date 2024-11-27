# modules/cli/neovim/plugins.nix
{ config, lib, pkgs, ... }:

{
  programs.neovim = {
    plugins = with pkgs.vimPlugins; [
      # Completion
      {
        plugin = nvim-cmp;
        type = "lua";
        config = builtins.readFile ./config/lua/plugins/cmp.lua;
      }
      cmp-nvim-lsp
      cmp-buffer
      cmp-path
      cmp-cmdline
      cmp-nvim-lua
      luasnip
      cmp_luasnip
      friendly-snippets

      # LSP
      {
        plugin = nvim-lspconfig;
        type = "lua";
        config = builtins.readFile ./config/lua/plugins/lsp.lua;
      }
      {
        plugin = none-ls-nvim;
        type = "lua";
        config = builtins.readFile ./config/lua/plugins/null-ls.lua;
      }
      {
        plugin = lsp-format-nvim;
        type = "lua";
        config = ''
          require("lsp-format").setup {}
        '';
      }

      # Treesitter
      {
        plugin = (nvim-treesitter.withPlugins (plugins: with plugins; [
          tree-sitter-nix
          tree-sitter-lua
          tree-sitter-vim
          tree-sitter-bash
          tree-sitter-markdown
          tree-sitter-markdown-inline
          tree-sitter-regex
          tree-sitter-typescript
          tree-sitter-javascript
          tree-sitter-tsx
          tree-sitter-json
          tree-sitter-html
          tree-sitter-css
          tree-sitter-python
          tree-sitter-rust
          tree-sitter-go
        ]));
        type = "lua";
        config = builtins.readFile ./config/lua/plugins/treesitter.lua;
      }

      # Fuzzy Finding
      {
        plugin = telescope-nvim;
        type = "lua";
        config = builtins.readFile ./config/lua/plugins/telescope.lua;
      }
      telescope-fzf-native-nvim
      telescope-file-browser-nvim

      # Git
      {
        plugin = gitsigns-nvim;
        type = "lua";
        config = builtins.readFile ./config/lua/plugins/gitsigns.lua;
      }

      # UI
      {
        plugin = bufferline-nvim;
        type = "lua";
        config = builtins.readFile ./config/lua/plugins/bufferline.lua;
      }
      {
        plugin = indent-blankline-nvim;
        type = "lua";
        config = builtins.readFile ./config/lua/plugins/indent-blankline.lua;
      }
      {
        plugin = nvim-colorizer-lua;
        type = "lua";
        config = ''
          require'colorizer'.setup()
        '';
      }
    ];
  };

  # Create plugin configurations
  home.file = {
    ".config/nvim/lua/plugins/cmp.lua".text = ''
      local cmp = require('cmp')
      local luasnip = require('luasnip')
      require('luasnip.loaders.from_vscode').lazy_load()

      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = {
          ['<C-p>'] = cmp.mapping.select_prev_item(),
          ['<C-n>'] = cmp.mapping.select_next_item(),
          ['<C-d>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<C-e>'] = cmp.mapping.close(),
          ['<CR>'] = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
          }),
          ['<Tab>'] = function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end,
          ['<S-Tab>'] = function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end,
        },
        sources = {
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
          { name = 'buffer' },
          { name = 'nvim_lua' },
          { name = 'path' },
        },
      })
    '';

    ".config/nvim/lua/plugins/lsp.lua".text = ''
      local lspconfig = require('lspconfig')
      local capabilities = require('cmp_nvim_lsp').default_capabilities()

      -- Shared LSP configuration
      local on_attach = function(client, bufnr)
        -- Enable formatting
        require("lsp-format").on_attach(client)
        
        -- Mappings
        local opts = { noremap=true, silent=true, buffer=bufnr }
        vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
        vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
        vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
        vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
        vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
        vim.keymap.set('n', '<space>wl', function()
          print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end, opts)
        vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
        vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
        vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, opts)
        vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
      end

      -- TypeScript
      lspconfig.tsserver.setup({
        capabilities = capabilities,
        on_attach = on_attach,
      })

      -- Lua
      lspconfig.lua_ls.setup({
        capabilities = capabilities,
        on_attach = on_attach,
        settings = {
          Lua = {
            diagnostics = {
              globals = { 'vim' },
            },
          },
        },
      })

      -- Nix
      lspconfig.nil_ls.setup({
        capabilities = capabilities,
        on_attach = on_attach,
      })

      -- Markdown
      lspconfig.marksman.setup({
        capabilities = capabilities,
        on_attach = on_attach,
      })
    '';
  };
}