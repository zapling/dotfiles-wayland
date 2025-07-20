vim.opt.mouse = {}

-- https://github.com/neovim/neovim/issues/32660
vim.g._ts_force_sync_parsing = true

vim.o.updatetime = 250

vim.opt.backupdir = os.getenv('HOME') .. '/.vim/backup'
vim.opt.directory = os.getenv('HOME') .. '/.vim/backupf'

vim.opt.incsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.inccommand = 'nosplit'

vim.opt.relativenumber = true
vim.opt.number = true
vim.opt.wrap = false

vim.opt.cursorline = true
vim.opt.cursorlineopt = { 'number' }

vim.opt.colorcolumn = '100'
vim.opt.signcolumn = 'yes'
vim.opt.showmode = false

vim.opt.textwidth = 0
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.formatoptions = vim.opt.formatoptions
    - "a" -- No automatic format of paragraphs.
    - "t" -- No automatic wrapping of text.
    - "c" -- No automatic wrapping of comments.
    - "o" -- No automatic insert of comment leader on 'o' or 'O' motion.
    + "r" -- Automatic insert of comment leader on <Enter> in Insert mode.
    + "j" -- Automatic removal of comment leader on 'j' motion.
