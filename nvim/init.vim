call plug#begin('~/.vim/plugged')

Plug 'arcticicestudio/nord-vim'
Plug 'neovim/nvim-lspconfig'
Plug 'nvim-lua/lsp_extensions.nvim'
Plug 'nvim-lua/completion-nvim'
Plug 'nvim-lua/diagnostic-nvim'
Plug 'preservim/nerdtree'
Plug 'ryanoasis/vim-devicons'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'mhinz/vim-crates'
Plug 'cespare/vim-toml'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

call plug#end()

set shell=sh
sign define LspDiagnosticsErrorSign text= linehl= texthl=LspDiagnosticsErrorSign numhl=
sign define LspDiagnosticsWarningSign text= linehl= texthl=LspDiagnosticsWarningSign numhl=
lua <<EOF
local nvim_lsp = require'nvim_lsp'

local on_attach = function(client)
	require'completion'.on_attach(client)
	require'diagnostic'.on_attach(client)
end

nvim_lsp.rust_analyzer.setup({ on_attach=on_attach })

EOF

syntax enable
filetype plugin indent on

autocmd vimenter * NERDTree
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
map <C-n> :NERDTreeToggle<CR>

if has('nvim')
	autocmd BufRead Cargo.toml call crates#toggle()
endif

colorscheme nord
set number
set relativenumber
set signcolumn=yes

set completeopt=menuone,noinsert,noselect
set shortmess+=c

let g:diagnostic_enable_virtual_text = 1
let g:diagnostic_trimmed_virtual_text = '40'
" Don't show diagnostics while in insert mode
let g:diagnostic_insert_delay = 1

" Set updatetime for CursorHold
" 300ms of no cursor movement to trigger CursorHold
set updatetime=300
" Show diagnostic popup on cursor hold
autocmd CursorHold * lua vim.lsp.util.show_line_diagnostics()

nnoremap <silent> ff <cmd>GFiles<cr>
nnoremap <silent> fg <cmd>Rg<cr>

" Goto previous/next diagnostic warning/error
nnoremap <silent> g[ <cmd>PrevDiagnosticCycle<cr>
nnoremap <silent> g] <cmd>NextDiagnosticCycle<cr>

inoremap <silent><expr> <TAB>
			\ pumvisible() ? "\<C-n>" :
			\ <SID>check_back_space() ? "\<TAB>" :
			\ completion#trigger_completion()

function! s:check_back_space() abort
	let col = col('.') - 1
	return !col || getline('.')[col - 1] =~ '\s'
endfunction

" Enable type inlay hints
autocmd CursorMoved,InsertLeave,BufEnter,BufWinEnter,TabEnter,BufWritePost *
\ lua require'lsp_extensions'.inlay_hints{ prefix = ':', highlight = 'Underlined' }

" highlight Comment ctermfg=Yellow guifg=Yellow
