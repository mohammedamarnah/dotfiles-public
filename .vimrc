" ============================================================================
" VIM-PLUG PLUGIN MANAGER
" ============================================================================
" Plugins will be downloaded to ~/.vim/plugged/
" Run :PlugInstall to install plugins
" Run :PlugUpdate to update plugins
" Run :PlugClean to remove unused plugins

call plug#begin()

" ---------- Code Completion ----------
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" ---------- File Explorer ----------
Plug 'preservim/nerdtree'

" ---------- Code Commenting ----------
Plug 'tomtom/tcomment_vim'              " Toggle comments with ease

" ---------- Status Line ----------
" A light and configurable statusline/tabline
Plug 'itchyny/lightline.vim'

" ---------- Color Schemes ----------
" Install multiple popular themes - switch between them easily
Plug 'morhetz/gruvbox'                    " Warm, retro groove colors
Plug 'folke/tokyonight.nvim'             " Modern, clean Tokyo-inspired theme
Plug 'catppuccin/vim', { 'as': 'catppuccin' }  " Pastel, soothing colors
Plug 'dracula/vim', { 'as': 'dracula' }   " Popular dark theme
Plug 'arcticicestudio/nord-vim'           " Nordic-inspired clean theme

" ---------- UI Enhancements ----------
Plug 'ryanoasis/vim-devicons'             " File icons (install Nerd Font first)
Plug 'Yggdroot/indentLine'                " Display indentation levels
Plug 'airblade/vim-gitgutter'             " Show git diff in the sign column

call plug#end()

" Tab to navigate and confirm completion
inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackspace() ? "\<TAB>" :
      \ coc#refresh()

inoremap <silent><expr> <S-TAB>
      \ coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1] =~# '\s'
endfunction

" ============================================================================
" GENERAL VIM SETTINGS
" ============================================================================

" ---------- UI/Visual Settings ----------
set number                      " Show line numbers
set relativenumber              " Show relative line numbers
set cursorline                  " Highlight current line
set showcmd                     " Show command in bottom bar
set wildmenu                    " Visual autocomplete for command menu
set showmatch                   " Highlight matching parentheses
set laststatus=2                " Always show status line
set noshowmode                  " Don't show mode (lightline will show it)

" ---------- Color Scheme ----------
" Enable true colors if supported
if has('termguicolors')
  set termguicolors
endif

" Set background (dark or light)
set background=dark

" Choose your color scheme (uncomment one):
colorscheme gruvbox
" colorscheme tokyonight
" colorscheme catppuccin
" colorscheme dracula
" colorscheme nord

" Gruvbox specific settings (optional)
let g:gruvbox_contrast_dark = 'medium'  " soft, medium, or hard
let g:gruvbox_italic = 1

" ---------- Indentation & Formatting ----------
set tabstop=2                   " Number of spaces per tab
set shiftwidth=2                " Number of spaces for auto-indent
set softtabstop=2               " Number of spaces for tab in insert mode
set expandtab                   " Convert tabs to spaces
set autoindent                  " Copy indent from current line when starting new line
set smartindent                 " Smart auto-indenting

" ---------- Search Settings ----------
set incsearch                   " Search as characters are entered
set hlsearch                    " Highlight search matches
set ignorecase                  " Case insensitive searching
set smartcase                   " Case sensitive if uppercase is used

" ---------- Performance ----------
set lazyredraw                  " Don't redraw while executing macros

" ============================================================================
" PLUGIN CONFIGURATIONS
" ============================================================================

" ---------- Lightline (Status Bar) ----------
let g:lightline = {
      \ 'colorscheme': 'gruvbox',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'gitbranch', 'readonly', 'filename', 'modified' ] ]
      \ },
      \ 'component_function': {
      \   'gitbranch': 'FugitiveHead'
      \ },
      \ }
" Note: Change 'gruvbox' to match your colorscheme
" Options: 'gruvbox', 'nord', 'dracula', 'tokyonight', etc.

" ---------- IndentLine ----------
let g:indentLine_char = '│'     " Character to use for indent lines
let g:indentLine_enabled = 1    " Enable by default

" ---------- NERDTree Configuration ----------
" Toggle NERDTree with Tab in normal mode (doesn't conflict with coc.nvim)
nnoremap <Tab> :NERDTreeToggle<CR>

" NERDTree default mappings (work when cursor is in NERDTree window):
" - Press 'o' to open a file or directory (default NERDTree)
" - Press 'm' then 'a' to create a new file (NERDTree menu)
" - Press 'gt' to go to next tab (default Vim)
" - Press 'gT' to go to previous tab (default Vim)

" Custom mapping: Press 'n' in NERDTree to create a new file
autocmd FileType nerdtree nmap <buffer> n ma

" NERDTree UI settings
let NERDTreeShowHidden=1        " Show hidden files by default
let NERDTreeMinimalUI=1         " Minimal UI (no help text)
let NERDTreeDirArrows=1         " Use arrows instead of + and ~

" Close NERDTree when opening a file
let NERDTreeQuitOnOpen=1

" Start NERDTree when Vim starts with a directory argument
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists('s:std_in') |
    \ execute 'NERDTree' argv()[0] | wincmd p | enew | execute 'cd '.argv()[0] | endif

" Exit Vim if NERDTree is the only window remaining
autocmd BufEnter * if winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif

" ---------- Git Gutter ----------
set updatetime=100              " Update git gutter more frequently (default is 4000ms)

" ============================================================================
" CUSTOM KEY MAPPINGS
" ============================================================================
" Note: <Leader> key is '\' by default. You can change it with:
" let mapleader = " "            " Use space as leader key

" ---------- TComment - Toggle comments with // ----------
nnoremap // :TComment<CR>
vnoremap // :TComment<CR>

" Clear search highlighting with Escape
nnoremap <silent> <Esc> :nohlsearch<CR>

" Quick save
nnoremap <C-s> :w<CR>
inoremap <C-s> <Esc>:w<CR>a

" ============================================================================
" NOTES FOR FUTURE CONFIGURATION
" ============================================================================
"
" To change color scheme:
"   1. Uncomment a different colorscheme line above
"   2. Update lightline colorscheme to match
"   3. Run :source ~/.vimrc or restart Vim
"
" To install plugins after adding new ones:
"   1. Add the plugin line in the plug#begin() section
"   2. Run :PlugInstall in Vim
"
" NERDTree useful commands (when cursor is in NERDTree):
"   m    - Open menu for file operations (create, delete, move, etc.)
"   n    - Create new file (via menu)
"   o    - Open file/directory
"   s    - Open file in vertical split
"   i    - Open file in horizontal split
"   t    - Open file in new tab
"   R    - Refresh directory
"   cd   - Change Vim's working directory to selected directory
"   ?    - Toggle help
"
" Tab navigation (built-in Vim commands):
"   gt   - Go to next tab
"   gT   - Go to previous tab
"   :tabnew - Create new tab
"   :tabclose - Close current tab
"
