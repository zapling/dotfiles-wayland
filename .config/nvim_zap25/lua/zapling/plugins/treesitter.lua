local filetypes = {
    'bash',
    'markdown',
    'yaml',
    'json',
    'lua',
    'python',
    'sql',

    -- Go
    'go',
    'gomod',

    -- Frontend
    'html',
    'css',
    'javascript',
    'typescript',
    'tsx',
    'angular',

    -- Devops
    'terraform',
    'hcl',
}

return {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    config = function()
        ---@diagnostic disable-next-line:missing-fields
        require('nvim-treesitter.configs').setup({
            ensure_installed = filetypes,
            highlight = {
                enable = true,
                additional_vim_regex_highlighting = false, -- VERY important to disable
            }
        })
        vim.treesitter.language.register('bash', { 'dotenv' })
    end,
}
