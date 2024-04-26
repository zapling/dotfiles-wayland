local M = {}

M.register_skeletons = function()
    vim.api.nvim_create_autocmd({ 'BufNewFile' }, {
        pattern = 'main.go',
        command = "silent! 0r ~/.config/nvim/skeleton/skeleton_main.go | call feedkeys('4GS')"
    })

    vim.api.nvim_create_autocmd({ 'BufNewFile' }, {
        pattern = 'index.html',
        command = "silent! 0r ~/.config/nvim/skeleton/skeleton.html",
    })
end

M.setup = function()
    M.register_skeletons()

    -- Auto equalize splits when Vim is resized
    vim.api.nvim_command('autocmd VimResized * wincmd =')

    -- Set correct syntax for .env.local
    vim.api.nvim_create_autocmd({ 'BufRead' }, {
        pattern = '.env.local',
        command = 'setlocal syntax=sh'
    })
end

return M
