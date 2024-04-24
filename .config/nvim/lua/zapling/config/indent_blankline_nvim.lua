local M = {}

local filetypes = {'yaml', 'yml', 'html', 'json', 'cs'}

M.get_filetypes = function()
    return filetypes
end

M.setup = function()
    require("ibl").setup({ enabled = false })

    local patterns = {}
    for _, v in pairs(filetypes) do
        table.insert(patterns, '*.' .. v)
    end

    vim.api.nvim_create_autocmd({ 'BufEnter' }, {
        pattern = patterns,
        callback = function()
            require("ibl").setup_buffer(0, {
                enabled = true,
                indent = {
                    char = '▏'
                },
                scope = {
                    enabled = false
                }
            })
        end,
    })
end

return M
