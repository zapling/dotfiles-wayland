require('lint').linters_by_ft = {
  go = {'golangcilint'},
  sh = {'shellcheck'}
}

vim.api.nvim_create_autocmd({ "BufReadPost", "BufWritePost" }, {
  callback = function()
    require("lint").try_lint()
  end,
})
