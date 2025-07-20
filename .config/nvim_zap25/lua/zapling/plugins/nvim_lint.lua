local linters_by_ft = {
    go = { 'golangcilint' },
    sh = { 'shellcheck' },
    bash = { 'shellcheck' },
}

return {
    'mfussenegger/nvim-lint',
    ft = vim.tbl_keys(linters_by_ft),
    cmd = {},
    event = {},
    config = function()
        local lint = require('lint')
        lint.linters_by_ft = linters_by_ft

        local augroup = vim.api.nvim_create_augroup('zapling-nvim-lint', { clear = true })
        vim.api.nvim_create_autocmd({ 'BufReadPost', 'BufWritePost', }, {
            pattern = "*",
            group = augroup,
            callback = function()
                require('lint').try_lint()
            end,
            desc = 'Try and lint the buffer',
        })
    end,
}
