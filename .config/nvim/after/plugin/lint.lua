require('lint').linters_by_ft = {
    go = { 'golangcilint' },
    sh = { 'shellcheck' }
}

require("mason-nvim-lint").setup({automatic_installation = true})

vim.api.nvim_create_autocmd({ "BufReadPost", "BufWritePost" }, {
    callback = function()
        require("lint").try_lint()
    end,
})
