# modules/cli/neovim/keymaps.nix
{ config, lib, pkgs, ... }:

{
  programs.neovim.extraConfig = ''
    " Set leader key to space
    let mapleader = " "

    " Better window navigation
    nnoremap <C-h> <C-w>h
    nnoremap <C-j> <C-w>j
    nnoremap <C-k> <C-w>k
    nnoremap <C-l> <C-w>l

    " Resize with arrows
    nnoremap <C-Up> :resize -2<CR>
    nnoremap <C-Down> :resize +2<CR>
    nnoremap <C-Left> :vertical resize -2<CR>
    nnoremap <C-Right> :vertical resize +2<CR>

    " Navigate buffers
    nnoremap <S-l> :bnext<CR>
    nnoremap <S-h> :bprevious<CR>

    " Stay in indent mode
    vnoremap < <gv
    vnoremap > >gv

    " Move text up and down
    nnoremap <A-j> :m .+1<CR>==
    nnoremap <A-k> :m .-2<CR>==
    vnoremap <A-j> :m '>+1<CR>gv=gv
    vnoremap <A-k> :m '<-2<CR>gv=gv

    " Better terminal navigation
    tnoremap <C-h> <C-\><C-N><C-w>h
    tnoremap <C-j> <C-\><C-N><C-w>j
    tnoremap <C-k> <C-\><C-N><C-w>k
    tnoremap <C-l> <C-\><C-N><C-w>l
    tnoremap <Esc> <C-\><C-n>

    " Telescope mappings
    nnoremap <leader>ff <cmd>Telescope find_files<cr>
    nnoremap <leader>fg <cmd>Telescope live_grep<cr>
    nnoremap <leader>fb <cmd>Telescope buffers<cr>
    nnoremap <leader>fh <cmd>Telescope help_tags<cr>
    nnoremap <leader>fc <cmd>Telescope colorscheme<cr>
    nnoremap <leader>f/ <cmd>Telescope current_buffer_fuzzy_find<cr>

    " File browser
    nnoremap <leader>fe <cmd>Telescope file_browser<cr>

    " Git mappings
    nnoremap <leader>gs <cmd>Telescope git_status<cr>
    nnoremap <leader>gc <cmd>Telescope git_commits<cr>
    nnoremap <leader>gb <cmd>Telescope git_branches<cr>

    " LSP mappings (defined in lsp.lua)
    
    " Buffer management
    nnoremap <leader>bd <cmd>Bdelete<cr>
    nnoremap <leader>bn <cmd>enew<cr>

    " Save and quit shortcuts
    nnoremap <leader>w :w<CR>
    nnoremap <leader>q :q<CR>
    
    " Clear search highlighting
    nnoremap <leader>h :noh<CR>
    
    " Toggle relative line numbers
    nnoremap <leader>n :set relativenumber!<CR>
  '';
}