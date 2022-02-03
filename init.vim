
nnoremap <Space> <Nop>
map <Space> <Leader>

" some polyglot is bad
let g:polyglot_disabled = ['asciidoc']

" vim-plug plugins
call plug#begin(stdpath('data') . '/plugged')

Plug 'vim-airline/vim-airline'

Plug 'airblade/vim-gitgutter'

Plug 'sheerun/vim-polyglot'
Plug 'habamax/vim-asciidoctor'
Plug 'dracula/vim', { 'as': 'dracula' }

call plug#end()

syntax on
filetype plugin indent on

" Terminal color compatibility
"set t_Co=256

colorscheme dracula
set background=dark

" Desired line length marker
"set textwidth=100
let &colorcolumn=100

" General options
set sw=4
set ts=4
set smarttab
set expandtab

" Automatically  tabs to the same leve as
" the previous line
set autoindent

" Remember the last position of the cursor in a file.
if has("autocmd")
    au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
    au BufNewFile,BufRead *.c   set filetype=c.doxygen
    au BufNewFile,BufRead *.h   set filetype=c.doxygen
    au BufNewFile,BufRead *.cc   set filetype=cpp.doxygen
    autocmd FileType python setlocal formatoptions+=ro
endif

set number

" IndentLine visible leading spaces
"let g:indentLine_leadingSpaceChar = '·'
"let g:indentLine_leadingSpaceEnabled = 1

" vim-airline buffer tabs at top of screen.
let g:airline#extensions#tabline#buffer_idx_mode = 1
let g:airline#extensions#tabline#enabled = 1

" Macro to clean whitespace
fun! TrimWhitespace()
    let l:save = winsaveview()
    keeppatterns %s/\s\+$//e
    call winrestview(l:save)
endfun

command! TrimWhitespace call TrimWhitespace()

" Copy/Paste to/from the system clipboard
vmap <Leader>y "+y
vmap <Leader>d "+d
nmap <Leader>p "+p
nmap <Leader>P "+P
vmap <Leader>p "+p
vmap <Leader>P "+P

" Allow navigating between buffers without saving the current buffer
set hidden

" Jump to numbered buffers
nmap <leader>1 <Plug>AirlineSelectTab1
nmap <leader>2 <Plug>AirlineSelectTab2
nmap <leader>3 <Plug>AirlineSelectTab3
nmap <leader>4 <Plug>AirlineSelectTab4
nmap <leader>5 <Plug>AirlineSelectTab5
nmap <leader>6 <Plug>AirlineSelectTab6
nmap <leader>7 <Plug>AirlineSelectTab7
nmap <leader>8 <Plug>AirlineSelectTab8
nmap <leader>9 <Plug>AirlineSelectTab9
nmap <leader>- <Plug>AirlineSelectPrevTab
nmap <leader>+ <Plug>AirlineSelectNextTab

" Left and right buffers
nmap <Leader><Left> :bp
nmap <Leader><Right> :bn

cnoreabbrev <expr> W ((getcmdtype() is# ':' && getcmdline() is# 'W')?('w'):('W'))
cnoreabbrev <expr> Q ((getcmdtype() is# ':' && getcmdline() is# 'Q')?('q'):('Q'))

set mouse=a
noremap <LeftMouse> <nop>
noremap <RightMouse> <nop>
noremap <2-LeftMouse> <nop>
noremap <2-RightMouse> <nop>
noremap <3-LeftMouse> <nop>
noremap <3-RightMouse> <nop>
noremap <4-LeftMouse> <nop>
noremap <4-RightMouse> <nop>

"match errorMsg /\s\+$/
set list listchars=tab:▷\ ,trail:·,extends:◣,precedes:◢,nbsp:○
"set listchars=tab:»\ ,extends:›,precedes:‹,nbsp:·,trail:·

" Allow tab literal insertion
inoremap <S-Tab> <C-V><Tab>

let g:netrw_fastbrowse = 0

au FileType asciidoc setlocal syntax=OFF

set nojoinspaces
set nomodeline

