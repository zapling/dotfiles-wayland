local M = {}

M.setup = function()
    local map = vim.api.nvim_set_keymap

    -- basic rebinds
    map('n', '<Backspace>', '<Nop>', { noremap = true })
    -- map('n', '<Space>', '<Nop>', {noremap = true})
    map('n', '<Backspace>', '<Leader>', {})
    -- map('n', '<Space>', '<LocalLeader>', {})
    map('n', '<CR>', ':noh<CR>', { noremap = true })
    map('t', '<Esc>', '<C-\\><C-n>', { noremap = true })

    -- I never use this, only accidentialy press it.
    -- Use the other default bind "g Q" if you ever need it.
    map('n', 'Q', '<Nop>', { noremap = true })

    -- quickfix
    map('n', ']q', ':cnext<CR>', { noremap = true, silent = true })
    map('n', '[q', ':cprev<CR>', { noremap = true, silent = true })

    -- git
    map('', '<Leader>vs', ':tab G<CR>', {})
    map('', '<Leader>vf', ':diffget //2<CR>', {})
    map('', '<Leader>vj', ':diffget //3<CR>', {})
    map('', '<Leader>vb', ':Git blame<CR>', {})

    -- argwrap
    -- TODO: can this be solved by Treesitter?
    map('', '<Leader>gw', ':ArgWrap<CR>', {})

    map('', '<Leader>gd', '<Cmd>lua require\'telescope.builtin\'.lsp_definitions({ file_ignore_patterns = {}})<CR>',
        { silent = true })

    map('', '<Leader>gi', '<Cmd>lua require\'telescope.builtin\'.lsp_implementations({ file_ignore_patterns = {}})<CR>',
        { silent = true })

    map('', '<Leader>gr', '<Cmd>lua require\'telescope.builtin\'.lsp_references()<CR>', { silent = true })
    map('', '<Leader>gj', '<Cmd>lua vim.diagnostic.goto_next({float = true})<CR>', { silent = true })
    map('', '<Leader>gJ',
        '<Cmd>lua vim.diagnostic.goto_next({float = true, severity = vim.diagnostic.severity.ERROR})<CR>',
        { silent = true })
    map('', '<Leader>gk', '<Cmd>lua vim.diagnostic.goto_prev({float = true})<CR>', { silent = true })
    map('', '<Leader>gK',
        '<Cmd>lua vim.diagnostic.goto_prev({float = true, severity = vim.diagnostic.severity.ERROR})<CR>',
        { silent = true })
    map('', '<Leader>d', '<Cmd>FocusDiagnostic<CR>', { silent = true })
    map('', '<Leader>k', '<Cmd>LspHover<CR>', { silent = true })
    map('n', '<C-k>', '<Cmd>LspSignatureHelp<CR>', { silent = true })
    map('i', '<C-k>', '<Cmd>LspSignatureHelp<CR>', { silent = true })
    map('', '<Leader>f', '<Cmd>lua vim.lsp.buf.format()<CR>', { silent = true })
    map('', '<Leader>r', '<Cmd>lua vim.lsp.buf.rename()<CR>', { silent = true })
    map('', '<Leader>c', '<Cmd>lua vim.lsp.buf.code_action()<CR>', { silent = true })

    -- file navigation and search
    map('', '<Leader>p', '<Cmd>lua require(\'telescope.builtin\').find_files({hidden = true})<CR>', {})
    -- map('', '<Leader>P', '<Cmd>lua FilesChangedComparedToMain()<CR>', {})
    map('', '<Leader>gp', '<Cmd>Telescope git_status<CR>', {})
    map('', '<Leader>gP', '<Cmd>FilesChangedComparedToMain<CR>', {})
    map('', '<Leader>]', '<Cmd>Telescope live_grep<CR>', {})
    map('', '<Leader>}', '<Cmd>Telescope grep_string<CR>', {})
    map('', '<Leader>g}', '<Cmd>lua require(\'telescope.builtin\').resume()<CR>', {})

    -- winshift
    map('n', '<C-W><CR>', '<Cmd>lua require\'winshift.lib\'.start_move_mode()<CR>', { noremap = true })

    -- Insert helpers
    map('n', '<Leader>iu', '<Cmd>UUIDGen<CR>', { silent = true })
    map('n', '<Leader>it', '<Cmd>TimestampUTC<CR>', { silent = true })

    -- go coverage
    map('', '<Leader>lc', '<Cmd>GoCoverageToggle<CR>', { silent = true })

    map('', '<Leader><Tab><Tab>', ':set invlist<CR>', { silent = true })
end

return M
