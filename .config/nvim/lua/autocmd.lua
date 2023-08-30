-- Auto equalize splits when Vim is resized
vim.api.nvim_command('autocmd VimResized * wincmd =')

-- Set commentstring for terraform files
vim.api.nvim_command("autocmd FileType terraform setlocal commentstring=#\\ %s")

-- Dont highlight whitespace in the Trouble buffer
-- vim.api.nvim_command('autocmd FileType Trouble DisableWhitespace')
