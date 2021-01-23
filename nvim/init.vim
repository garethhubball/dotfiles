call plug#begin('~/.vim/plugged')

Plug 'gruvbox-community/gruvbox'
Plug 'neovim/nvim-lspconfig'
Plug 'nvim-lua/lsp_extensions.nvim'
Plug 'nvim-lua/completion-nvim'
Plug 'kyazdani42/nvim-web-devicons'
Plug 'mhinz/vim-crates'
Plug 'cespare/vim-toml'
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'

call plug#end()

let mapleader=" "
set shell=sh
sign define LspDiagnosticsSignError text= linehl= texthl=LspDiagnosticsDefaultError numhl=
sign define LspDiagnosticsSignWarning text= linehl= texthl=LspDiagnosticsDefaultWarning numhl=
sign define LspDiagnosticsSignInformation text= texthl=LspDiagnosticsSignInformation linehl= numhl=
sign define LspDiagnosticsSignHint text= texthl=LspDiagnosticsSignHint linehl= numhl=

lua <<EOF
local lspconfig = require'lspconfig'

lspconfig.rust_analyzer.setup({})

require'nvim-web-devicons'.setup {
  default = true;
}

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, {
    -- This will disable virtual text, like doing:
    -- let g:diagnostic_enable_virtual_text = 0
    virtual_text = false,

    -- This is similar to:
    -- let g:diagnostic_show_sign = 1
    -- To configure sign display,
    --  see: ":help vim.lsp.diagnostic.set_signs()"
    signs = true,

    -- This is similar to:
    -- "let g:diagnostic_insert_delay = 1"
    -- update_in_insert = false,
  }
)

require('telescope').setup({
  defaults = {
    file_ignore_patterns = {"target/.*"},
    layout_strategy = "vertical",
  }
})

EOF

syntax enable
filetype plugin indent on

if has('nvim')
	autocmd BufRead Cargo.toml call crates#toggle()
endif

colorscheme gruvbox
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
autocmd CursorHold * lua vim.lsp.diagnostic.show_line_diagnostics()

" Find files using Telescope command-line sugar.
nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>

" Goto previous/next diagnostic warning/error
nnoremap <silent> g[ <cmd>lua vim.lsp.diagnostic.goto_prev()<cr>
nnoremap <silent> g] <cmd>lua vim.lsp.diagnostic.goto_next()<cr>
nnoremap <silent> gc <cmd>lua vim.lsp.diagnostic.set_loclist()<cr>

nnoremap <silent> ca <cmd>lua vim.lsp.buf.code_action()<CR>

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

