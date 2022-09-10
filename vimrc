call plug#begin()

Plug 'preservim/nerdtree'
Plug 'mattn/emmet-vim'
Plug 'Yggdroot/indentLine'
Plug 'MaxMEllon/vim-jsx-pretty'
Plug 'moll/vim-bbye'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-abolish'
Plug 'stephpy/vim-php-cs-fixer'
Plug 'honza/vim-snippets'
Plug 'SirVer/ultisnips'
Plug 'vimwiki/vimwiki'
Plug 'tomasr/molokai'

call plug#end()
set encoding=utf-8

set nocompatible
filetype plugin on
syntax on

" Theme
set background=dark
set nu
colorscheme molokai
highlight LineNr ctermfg=gray ctermbg=121212

set mouse=vic
let &t_SI="\e[5 q"
let &t_EI="\e[2 q"

set cursorline
nnoremap <Leader>l :set cursorline!<CR>
highlight CursorLineNr gui=bold guifg=DarkRed guibg=#000000

" Pdf View
:command! -complete=file -nargs=1 Rpdf :r !pdftotext -nopgbrk <q-args> -
:command! -complete=file -nargs=1 Rpdf :r !pdftotext -nopgbrk <q-args> - |fmt -csw78

" Indentation config
set tabstop=4
set expandtab
set shiftwidth=4
set autoindent
set smartindent
set cindent

inoremap {<CR> {<CR>}<ESC>O
inoremap {;<CR> {<CR>};<ESC>O

" Snippets config
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"
let g:UltiSnipsEditSplit="vertical"

" NERDTree config
nnoremap <C-t> :NERDTreeToggle<CR>
nnoremap <C-f> :NERDTreeFind<CR>
autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif
autocmd BufWinEnter * if getcmdwintype() == '' | silent NERDTreeMirror | endif

" vim-startify config
let g:startify_bookmarks = [
			\ { 'g': '~/git' },
			\ { 'v': '~/.vimrc' },
			\ ]

" vim-project config
let g:project_enable_welcome = 0
let g:project_use_nerdtree = 1

" Compilation
autocmd FileType cpp nnoremap   <leader>ç   :!g++ -lm -lcrypt -O2 -std=c++11 -pipe -DONLINE_JUDGE %<CR>
if has('gui_running')
    autocmd FileType cpp nnoremap   <leader>;   :!xterm -e "time ./a.out; read"<CR><CR>
    autocmd FileType cpp nnoremap   <leader>.   :!xterm -e "for f in %:r.*.test; do echo \"TEST: $f\"; time ./a.out < $f; done; read"<CR><CR>
else
    autocmd FileType cpp nnoremap   <leader>;   :!./a.out<CR>
    autocmd FileType cpp nnoremap   <leader>~   :!time ./a.out<CR>
    autocmd FileType cpp nnoremap   <leader>.   :!for f in %:r.*.test; do echo "TEST: $f"; ./a.out < $f; done<CR>
endif
