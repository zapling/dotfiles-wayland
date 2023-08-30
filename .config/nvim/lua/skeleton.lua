vim.api.nvim_create_autocmd({ 'BufNewFile' }, {
    pattern = 'main.go',
    command = "silent! 0r ~/.config/nvim/skeleton/skeleton_main.go | call feedkeys('4GS')"
})

vim.api.nvim_create_autocmd({ 'BufNewFile' }, {
    pattern = 'index.html',
    command = "silent! 0r ~/.config/nvim/skeleton/skeleton.html",
})
