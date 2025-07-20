local filetypes = {
    'yaml',
    'helm',
    'html',
    'htmlangular',
    'json',
}

return {
    'lukas-reineke/indent-blankline.nvim',
    lazy = true,
    ft = filetypes,
    config = function()
        require('ibl').setup({ enabled = false })

        local patterns = {}
        for _, v in pairs(filetypes) do
            table.insert(patterns, '*.' .. v)
        end

        local augroup = vim.api.nvim_create_augroup('zapling-indent-blankline', { clear = true })
        vim.api.nvim_create_autocmd({ 'BufEnter' }, {
            pattern = patterns,
            group = augroup,
            callback = function()
                require("ibl").setup_buffer(0, {
                    enabled = true,
                    indent = {
                        char = '▏'
                    },
                    scope = {
                        enabled = false
                    }
                })
            end,
        })
    end,
}
