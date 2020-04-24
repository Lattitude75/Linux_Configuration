call plug#begin('~/.local/share/nvim/plugged')
"""""""""""""""""""""""""""""""""
" nvim auto complete
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'zchee/deoplete-jedi'

" Language server client
Plug 'autozimu/LanguageClient-neovim', {
    \ 'branch': 'next',
    \ 'do': 'bash install.sh',
    \ }

" for a colourfull toolbar
Plug 'vim-airline/vim-airline'

" automatic quote bracket completion
Plug 'jiangmiao/auto-pairs'

" auto format
Plug 'sbdchd/neoformat'

" syntax and code checking
Plug 'neomake/neomake'

" for Julia
" syntax checking for julia
Plug 'zyedidia/julialint.vim'
" julia vim package
Plug 'JuliaEditorSupport/julia-vim'

" to highlight before you copy
Plug 'machakann/vim-highlightedyank'

" folding the code
Plug 'tmhedberg/SimpylFold'

" theme for neovim
Plug 'drewtempelmeyer/palenight.vim'

" Better Visual Guide
Plug 'Yggdroot/indentLine'

" Commenter
Plug 'scrooloose/nerdcommenter'

call plug#end()
"""""""""""""""""""""""""""""""""
" configuration

" using the system clipboard
set clipboard+=unnamedplus


" Use deoplete.
let g:deoplete#enable_at_startup = 1
autocmd InsertLeave,CompleteDone * if pumvisible() == 0 | pclose | endif

" julia
let g:default_julia_version = '1.0'

" language server
let g:LanguageClient_autoStart = 1
let g:LanguageClient_serverCommands = {
\   'julia': ['julia', '--startup-file=no', '--history-file=no', '-e', '
\       using LanguageServer;
\       using Pkg;
\       import StaticLint;
\       import SymbolServer;
\       env_path = dirname(Pkg.Types.Context().env.project_file);
\       debug = false; 
\       
\       server = LanguageServer.LanguageServerInstance(stdin, stdout, debug, env_path, "", Dict());
\       server.runlinter = true;
\       run(server);
\   ']
\ }

" command for neomake
let g:neomake_python_enabled_makers = ['flake8']
call neomake#configure#automake('nrwi', 500) " to make sure that it checks automatically whenever the file is written
let g:neomake_open_list = 2

" theme activation
set background=dark
colorscheme palenight
let g:airline_theme = "palenight"
set termguicolors

" split navigations
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>
" setting the default window split
set splitbelow
set splitright
" filetype plugin
filetype plugin on
" mouse support
set mouse=a

" set numbers
set nu
" Set min window width
set winminwidth=10 
" remove netrw banner
let g:netrw_banner = 0
""""""""""""""""""""""""""""""""""""""""""""""
""""""""""""""Code for an IDE setup""""""""""""""
" To come up with a setup of an editor an associated ipython REPL and a
" filebrowser

" enable checking all lines if they are commented or not
let g:NERDToggleCheckAllLines = 1

func! PythonIDE() abort " Function to start the IDE
	if &ft=='python'
		exe "let $FILE_IDE=@% | vnew | term ipython"
		exe "set nu!"
		let g:netrw_mousemaps=0
		exe "Sex ./ | resize 10"
		exe "1 wincmd w"

		" to make it easier to exit the terminal
		:tnoremap <Esc> <C-\><C-n>
		" shift between python terminal and editor
		:tmap <F3> <Esc>:1 wincmd w<ENTER>
		:map <F3> <Esc>:call Terminal_win_switch('python')<ENTER>
		:map <F5> <Esc>:call Code_run('python')<ENTER>
		" Keybinding to open the file from the netrw explorer
		nmap <C-o> :call OpenFileInTextWindow('python')<CR>
	else
		echom "Not a Python file"
	endif
endf


func! JuliaIDE() abort " Function to start the IDE
	exe "let $FILE_IDE = @% | vnew | term julia"
	exe "set nu!"
	let g:netrw_mousemaps=0
	exe "Sex ./ | resize 10"
	exe "1 wincmd w"

	" to make it easier to exit the terminal
	:tnoremap <Esc> <C-\><C-n>
	" shift between python terminal and editor
	:tmap <F3> <Esc>:1 wincmd w<ENTER>
	:map <F3> <Esc>:call Terminal_win_switch('julia')<ENTER>
	:map <F5> <Esc>:call Code_run('julia')<ENTER>
	" Keybinding to open the file from the netrw explorer
	nmap <C-o> :call OpenFileInTextWindow('julia')<CR>
endf

func! Terminal_win_switch(var) abort
	let lang = a:var
	let w_term = bufwinnr('term')
	let w_text = bufwinnr('.py')
	if &ft=='python'
		exe w_term. 'wincmd w'
		call feedkeys('i')
	elseif bufwinnr('%')==w_term
		exe w_text. 'wincmd w'
	else
		exe w_term. 'wincmd w'
		call feedkeys('i')
	end

endf
func! Code_run(var) abort " Function for running the file in the terminal
	let lang = a:var
	let w_term = bufwinnr('term')
	exe 'w | '. w_term .' wincmd w'
	if lang=='python'
		call feedkeys('irun '. $FILE_IDE )
	elseif lang=='julia'
		call feedkeys('iinclude("'. $FILE_IDE . '")')
	endif
	" call feedkeys("\<ENTER>\<Esc>:1 wincmd w\<ENTER>")
	call feedkeys("\<ENTER>")
endf

" shortcut to launch the IDE for a specific file
func! IDE() abort
	if &ft=='python'
		call PythonIDE()
	elseif &ft=='julia'
		call JuliaIDE()
	else
		echom 'Not a Python or a Julia File'
	endif
endf

" Shortcut to launch the 'IDE mode'
nnoremap <C-i> <Esc>:call IDE()<ENTER>


" function to open the file from netrw directly to the open text window
function! OpenFileInTextWindow(var) abort
    let lang = a:var
    if &ft == 'netrw'
	let cfile = expand("<cfile>")
	exe "1 wincmd w"
	execute "edit " . cfile
	if lang=='julia'
		exe "let $FILE_JL = @%"
	elseif lang=='python'
		exe "let $FILE_PY = @%"
	endif
    else
	echom 'Not a netrw window.'
    end
endfunction
