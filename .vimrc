syntax on
set ai
set belloff=all
colorscheme peachpuff
set mouse=a
augroup SaveLeave
	autocmd!
	autocmd WinLeave * :wa
augroup END
