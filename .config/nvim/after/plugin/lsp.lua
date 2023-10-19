require("mason").setup({
    install_root_dir = os.getenv("HOME") .. '/.local/bin/nvim-mason/',
    PATH = 'skip',
})

require("mason-lspconfig").setup({ automatic_installation = true })

require('lspconfig').gopls.setup(require("zapling.lsp.go").config)
require('lspconfig').lua_ls.setup(require("zapling.lsp.lua").config)
require('lspconfig').bashls.setup({})

require 'lspconfig'.omnisharp.setup({}) -- csharp lsp

-- Front-end ecosystem
require('lspconfig').vtsls.setup(require("vtsls").lspconfig) -- tsserver alternative
require('lspconfig').angularls.setup({})
require('lspconfig').cssls.setup({})
require('lspconfig').biome.setup(require("zapling.lsp.biome").config)
require('lspconfig').eslint.setup(require("zapling.lsp.eslint").config)

require('nvim-lightbulb').setup({
    autocmd = { enabled = true },
    sign = {
        text = "󰛩",
        hl = "DiagnosticSignHint"
    }
})
