return {
    'echasnovski/mini.comment',
    dependencies = {
        'JoosepAlviste/nvim-ts-context-commentstring'
    },
    lazy = true,
    event = { 'BufReadPost', 'BufNewFile' },
    opts = {
        custom_commenstring = function()
            return require('ts_context_commentstring.internal').calculate_commentstring() or vim.bo.commentstring
        end,
    }
}
