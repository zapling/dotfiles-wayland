return {
    'folke/snacks.nvim',
    lazy = true,
    opts = {
        gitbrowse = {}
    },
    init = function()
        vim.api.nvim_create_user_command('GitOpen', function()
            require('snacks').gitbrowse()
        end, {})
    end
}
