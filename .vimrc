set nocompatible
filetype off

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'VundleVim/Vundle.vim'
Plugin 'luochen1990/rainbow'
Plugin 'mxw/vim-jsx'
Plugin 'gmarik/vundle'
Plugin 'tpope/vim-fugitive'
Plugin 'tpope/vim-rails'
Plugin 'SuperTab'
Plugin 'file-line'
Plugin 'grep.vim'
Plugin 'Lokaltog/vim-powerline'
Plugin 'Syntastic'
Plugin 'The-NERD-tree'
Plugin 'airblade/vim-gitgutter'
Plugin 'kien/ctrlp.vim'
Plugin 'ntpeters/vim-better-whitespace'
Plugin 'Solarized'
Plugin 'tomtom/tcomment_vim'
Plugin 'pangloss/vim-javascript'
Plugin 'gregsexton/MatchTag'
Plugin 'guns/vim-clojure-static'
Plugin 'tpope/vim-fireplace'
Plugin 'venantius/vim-eastwood'
Plugin 'venantius/vim-cljfmt'
Plugin 'rhysd/vim-crystal'
Plugin 'milch/vim-fastlane'
Plugin 'OmniSharp/omnisharp-vim'
Plugin 'tpope/vim-dispatch'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required

let mapleader=','
nnoremap // :TComment<CR>
vnoremap // :TComment<CR>

au FileType javascript :call SetLocalEslint()

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

if has("vms")
  set nobackup    " do not keep a backup file, use versions instead
else
  set backup    " keep a backup file
endif
set history=50    " keep 50 lines of command line history
set ruler   " show the cursor position all the time
set showcmd   " display incomplete commands
set incsearch   " do incremental searching

" Don't use Ex mode, use Q for formatting
map Q gq

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
inoremap <C-U> <C-G>u<C-U>
noremap j gj
noremap k gk

" In many terminal emulators the mouse works just fine, thus enable it.
if has('mouse')
  set mouse=a
endif

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
endif

" Only do this part when compiled with support for autocommands.
if has("autocmd")

  " Enable file type detection.
  " Use the default filetype settings, so that mail gets 'tw' set to 72,
  " 'cindent' is on in C files, etc.
  " Also load indent files, to automatically do language-dependent indenting.
  filetype plugin indent on

  " Put these in an autocmd group, so that we can delete them easily.
  augroup vimrcEx
  au!

  " For all text files set 'textwidth' to 78 characters.
  autocmd FileType text setlocal textwidth=78

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  " Also don't do it when the mark is in the first line, that is the default
  " position when opening a file.
  autocmd BufReadPost *
    \ if line("'\"") > 1 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif

  augroup END

else

  set autoindent    " always set autoindenting on

endif " has("autocmd")

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis
      \ | wincmd p | diffthis
endif

nnoremap <silent> <Space> :nohlsearch<Bar>:echo<CR>
nnoremap <C-h> gT
nnoremap <C-l> gt
set nu

" map <F3> :execute "noautocmd vimgrep /" . expand("<cword>") . "/gj **/*." .  expand("%:e") <Bar> cw<CR>
map <F3> :execute "noautocmd vimgrep /" . expand("<cword>") . "/gj **/*." .  expand("%:e") <Bar> cw

function! CmdLine(str)
  exe "menu Foo.Bar :" . a:str
  emenu Foo.Bar
  unmenu Foo
endfunction

