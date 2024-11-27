{ config, lib, pkgs, ... }:

{
  imports = [
    ./plugins.nix    # Plugin configurations
    ./theme.nix      # Theme integration
    ./keymaps.nix    # Key mappings
  ];

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;

    # Configure Neovim options
    extraConfig = ''
      " Basic Settings
      set number relativenumber
      set termguicolors
      set mouse=a
      set hidden
      set noshowmode
      set noshowcmd
      set shortmess+=F
      set signcolumn=yes
      set updatetime=300
      set timeoutlen=500
      set completeopt=menu,menuone,noselect
      set splitbelow splitright
      set conceallevel=0
      set fileencoding=utf-8
      set pumheight=10
      set cmdheight=1
      set expandtab
      set shiftwidth=2
      set tabstop=2
      set smartindent
      set autoindent
      set laststatus=3
      set wrap
      set scrolloff=8
      set sidescrolloff=8
      set ruler
      set clipboard+=unnamedplus
      set ignorecase
      set smartcase
      set nobackup
      set nowritebackup
      set undofile
      set undodir=$HOME/.local/share/nvim/undo
      set spelllang=en
      set title
      
      " Automatically create parent directories when saving
      augroup Mkdir
        autocmd!
        autocmd BufWritePre * call mkdir(expand("<afile>:p:h"), "p")
      augroup END

      " Highlight on yank
      augroup YankHighlight
        autocmd!
        autocmd TextYankPost * silent! lua vim.highlight.on_yank{higroup="IncSearch", timeout=200}
      augroup END

      " Return to last edit position when opening files
      autocmd BufReadPost *
        \ if line("'\"") > 0 && line("'\"") <= line("$") |
        \   exe "normal! g`\"" |
        \ endif
    '';

    # Install basic plugins that don't need extra configuration
    plugins = with pkgs.vimPlugins; [
      # Editing
      vim-surround              # Surroundings manipulation
      vim-repeat               # Repeat plugin maps
      vim-commentary           # Comment stuff out
      nvim-autopairs          # Auto close brackets
      vim-sleuth              # Detect indentation

      # Navigation
      vim-rooter              # Change working directory to project root
      vim-eunuch             # Unix shell commands
      vim-fugitive           # Git integration
      
      # UI Improvements
      vim-lastplace          # Remember last editing position
      vim-illuminate         # Highlight word under cursor
      which-key-nvim        # Key binding hints
      lualine-nvim          # Status line
      nvim-web-devicons     # File icons
    ];

    # Extra packages needed for some plugins
    extraPackages = with pkgs; [
      # Language servers
      nodePackages.typescript-language-server
      nodePackages.vscode-langservers-extracted
      lua-language-server
      nil                     # Nix LSP
      marksman                # Markdown LSP
      
      # Tools
      ripgrep                # Required for telescope
      fd                     # Required for telescope
      tree-sitter           # Required for treesitter
      
      # Formatters & Linters
      nixfmt                # Nix formatter
      stylua                # Lua formatter
      prettierd             # JavaScript/TypeScript formatter
      eslint_d              # JavaScript/TypeScript linter
    ];
  };

  # Ensure config directory exists
  home.file.".config/nvim" = {
    recursive = true;
    source = ./config;
  };

  # Add runtime path for pywal colorscheme
  home.file.".config/nvim/colors/wal.vim".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.cache/wal/colors-wal.vim";
}