set mouse=a
set number
set rnu
syntax on
set nocompatible
filetype on
filetype plugin on
filetype indent on
set cursorline
set cursorcolumn
set shiftwidth=4
set tabstop=4
set softtabstop=4
set scl="yes:2"
set expandtab
set nobackup
set scrolloff=10
set nowrap
set incsearch
set ignorecase
set showcmd
set showmode
set showmatch
set hlsearch
set splitbelow
set history=1000
set encoding=utf-8
set nobackup
set updatetime=300
set signcolumn=yes
set clipboard=unnamed,unnamedplus
set wildmenu
set list
set listchars=eol:↴,tab:\ \ ┊,extends:»,precedes:«,trail:·
set undofile
set undodir=~/.vim/undodir
let mapleader = " "
set pumheight=10
set visualbell
set t_vb=

"Lexplorer---------------------------------------------------------------- {{{
let g:netrw_keepdir = 0
let g:netrw_banner = 0
let g:netrw_browse_split = 0
let g:netrw_altv = 1
let g:netrw_winsize = 27
let g:netrw_bufsettings='wru,nr'
nnoremap <Leader>e :Ex <CR>
"}}}

"------------------------------------------------------------------------ }}}
" Copy to system clipboard
vnoremap <leader>y "+y
nnoremap <leader>Y "+Y

" " Paste from system clipboard
nnoremap <leader>p "+p
nnoremap <leader>P "+P

" QuickFixList
nnoremap <C-j> :cnext<cr>
nnoremap <C-k> :cprev<cr>

nnoremap <Leader>no :nohls<CR>
nnoremap n nzzzv
nnoremap N Nzzzv
nnoremap G Gzz
inoremap <C-c> <Esc>
nnoremap <C-d> <C-d>zz<Esc>
nnoremap <C-u> <C-u>zz<Esc>
nnoremap [b :bnext<CR>
nnoremap ]b :bprevious<CR>
nnoremap [t :tabnext<CR>
nnoremap ]t :tabprevious<CR>
nnoremap <Leader>u :MundoToggle<CR>
nnoremap <Leader>lf  gg=G<C-o><C-o>
colorscheme monokai

"}}}

"FZF--------------------------------------------------------------------  {{{
nnoremap <silent> <Leader>sb :Buffers<CR>
nnoremap <silent> <Leader>sf :Files<CR>
nnoremap <silent> <Leader>sh :Help<CR>
nnoremap <silent> <C-p> :GFiles<CR>
nnoremap <silent> <Leader>sg :Rg<CR>
nnoremap <silent> <Leader>/ :BLines<CR>
nnoremap <silent> <Leader>' :Marks<CR>
nnoremap <silent> <Leader>H :Helptags<CR>
nnoremap <silent> <Leader>hh :History<CR>
nnoremap <silent> <Leader>h: :History:<CR>
nnoremap <silent> <Leader>h/ :History/<CR>
" Git-fzf
nnoremap <silent> <Leader>gc :Commits<CR>
nnoremap <silent> <Leader>bc :BCommits<CR>
nnoremap <silent> <Leader>gh :GFiles?<CR>

function! s:build_quickfix_list(lines)
      call setqflist(map(copy(a:lines), '{ "filename": v:val, "lnum": 1 }'))
      copen
      cc
endfunction

let g:fzf_action = {
                  \ 'ctrl-q': function('s:build_quickfix_list'),
                  \ 'ctrl-t': 'tab split',
                  \ 'ctrl-x': 'split',
                  \ 'ctrl-v': 'vsplit' }
"------------------------------------------------------------------------ }}}

"Plugins----------------------------------------------------------------- {{{
call plug#begin()
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'dense-analysis/ale'
Plug 'tribela/vim-transparent'
Plug 'xianzhon/vim-code-runner'
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-commentary'
Plug 'chrisbra/Colorizer'
Plug 'sheerun/vim-polyglot'
Plug 'simnalamburt/vim-mundo'
Plug 'idanarye/vim-merginal'
Plug 'machakann/vim-highlightedyank'
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}
call plug#end()
"------------------------------------------------------------------------ }}}

"Code-Runner ------------------------------------------------------------ {{{
nmap <silent><leader>cr <plug>CodeRunner
let g:code_runner_save_before_execute = 1

