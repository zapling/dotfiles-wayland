local M = {}

M.enable_theme = function()
    vim.g['gruvbox_contrast_dark'] = 'hard'
    vim.g['gruvbox_invert_selection'] = 0

    vim.opt.termguicolors = true -- truecolors
    vim.opt.background = 'dark'

    local gruvbox_colors = require('gruvbox').palette
    require("gruvbox").setup({
        overrides = {
            Operator = { fg = gruvbox_colors.light0_soft, italic = false, bold = false },
            ["@variable"] = { fg = gruvbox_colors.light0_soft }, -- #f2e5bc

            -- GO: NewThing() should be green, not some other color
            ["@constructor.go"] = { fg = gruvbox_colors.bright_green },
            -- ["@lsp.typemod.variable.defaultLibrary.typescript"] = { fg = gruvbox_colors.bright_orange }

            -- Fix GitSigns background not being correct
            -- https://github.com/ellisonleao/gruvbox.nvim/issues/304
            GitSignsAdd = { link = "GruvboxGreenSign" },
            GitSignsChange = { link = "GruvboxAquaSign" },
            GitSignsDelete = { link = "GruvboxRedSign" },

            LspReferenceTarget = { link = '' },

            -- Revert diff colors back to how they where before 2.0
            diffAdded = { link = "GruvboxGreen" },
            diffRemoved = { link = "GruvboxRed" },
            diffChanged = { link = "GruvboxAqua" },
        },
        italic = {
            strings = false,
            operators = false,
            comments = false
        },
        contrast = "hard",
    })

    vim.cmd([[colorscheme gruvbox]])
end

M.register_filetypes = function()
    vim.filetype.add({
        extension = {
            templ = "templ",
        },
        pattern = {
            [".envrc"] = "bash",
            -- Set .env.* files as dotenv
            ["%.env%.[%w_.-]+"] = "dotenv",
        }
    })
end

M.setup = function()
    M.enable_theme()
    M.register_filetypes()

    -- https://github.com/neovim/neovim/issues/32660
    vim.g._ts_force_sync_parsing = true

    vim.cmd([[ set mouse= ]])

    vim.opt.updatetime     = 100
    vim.opt.backupdir      = os.getenv('HOME') .. '/.vim/backup'
    vim.opt.directory      = os.getenv('HOME') .. '/.vim/backupf'

    vim.opt.incsearch      = true
    vim.opt.ignorecase     = true
    vim.opt.smartcase      = true

    vim.opt.inccommand     = 'nosplit'                         -- see substitute result as you type
    vim.opt.completeopt    = { "menu", "menuone", "noselect" } -- needed for nvim-compe

    vim.opt.showmode       = false                             -- hide current mode

    vim.opt.relativenumber = true                              -- use releative numbers
    vim.opt.number         = true                              -- but show current line number
    vim.opt.wrap           = false                             -- never render lines as wrapped

    vim.opt.cursorline     = true                              -- use cursorline...
    vim.opt.cursorlineopt  = { 'number' }                      -- but only highlight the linenumber

    vim.opt.colorcolumn    = '100'                             -- 100 chars line indicator

    vim.opt.signcolumn     = 'yes'                             -- always show sign column

    vim.opt.textwidth      = 0                                 -- never auto break lines when typing

    vim.opt.tabstop        = 4
    vim.opt.softtabstop    = 4
    vim.opt.shiftwidth     = 4
    vim.opt.expandtab      = true
    vim.opt.smartindent    = true

    vim.opt.formatoptions  = vim.opt.formatoptions
        - "a" -- Auto formatting is BAD.
        - "t" -- Don't auto format my code. I got linters for that.
        + "c" -- In general, I like it when comments respect textwidth
        + "q" -- Allow formatting comments w/ gq
        - "o" -- O and o, don't continue comments
        + "r" -- But do continue when pressing enter.
        + "n" -- Indent past the formatlistpat, not underneath it.
        + "j" -- Auto-remove comments if possible.
        - "2" -- I'm not in gradeschool anymore
end

return M
