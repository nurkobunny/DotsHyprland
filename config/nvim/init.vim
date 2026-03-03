:set number
:set relativenumber
:set autoindent
:set tabstop=4
:set shiftwidth=4
:set smarttab
:set softtabstop=4
:set mouse=a

call plug#begin()
Plug 'sainnhe/gruvbox-material'
Plug 'catppuccin/nvim'
Plug 'rebelot/kanagawa.nvim'
Plug 'nvim-lualine/lualine.nvim'
Plug 'neanias/everforest-nvim'
Plug 'preservim/nerdtree'
Plug 'rose-pine/neovim'
Plug 'nvim-tree/nvim-web-devicons'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'ap/vim-css-color'
call plug#end()

lua << END
require('rose-pine').setup({
    variant = 'dawn',
})
require('catppuccin').setup({
	flavour = 'latte',
})
END

colorscheme rose-pine-dawn

lua << END
require('lualine').setup {
  options = {
	  theme = 'rose-pine'
  }
}
END

nnoremap <C-t> :NERDTreeToggle<CR>
