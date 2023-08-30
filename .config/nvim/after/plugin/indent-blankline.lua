
vim.g.indent_blankline_filetype = {'yaml', 'yml', 'html', 'json', 'cs'}

vim.cmd [[hi IndentBlanklineChar guifg=#504945 gui=nocombine]]

require("indent_blankline").setup({})
