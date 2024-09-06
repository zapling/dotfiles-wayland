local M = {}

local filetypes = {
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
    'dockerfile',
    'hcl',
    'terraform',
    'markdown',
    'c_sharp',
    'templ',
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
