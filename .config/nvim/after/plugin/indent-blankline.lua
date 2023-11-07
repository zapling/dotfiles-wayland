require("ibl").setup({ enabled = false })

vim.api.nvim_create_autocmd({ 'BufEnter' }, {
    pattern = { '*.yaml', '*.yml', '*.html', '*.json', '*.cs' },
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
