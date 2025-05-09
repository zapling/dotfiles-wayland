local M = {}

local filetypes = {
    'angular',
    'bash',
    'css',
    'go',
    'gomod',
    'html',
    'javascript',
    'json',
    'lua',
    'python',
    'typescript',
    'yaml',
    'teal',
    'tsx',
    -- 'dockerfile', -- Does not render correctly: 2025-02-03
    'hcl',
    'terraform',
    'markdown',
    'c_sharp',
    'templ',
    'sql',
}

M.get_filetypes = function()
    return filetypes
end

M.setup = function()
    require('nvim-treesitter.configs').setup({
        ensure_installed = filetypes,
        highlight = {
            enable = true,
            additional_vim_regex_highlighting = false,
        },
    })
    vim.treesitter.language.register('bash', { 'dotenv' })
end

return M
