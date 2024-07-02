local M = {}

local get_plugins = function(should_lazyload)
    return {
        -- Libs
        { 'nvim-lua/plenary.nvim', lazy = should_lazyload },
        { 'nvim-lua/popup.nvim',   lazy = should_lazyload },

        -- Core (feels like native vim functionality)
        {
            'echasnovski/mini.comment',
            version = false,
            opts = function()
                return require('zapling.config.mini_comment')
            end,
        },
        -- Edit 'surroundings'
        {
            'tpope/vim-surround',
            lazy = should_lazyload,
            keys = { 'cs', 'ds', 'yss' }
        },
        -- Coercion, e.g 'crs' (coerce to snake_case)
        {
            'tpope/vim-abolish',
            layz = should_lazyload,
            cmd = { 'Abolish', 'Subvert' },
            keys = { 'cr' },
        },
        'tpope/vim-repeat', -- . repetition for custom motions
        -- Wrap function arguments with keypress
        {
            'FooSoft/vim-argwrap',
            lazy = should_lazyload,
            cmd = 'ArgWrap'
        },
        -- f,F,t,F motion highlighting
        {
            'unblevable/quick-scope',
            init = require('zapling.config.quickscope'),
            lazy = should_lazyload,
            keys = { 'f', 'F', 't', 'T' },
        },
        -- Show whitespace as red blocks
        {
            'ntpeters/vim-better-whitespace',
            lazy = should_lazyload,
            event = 'BufEnter'
        },
        -- Move windows around easily
        {
            'sindrets/winshift.nvim',
            lazy = should_lazyload,
            opts = function()
                return require('zapling.config.winshift')
            end,
        },
        -- Editable quickfix window
        {
            'stefandtw/quickfix-reflector.vim',
            lazy = should_lazyload,
            event = 'BufWinEnter quickfix'
        },

        -- Git
        {
            'tpope/vim-fugitive',
            lazy = should_lazyload,
            cmd = { 'Git', 'G' }
        },
        {
            'lewis6991/gitsigns.nvim',
            dependencies = { 'nvim-lua/plenary.nvim' },
            opts = function()
                return require('zapling.config.gitsigns')
            end,
        },

        -- Theme and styling
        {
            'ellisonleao/gruvbox.nvim',
            -- commit = '7fb36e0f67aa6f3d7f3e54f37ca7032ea1af0b59',
            -- pin = true
        },
        {
            'nvim-lualine/lualine.nvim',
            opts = function()
                return require('zapling.config.lualine')
            end
        },
        'kyazdani42/nvim-web-devicons', -- note: requires patched fonts

        -- Syntax
        {
            'nvim-treesitter/nvim-treesitter',
            dependencies = {
                'nvim-treesitter/nvim-treesitter-context',
                'JoosepAlviste/nvim-ts-context-commentstring'
            },
            build = ':TSUpdate',
            ft = require('zapling.config.treesitter').get_filetypes(),
            config = function()
                require('zapling.config.treesitter').setup()
            end,
        },
        {
            'JoosepAlviste/nvim-ts-context-commentstring',
            dependencies = { 'nvim-treesitter/nvim-treesitter' },
            lazy = should_lazyload,
        },
        {
            'nvim-treesitter/nvim-treesitter-context',
            dependencies = { 'nvim-treesitter/nvim-treesitter' },
            lazy = should_lazyload,
            opts = function()
                return require('zapling.config.treesitter_context')
            end,
        },
        {
            "elgiano/nvim-treesitter-angular",
            branch = "topic/jsx-fix",
            dependencies = { 'nvim-treesitter/nvim-treesitter' },
            lazy = should_lazyload,
            event = 'BufEnter *.js,*.ts,*.html',
        },

        -- LSP
        {
            'neovim/nvim-lspconfig',
            dependencies = {
                'williamboman/mason.nvim',
                'williamboman/mason-lspconfig.nvim',
                'kosayoda/nvim-lightbulb',
            },
            lazy = should_lazyload,
            event = { "BufReadPost", "BufNewFile" },
            cmd = { "LspInfo", "LspInstall", "LspUninstall" },
            config = function()
                require('zapling.config.lspconfig').setup()
            end,
        },
        {
            'kosayoda/nvim-lightbulb',
            lazy = should_lazyload,
            opts = function()
                return require('zapling.config.nvim_lightbulb')
            end,
        },                                                               -- visualise code actions
        { 'yioneko/nvim-vtsls',                lazy = should_lazyload }, -- tsserver wrapper for lsp
        { 'Hoffs/omnisharp-extended-lsp.nvim', lazy = should_lazyload }, -- csharp goto_def custom handler

        -- Linters
        {
            'mfussenegger/nvim-lint',
            dependencies = {
                'williamboman/mason.nvim',
                'rshkarin/mason-nvim-lint'
            },
            lazy = should_lazyload,
            ft = require('zapling.config.nvim_lint').get_filetypes(),
            config = function()
                require('zapling.config.nvim_lint').setup()
            end,
        },

        -- Formatters
        {
            'stevearc/conform.nvim',
            dependencies = {
                'williamboman/mason.nvim',
                'zapling/mason-conform.nvim',
            },
            lazy = should_lazyload,
            ft = require('zapling.config.conform_nvim').get_filetypes(),
            config = function()
                require('zapling.config.conform_nvim').setup()
            end,
            init = function()
                require('zapling.config.conform_nvim').register_on_save_autocmd()
            end,
        },

        -- Mason, because we love working with stone
        -- Package manager for LSP, linters etc
        {
            'williamboman/mason.nvim',
            dependencies = { 'zapling/mason-lock.nvim' },
            lazy = should_lazyload,
            cmd = 'Mason',
            opts = function()
                return require('zapling.config.mason')
            end
        },
        {
            'zapling/mason-lock.nvim',
            dependencies = { 'williamboman/mason.nvim' },
            lazy = should_lazyload,
            cmd = { 'MasonLock', 'MasonLockRestore' },
            opts = function()
                return {}
            end,
        },
        {
            'williamboman/mason-lspconfig.nvim',
            dependencies = { 'williamboman/mason.nvim' },
            lazy = should_lazyload,
            opts = function()
                return require('zapling.config.mason_lspconfig')
            end,
        },
        {
            'rshkarin/mason-nvim-lint',
            dependencies = {
                'williamboman/mason.nvim'
            },
            lazy = should_lazyload,
            opts = function()
                return require('zapling.config.mason_nvim_lint')
            end,
        },
        {
            'zapling/mason-conform.nvim',
            dependencies = {
                'williamboman/mason.nvim'
            },
            opts = function()
                return require('zapling.config.mason_conform')
            end,
            lazy = should_lazyload,
        },


        -- Completion
        {
            'hrsh7th/nvim-cmp',
            dependencies = {
                'L3MON4D3/LuaSnip',
                'hrsh7th/cmp-buffer',
                'hrsh7th/cmp-path',
                'hrsh7th/cmp-nvim-lua',
                'hrsh7th/cmp-nvim-lsp',
                'onsails/lspkind-nvim',
                'L3MON4D3/LuaSnip',
            },
            lazy = should_lazyload,
            opts = function()
                return require('zapling.config.nvim_cmp')
            end,
            event = 'InsertEnter',
        },

        -- Search / Navigation
        {
            'nvim-telescope/telescope.nvim',
            dependencies = {
                'nvim-lua/popup.nvim',
                'nvim-lua/plenary.nvim',
                'nvim-treesitter/nvim-treesitter',
                'nvim-telescope/telescope-fzf-native.nvim',
            },
            cmd = 'Telescope',
            lazy = should_lazyload,
            config = function()
                require('zapling.config.telescope').setup()
            end,
        },
        {
            'nvim-telescope/telescope-fzf-native.nvim',
            build = 'make',
            lazy = should_lazyload
        },

        -- Misc
        {
            'towolf/vim-helm',
            lazy = should_lazyload,
            ft = 'helm'
        },
        {
            'earthly/earthly.vim',
            lazy = should_lazyload,
            ft = 'Earthfile'
        },
        {
            'zapling/vim-go-utils',
            lazy = should_lazyload,
            ft = 'go'
        },
        {
            'zapling/plantuml.nvim',
            dependencies = { 'nvim-lua/plenary.nvim' },
            lazy = should_lazyload,
            cmd = 'Plantuml',
            opts = function()
                return require('zapling.config.plantuml')
            end,
        },
        {
            'lukas-reineke/indent-blankline.nvim',
            lazy = should_lazyload,
            ft = require('zapling.config.indent_blankline_nvim').get_filetypes(),
            config = function()
                require('zapling.config.indent_blankline_nvim').setup()
            end,
        },
        {
            'NvChad/nvim-colorizer.lua',
            opts = function()
                return require('zapling.config.colorizer')
            end,
        },
    }
end

M.setup = function(should_lazyload)
    require("lazy").setup(get_plugins(should_lazyload))
end

return M
