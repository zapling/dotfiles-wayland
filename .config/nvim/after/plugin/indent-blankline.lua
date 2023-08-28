
vim.g.indent_blankline_filetype = {'yaml', 'yml', 'html'}

vim.cmd [[hi IndentBlanklineChar guifg=#504945 gui=nocombine]]

require("indent_blankline").setup({})
