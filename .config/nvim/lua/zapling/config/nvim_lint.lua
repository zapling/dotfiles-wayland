local M = {}

local linters_by_ft = {
    go = { 'golangcilint' },
    sh = { 'shellcheck' },
}

M.get_filetypes = function()
    local filetypes = {}
    for k, _ in pairs(linters_by_ft) do
        table.insert(filetypes, k)
    end
    return filetypes
end

M.setup = function()
    require('lint').linters_by_ft = linters_by_ft

    vim.api.nvim_create_autocmd({ "BufReadPost", "BufWritePost" }, {
        callback = function()
            require("lint").try_lint()
        end,
    })
end

return M
