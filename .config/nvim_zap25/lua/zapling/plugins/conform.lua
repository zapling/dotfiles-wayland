local frontend_formatters = { 'prettier', stop_after_first = true }
local ts_and_js_file_extensions = { js = 1, jsx = 1, ts = 1, tsx = 1 }
local formatters_by_ft = {
    javascript = frontend_formatters,
    javascriptreact = frontend_formatters,
    typescript = frontend_formatters,
    typescriptreact = frontend_formatters,
    html = frontend_formatters,
    htmlangular = frontend_formatters,
    css = frontend_formatters,
    json = frontend_formatters,
}

return {
    'stevearc/conform.nvim',
    ft = vim.tbl_keys(formatters_by_ft),
    event = { 'LspAttach' }, -- Make sure this plugin is loaded if an lsp is attached, so we get format on save setup
    cmd = { 'ConformInfo' },
    config = function()
        local conform = require('conform')

        -- Prettier formatter should only be used if there is a prettier config file
        conform.formatters.prettier = vim.tbl_deep_extend('force', require('conform.formatters.prettier'), {
            cwd = require('conform.util').root_file({ '.prettierrc' }),
            require_cwd = true,
        })

        local augroup = vim.api.nvim_create_augroup('zapling-conform', { clear = true })
        vim.api.nvim_create_autocmd({ 'BufWritePre' }, {
            pattern = '*',
            group = augroup,
            callback = function(args)
                local file_extension = vim.fn.expand('%:e')
                if ts_and_js_file_extensions[file_extension] then
                    require('conform').format({ bufnr = args.buf, lsp_fallback = true }, function()
                        require('vtsls').commands.add_missing_imports(args.buf)
                    end)
                    return
                end

                require('conform').format({ bufnr = args.buf, lsp_fallback = true })
            end,
            desc = 'Format with conform on save, fallback to lsp'
        })

        conform.setup({
            formatters_by_ft = formatters_by_ft,
        })
    end,
}
