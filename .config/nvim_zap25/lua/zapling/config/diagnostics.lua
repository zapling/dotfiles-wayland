vim.diagnostic.config({
    virutal_text = false,
    underline = true,
    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = '',
            [vim.diagnostic.severity.WARN] = '',
            [vim.diagnostic.severity.INFO] = '',
            [vim.diagnostic.severity.HINT] = '',
        },
    },
    float = {
        source = true,
        focusable = false,
    },
    severity_sort = true,
}, nil)

vim.api.nvim_create_autocmd('CursorHold', {
    pattern = '*',
    group = vim.api.nvim_create_augroup('zapling-lsp-hover', { clear = true }),
    callback = function()
        vim.diagnostic.open_float(nil, { scope = 'line', })
    end,
    desc = 'Show diagnostics in float',
})

local diagnostic_open_float = function()
    vim.diagnostic.open_float(nil, { focusable = true, scope = 'line', })
end

vim.api.nvim_create_user_command('DiagnosticOpenFloat', diagnostic_open_float, {})
