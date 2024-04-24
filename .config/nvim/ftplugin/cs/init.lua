-- jump with custom telescope wrapper around omnisharp extended because of csharp reasons
vim.keymap.set(
    '',
    '<Leader>gd',
    function()
        require('omnisharp_extended').telescope_lsp_definitions()
    end,
    { silent = true }
)
