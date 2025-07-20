local function quick_jump(direction)
    local flags = 'bz'
    local regex = [[^\\(package\\|import\\|type\\|const\\|var\\|func\\)]]

    if direction == 'down' then
        flags = ''
    end

    local command = string.format('execute search("%s", "%s")', regex, flags)

    vim.api.nvim_exec2(command, {})
end

vim.keymap.set('n', '[[', function() quick_jump('up') end, { silent = true, buffer = true })
vim.keymap.set('n', ']]', function() quick_jump('down') end, { silent = true, buffer = true })
vim.keymap.set('v', '[[', function() quick_jump('up') end, { silent = true, buffer = true })
vim.keymap.set('v', ']]', function() quick_jump('down') end, { silent = true, buffer = true })

local augroup = vim.api.nvim_create_augroup('zapling-go', { clear = true })
vim.api.nvim_create_autocmd('BufWritePre', {
    pattern = "*.go",
    group = augroup,
    callback = function(event)
        local clients = vim.lsp.get_clients({ bufnr = event.buf, name = 'gopls' })
        if vim.tbl_count(clients) == 0 then
            return
        end

        ---@type vim.lsp.Client
        local client = clients[0]

        local params = vim.lsp.util.make_range_params(nil, "utf-16")
        params.context = { only = { "source.organizeImports" } }
        local result = vim.lsp.buf_request_sync(event.buf, "textDocument/codeAction", params, 3000)
        for _, res in pairs(result or {}) do
            for _, r in pairs(res.result or {}) do
                if r.edit then
                    vim.lsp.util.apply_workspace_edit(r.edit, "utf-16")
                else
                    client:exec_cmd(r.command)
                end
            end
        end
    end,
    desc = 'Runs gopls organize imports'
})
