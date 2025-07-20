return {
    'nvim-treesitter/nvim-treesitter-context',
    dependencies = {
        'nvim-treesitter/nvim-treesitter',
    },
    lazy = true,
    event = { 'BufReadPost', 'BufNewFile' },
    opts = {
        enable = true,
        max_lines = 1,
        patterns = {
            default = {
                'class',
                'function',
                'method',
            },
        }
    },
}
