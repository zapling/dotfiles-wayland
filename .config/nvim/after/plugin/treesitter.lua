require 'nvim-treesitter.configs'.setup {
    ensure_installed = {
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
    },
    highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
    },
    context_commentstring = {
        enable = true
    },
}

require 'treesitter-context'.setup {
    enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
    max_lines = 1, -- How many lines the window should span. Values <= 0 mean no limit.
    patterns = {
        default = {
            'class',
            'function',
            'method',
        },
    },
}

local treesitter_parser_config = require "nvim-treesitter.parsers".get_parser_configs()
treesitter_parser_config.templ = {
    install_info = {
        url = "https://github.com/vrischmann/tree-sitter-templ.git",
        files = { "src/parser.c", "src/scanner.c" },
        branch = "master",
    },
}

vim.treesitter.language.register('templ', 'templ')
