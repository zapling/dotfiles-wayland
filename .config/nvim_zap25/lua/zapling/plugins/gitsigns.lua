return {
    'lewis6991/gitsigns.nvim',
    lazy = true,
    event = { 'BufReadPost', 'BufNewFile' },
    opts = {
        signs = {
            add = { text = '+' },
            change = { text = '~' },
            delete = { text = '_' },
            topdelete = { text = '‾' },
            changedelete = { text = '~' },
            untracked = { text = '┆' },
        },
        signs_staged = {
            add = { text = '+' },
            change = { text = '~' },
            delete = { text = '_' },
            topdelete = { text = '‾' },
            changedelete = { text = '~' },
            untracked = { text = '┆' },
        },
        on_attach = function(bufnr)
            vim.api.nvim_buf_set_keymap(bufnr, 'n', ']c', '<cmd>lua require"gitsigns".next_hunk({wrap = false})<CR>', {});
            vim.api.nvim_buf_set_keymap(bufnr, 'n', '[c', '<cmd>lua require"gitsigns".prev_hunk({wrap = false})<CR>', {});
        end,
        attach_to_untracked = true,
    }
}
