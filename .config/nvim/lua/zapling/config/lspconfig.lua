local M = {}

function M.setup()
    require('lspconfig').gopls.setup(require("zapling.config.lsp.go").config)
    require('lspconfig').templ.setup({})

    require('lspconfig').lua_ls.setup(require("zapling.config.lsp.lua").config)
    require('lspconfig').bashls.setup({})

    require 'lspconfig'.omnisharp.setup({}) -- csharp lsp

    -- Front-end ecosystem
    require('lspconfig').vtsls.setup(require("vtsls").lspconfig) -- tsserver alternative
    require('lspconfig').angularls.setup(require("zapling.config.lsp.angular").config)
    require('lspconfig').cssls.setup({})
    require('lspconfig').biome.setup(require("zapling.config.lsp.biome").config)
    require('lspconfig').eslint.setup(require("zapling.config.lsp.eslint").config)
end

return M
