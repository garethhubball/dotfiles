call plug#begin('~/.vim/plugged')

Plug 'arcticicestudio/nord-vim'
Plug 'neovim/nvim-lspconfig'
Plug 'nvim-lua/lsp_extensions.nvim'
Plug 'nvim-lua/completion-nvim'
Plug 'nvim-lua/diagnostic-nvim'

call plug#end()

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

" Goto previous/next diagnostic warning/error
nnoremap <silent> g[ <cmd>PrevDiagnosticCycle<cr>
nnoremap <silent> g] <cmd>NextDiagnosticCycle<cr>

" Enable type inlay hints
autocmd CursorMoved,InsertLeave,BufEnter,BufWinEnter,TabEnter,BufWritePost *
\ lua require'lsp_extensions'.inlay_hints{ prefix = ':', highlight = 'Underlined' }

" highlight Comment ctermfg=Yellow guifg=Yellow
