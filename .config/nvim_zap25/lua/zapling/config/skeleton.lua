local group = vim.api.nvim_create_augroup('zapling-skeleton', { clear = true })

vim.api.nvim_create_autocmd('BufNewFile', {
    group = group,
    pattern = '.envrc',
    command = "silent! 0r ~/.config/nvim_zap25/skeleton/.envrc",
})

vim.api.nvim_create_autocmd('BufNewFile', {
    group = group,
    pattern = 'index.html',
    command = "silent! 0r ~/.config/nvim_zap25/skeleton/index.html",
})

vim.api.nvim_create_autocmd('BufNewFile', {
    group = group,
    pattern = '*.sh',
    command = 'silent! 0r ~/.config/nvim_zap25/skeleton/script.sh',
})

vim.api.nvim_create_autocmd('BufNewFile', {
    group = group,
    pattern = "main.go",
    command = 'silent! 0r ~/.config/nvim_zap25/skeleton/main.go',
})

vim.api.nvim_create_autocmd('BufNewFile', {
    group = group,
    pattern = "*.go",
    callback = function()
        local dirname = vim.fn.expand('%:p:h:t')
        vim.cmd('silent! 0r ~/.config/nvim_zap25/skeleton/file.go')
        vim.cmd('%s/PLACEHOLDER/' .. dirname)
        vim.cmd('norm 0$')
    end
})
