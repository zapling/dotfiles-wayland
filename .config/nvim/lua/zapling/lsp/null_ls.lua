local null_ls = require("null-ls")
local Job = require'plenary.job'

local M = {}

M.config = {
    sources = {
        null_ls.builtins.diagnostics.golangci_lint.with({
            args = {
                "run",
                "--fix=false",
                "--build-tags=integration_test",
                "--out-format=json",
                "$DIRNAME",
                "--path-prefix",
                "$ROOT"
            },
        }),

        -- shell / bash
        null_ls.builtins.diagnostics.shellcheck,

        null_ls.builtins.formatting.prettier,
    },
    -- attach prettier on save to every buffer
    on_attach = function(client, bufnr)
        local source = null_ls.get_source({
            name = "prettier",
            method = null_ls.methods.FORMATTING,
        })[1]

        if source.name ~= "prettier" then
            return
        end

        local file_ext = vim.fn.expand('%:e')

        vim.api.nvim_create_autocmd({ 'BufWritePre' }, {
            pattern = '*.' .. file_ext,
            callback = function()
                vim.lsp.buf.format({
                    filter = function(c) return c.name == 'null-ls' end
                })
            end,
        })
    end,
}

return M
