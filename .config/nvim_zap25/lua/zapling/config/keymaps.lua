vim.g.mapleader = vim.api.nvim_replace_termcodes('<BS>', true, true, true)

vim.keymap.set('n', '<Backspace>', '<Nop>')

vim.keymap.set("i", "<Esc>", function()
    -- Safely call snippet.stop if it exists
    if vim.snippet and vim.snippet.active() then
        vim.snippet.stop()
    end
    return "<Esc>"
end, { expr = true, noremap = true })

-- Misc
vim.keymap.set('n', '<CR>', ':noh<CR>', { desc = 'Stop search highlighting', silent = true })
vim.keymap.set('n', '<Leader>gw', ':ArgonautToggle<CR>', { desc = 'Wrap arguments', silent = true })
vim.keymap.set('n', '<C-W><CR>', function() require('winshift.lib').start_move_mode() end,
    { desc = 'Enter WIN MOVE Mode' })

-- Terminal
vim.keymap.set('t', '<Esc>', '<C-\\><C-n>',
    { desc = 'Make <Esc> in Terminal mode take you back to Normal mode', silent = true })

-- Quickfix
-- vim.keymap.set('n', ']q', ':cnext<CR>', { desc = 'Jump to the next item in quickfix list', silent = true })
-- vim.keymap.set('n', '[q', ':cprev<CR>', { desc = 'Jump to the previous item in quickfix list', silent = true })

-- Git
vim.keymap.set('n', '<Leader>vs', ':tab G<CR>', { desc = 'Open Git status in new tab', silent = true })
vim.keymap.set('n', '<Leader>vb', ':Git blame<CR>', { desc = 'Open Git blame split', silent = true })

-- Navigation
vim.keymap.set('n', '<Leader>p', ':FzfLua files<CR>', { desc = 'Search files', silent = true })
vim.keymap.set('n', '<Leader>gp', ':FzfLua git_status<CR>', { desc = 'Git status', silent = true })
vim.keymap.set('n', '<Leader>]', ':FzfLua live_grep<CR>', { desc = 'Live grep', silent = true })
vim.keymap.set('n', '<Leader>}', ':FzfLua grep_cword<CR>', { desc = 'Grep word under cursor', silent = true })
vim.keymap.set('n', '<Leader>g]', ':FzfLua resume<CR>', { desc = 'Resume last FzfLua action', silent = true })

-- LSP
vim.keymap.set('n', '<Leader>gd', ':FzfLua lsp_definitions<CR>', { desc = 'Show lsp definition', silent = true })
vim.keymap.set('n', '<Leader>gi', ':FzfLua lsp_implementations<CR>', { desc = 'Show lsp implementations', silent = true })
vim.keymap.set('n', '<Leader>gr', ':FzfLua lsp_references<CR>', { desc = 'Show lsp references', silent = true })
vim.keymap.set('n', '<Leader>k', ':LspHover<CR>', { desc = 'Show lsp hover information', silent = true })
vim.keymap.set('n', '<Leader>f', function() vim.lsp.buf.format() end, { desc = 'Format buffer with lsp' })
vim.keymap.set('n', '<Leader>r', function() vim.lsp.buf.rename() end, { desc = 'Rename with lsp' })
vim.keymap.set('n', '<Leader>c', function() vim.lsp.buf.code_action() end, { desc = 'Perform code action with lsp' })

-- Diagnostic
vim.keymap.set('n', '<Leader>gj', function() vim.diagnostic.jump({ count = 1, float = true }) end, {})
vim.keymap.set('n', '<Leader>gk', function() vim.diagnostic.jump({ count = -1, float = true }) end, {})
vim.keymap.set('n', '<Leader>d', ':DiagnosticOpenFloat<CR>', { desc = 'Open diagnostic window', silent = true })
