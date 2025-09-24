return {
    'neovim/nvim-lspconfig',
    dependencies = {
        'saghen/blink.cmp'
    },
    config = function()
        local capabilitiesWithoutSnippets = require('blink.cmp').get_lsp_capabilities({
            textDocument = {
                completion = {
                    completionItem = { snippetSupport = false },
                }
            },
        })

        -- Golang
        vim.lsp.config('gopls', {
            capabilities = capabilitiesWithoutSnippets,
            settings = {
                gopls = {
                    buildFlags = { "-tags=integration_test,integration" }
                }
            },
        })
        vim.lsp.enable('gopls')
        vim.lsp.enable('templ')

        -- Frontend
        vim.lsp.enable('vtsls')
        vim.lsp.config('angularls', {
            settings = {
                angular = { forceStrictTemplates = true },
            },
        })
        vim.lsp.enable('angularls')
        vim.lsp.enable('cssls')
        vim.lsp.enable('biome')
        vim.lsp.enable('eslint')

        -- CS/dotnet
        vim.lsp.enable('omnisharp')

        -- Misc
        vim.lsp.enable('lua_ls')
        vim.lsp.enable('bashls')
    end,
}