let g:CodeRunnerCommandMap = {
                  \ 'python' : 'python3 $fileName',
                  \ 'cpp' : 'g++ -std=c++17 $fileName -o $fileNameWithoutExt && ./$fileNameWithoutExt',
                  \ 'c' : 'gcc $fileName -o $fileNameWithoutExt && ./$fileNameWithoutExt',
                  \ 'java' : 'javac $fileName && java $fileNameWithoutExt',
                  \ 'cs' : 'mcs $fileName && mono $fileNameWithoutExt.exe',
                  \ 'go' : 'go run $fileName',
                  \ 'javascript' : 'node $fileName',
                  \ 'typescript' : 'ts-node $fileName',
                  \}
"------------------------------------------------------------------------ }}} 

" Vim-gutter ------------------------------------------------------ {{{
nmap ]h <Plug>(GitGutterNextHunk)
nmap [h <Plug>(GitGutterPrevHunk)
nmap <Leader>hp <Plug>(GitGutterPreviewHunk)
nmap <Leader>hs <Plug>(GitGutterStageHunk)
nmap <Leader>hu <Plug>(GitGutterUndoHunk)
" }}}

" Vim-Fugitive ---------------------------------------------------- {{{
function! GitStatus()
      let [a,m,r] = GitGutterGetHunkSummary()
      return printf('+%d ~%d -%d', a, m, r)
endfunction
" }}}
nnoremap <Leader>gg :0G<CR>
nnoremap <Leader>mm :MerginalToggle<CR>

" Fugitive Conflict Resolution
nnoremap <leader>df :Gvdiff<CR>
nnoremap gdh :diffget //2<CR>
nnoremap gdl :diffget //3<CR>
"}}}

" Templates-------------------------------------------------------------- {{{
let g:highlightedyank_highlight_duration = 100
"}}}



" Templates-------------------------------------------------------------- {{{

function! ChooseTemplate()
      " Get the current file type
      let l:filetype = &filetype

      " Directory containing the templates
      let l:template_dir = expand('~/.vim/templates/' . l:filetype . '/')

      " Get the list of template files
      let l:templates = glob(l:template_dir . '*', 0, 1)

      if empty(l:templates)
            echo "No templates found for file type: " . l:filetype
            return
      endif

      " Create a menu with template options
      let l:menu = ""
      for l:idx in range(len(l:templates))
            let l:template_name = fnamemodify(l:templates[l:idx], ':t')
            let l:menu .= printf("%d. %s\n", l:idx + 1, l:template_name)
      endfor

      " Prompt the user to choose a template
      let l:choice = input(l:menu . "\nChoose a template: ")

      " Validate the choice
      if l:choice !~ '^\d\+$' || l:choice < 1 || l:choice > len(l:templates)
            echo "Invalid choice."
            return
      endif

      " Get the chosen template file
      let l:chosen_template = l:templates[l:choice - 1]

      " Read the chosen template into the buffer
      execute '0r ' . l:chosen_template
endfunction


" Keybinding to call the ChooseTemplate function
nnoremap <leader>t :call ChooseTemplate()<CR>
"}}}

"Ale -------------------------------------------------------------------- {{{
let g:ale_linters = {
\   'javascript': ['eslint'],
\   'python': ['ruff'],
\}
function! LinterStatus() abort
    let l:counts = ale#statusline#Count(bufnr(''))

    let l:all_errors = l:counts.error + l:counts.style_error
    let l:all_non_errors = l:counts.total - l:all_errors

    return l:counts.total == 0 ? 'OK' : printf(
    \   '%dW %dE',
    \   all_non_errors,
    \   all_errors
    \)
endfunction
let g:ale_floating_window_border = ['│', '─', '╭', '╮', '╯', '╰', '│', '─']
"}}}

"STATUS LINE ------------------------------------------------------------ {{{
set statusline=
set statusline+=\ %F\ \[%M\]\ %Y\ %R\ \%{LinterStatus()}
set statusline+=%=
set statusline+=\ git:\ %{GitStatus()}\ \|\ row:\ %l\ col:\ %c\ percent:\ %p%%
set laststatus=2
" }}}