" From an idea by Michael Naumann
function! VisualSearch(direction) range
  let l:saved_reg = @"
  execute "normal! vgvy"

  let l:pattern = escape(@", '\\/.*$^~[]')
  let l:pattern = substitute(l:pattern, "\n$", "", "")

  if a:direction == 'b'
    execute "normal ?" . l:pattern . "^M"
  elseif a:direction == 'gv'
    "call CmdLine("noautocmd vimgrep " . '/'. l:pattern . '/gj' . ' **/*')
    "execute "noautocmd vimgrep " . '/'. l:pattern . '/gj' . ' **/*'
    execute "Rgrep -i " . l:pattern
  elseif a:direction == 'f'
    execute "normal /" . l:pattern . "^M"
  endif

  let @/ = l:pattern
  let @" = l:saved_reg
endfunction

vnoremap <silent> * :call VisualSearch('b')<CR>
vnoremap <silent> # :call VisualSearch('f')<CR>
vnoremap <silent> gv :call VisualSearch('gv') <Bar> cw<CR>

set undofile
set undodir=~/.vim/undodir
set undolevels=1000 "maximum number of changes that can be undone
set undoreload=10000 "maximum number lines to save for undo on a buffer reload

map <Tab> :NERDTreeFind<CR>
map <C-n> :NERDTreeToggle<CR>
let NERDTreeShowBookmarks=1
set tabstop=2
set shiftwidth=2
set expandtab

set nobackup

autocmd InsertEnter * syn clear EOLWS | syn match EOLWS excludenl /\s\+\%#\@!$/
autocmd InsertLeave * syn clear EOLWS | syn match EOLWS excludenl /\s\+$/
highlight EOLWS ctermbg=red guibg=red

""""""""""""""""""""""""""""""
" => Statusline
""""""""""""""""""""""""""""""
" Always hide the statusline
set laststatus=2

" Format the statusline
set statusline=\ %{HasPaste()}%F%m%r%h\ %w\ \ CWD:\ %r%{CurDir()}%h\ \ \ Line:\ %l/%L:%c


function! CurDir()
    let curdir = substitute(getcwd(), '/home/waleed/', "~/", "g")
    return curdir
endfunction

function! HasPaste()
    if &paste
        return 'PASTE MODE  '
    else
        return ''
    endif
endfunction

set t_Co=256 " Explicitly tell vim that the terminal supports 256 colors

let g:gitgutter_max_signs = 1500

let g:rainbow_active = 1 "0 if you want to enable it later via :RainbowToggle
let g:rainbow_conf = {
      \   'guifgs': ['royalblue3', 'darkorange3', 'seagreen3', 'firebrick'],
      \   'ctermfgs': ['darkyellow', 'darkgreen', 'red', 'darkcyan'],
      \   'operators': '_,_',
      \   'parentheses': ['start=/(/ end=/)/ fold', 'start=/\[/ end=/\]/ fold', 'start=/{/ end=/}/ fold'],
      \   'separately': {
      \       '*': {},
      \       'tex': {
      \           'parentheses': ['start=/(/ end=/)/', 'start=/\[/ end=/\]/'],
      \       },
      \       'lisp': {
      \           'guifgs': ['royalblue3', 'darkorange3', 'seagreen3', 'firebrick', 'darkorchid3'],
      \       },
      \       'vim': {
      \           'parentheses': ['start=/(/ end=/)/', 'start=/\[/ end=/\]/', 'start=/{/ end=/}/ fold', 'start=/(/ end=/)/ containedin=vimFuncBody', 'start=/\[/ end=/\]/ containedin=vimFuncBody', 'start=/{/ end=/}/ fold containedin=vimFuncBody'],
      \       },
      \       'html': 0,
      \       'css': 0,
      \   }
      \}

let g:Powerline_symbols = 'unicode'

au BufNewFile,BufRead *.ejs set filetype=html

autocmd QuickFixCmdPost *grep* cwindow
au FileType python  set tabstop=4 shiftwidth=4 textwidth=140 softtabstop=4

hi CursorColumn cterm=NONE ctermbg=black
"ctermfg=white guibg=darkred guifg=white
set cursorcolumn


autocmd BufNewFile,BufReadPost *.md set filetype=markdown

syntax enable
set background=dark
colorscheme solarized

set relativenumber
set number
set autoindent
set wildmenu

set wildignore+=*/tmp/*
set wildignore+=.git,.svn,CVS
set wildignore+=*.o,*.a,*.class,*.obj,*.so,*~,*.swp,*.zip
set wildignore+=*.log,*.log.*
set wildignore+=*.jpg,*.png,*.xpm,*.gif,*.pdf

" Ignore case if search pattern is all lowercase, case-sensitive otherwise
set ignorecase
set smartcase

" Don't use ignorecase for * and #
:nnoremap * /\C\<<C-R>=expand('<cword>')<CR>\><CR>
:nnoremap # ?\C\<<C-R>=expand('<cword>')<CR>\><CR>

let g:jsx_ext_required = 0

set statusline+=%#warningmsg#

set statusline+=%{SyntasticStatuslineFlag()}

set statusline+=%*

let g:syntastic_always_populate_loc_list = 1

let g:syntastic_loc_list_height = 5

let g:syntastic_auto_loc_list = 0

let g:syntastic_check_on_open = 1

let g:syntastic_check_on_wq = 1

let g:syntastic_javascript_checkers = ['eslint']

let g:syntastic_ruby_checkers = ['rubocop']

let g:syntastic_cs_checkers = ['code_checker']

highlight link SyntasticErrorSign SignColumn

highlight link SyntasticWarningSign SignColumn

highlight link SyntasticStyleErrorSign SignColumn

highlight link SyntasticStyleWarningSign SignColumn

let g:OmniSharp_server_path = '/Users/sh3rawi/workspace/omnisharp-roslyn/artifacts/publish/OmniSharp.Http/mono/OmniSharp.exe'

let g:Omnisharp_stop_server = 2

let g:Omnisharp_start_server = 0

autocmd Filetype php setlocal ts=4 sw=4 sts=0 expandtab
autocmd Filetype cs setlocal ts=2 sw=2 sts=0 expandtab


fun! SetLocalEslint()
  let lcd = fnameescape(getcwd())
  silent! exec "lcd" expand('%:p:h')
  let local_eslint = finddir('node_modules', '.;') . '/.bin/eslint_d'

  if matchstr(local_eslint, "^\/\\w") == ''
    let local_eslint = fnameescape(getcwd()) . "/" . local_eslint
  endif

  if executable(local_eslint)
    let b:syntastic_javascript_eslint_exec = local_eslint
  endif

  exec "lcd" lcd
endfun
