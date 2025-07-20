return {
    'ellisonleao/gruvbox.nvim',
    priority = 1000,
    config = function()
        local colors = require('gruvbox').palette
        require('gruvbox').setup {
            overrides = {
                Operator = { fg = colors.light0_soft, italic = false, bold = false },
                ["@variable"] = { fg = colors.light0_soft }, -- #f2e5bc
                ["@constructor.go"] = { fg = colors.bright_green },

                -- Fix GitSigns background not being correct
                -- https://github.com/ellisonleao/gruvbox.nvim/issues/304
                GitSignsAdd = { link = "GruvboxGreenSign" },
                GitSignsChange = { link = "GruvboxAquaSign" },
                GitSignsDelete = { link = "GruvboxRedSign" },

                LspReferenceTarget = { link = '' },
            },
            italic = {
                strings = false,
                operators = false,
                comments = false
            },
            contrast = "hard",
        }

        vim.cmd.colorscheme('gruvbox')
    end,
}
