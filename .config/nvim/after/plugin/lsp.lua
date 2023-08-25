require("mason").setup({
    install_root_dir = os.getenv("HOME") .. '/.local/bin/nvim-mason/',
    PATH = 'skip',
})

require("mason-lspconfig").setup({automatic_installation = true})

require('lspconfig').gopls.setup(require("zapling.lsp.go").config)
require('lspconfig').lua_ls.setup(require("zapling.lsp.lua").config)
require('lspconfig').bashls.setup({})

-- Front-end ecosystem
require('lspconfig').vtsls.setup(require("vtsls").lspconfig) -- tsserver alternative
require('lspconfig').angularls.setup({})
require('lspconfig').cssls.setup({})
require('lspconfig').rome.setup({})

require("null-ls").setup(require("zapling.lsp.null_ls").config)

-- Needs to setup after null-ls
require("mason-null-ls").setup({automatic_installation = true})
