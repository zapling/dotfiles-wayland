local function quick_jump(direction)
    local flags = 'bz'
    local regex = [[^\\(package\\|import\\|type\\|const\\|var\\|func\\)]]

    if direction == 'down' then
        flags = ''
    end

    local command = string.format('execute search("%s", "%s")', regex, flags)

    vim.api.nvim_exec(command, nil)
end

vim.keymap.set('n', '[[', function() quick_jump('up') end, { silent = true, buffer = true })
vim.keymap.set('n', ']]', function() quick_jump('down') end, { silent = true, buffer = true })
vim.keymap.set('v', '[[', function() quick_jump('up') end, { silent = true, buffer = true })
vim.keymap.set('v', ']]', function() quick_jump('down') end, { silent = true, buffer = true })

-- https://github.com/neovim/nvim-lspconfig/issues/115
local function organize_imports(timeout_ms)
    local params = vim.lsp.util.make_range_params()
    params.context = { only = { "source.organizeImports" } }
    local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, timeout_ms)
    for _, res in pairs(result or {}) do
        for _, r in pairs(res.result or {}) do
            if r.edit then
                vim.lsp.util.apply_workspace_edit(r.edit, "utf-16")
            else
                vim.lsp.buf.execute_command(r.command)
            end
        end
    end
end

local augroup_go = vim.api.nvim_create_augroup('GO_LSP', { clear = true })

local goPlsIsReady = false

vim.api.nvim_create_autocmd("LspAttach", {
    group = augroup_go,
    callback = function()
        goPlsIsReady = true
    end,
})

vim.api.nvim_create_autocmd({ 'BufWritePre' }, {
    pattern = '*.go',
    group = augroup_go,
    callback = function()
        if not goPlsIsReady then
            return
        end

        vim.lsp.buf.format({ async = false })
        organize_imports(3000)
    end,
    desc = 'Run gofmt and re-organize imports',
})

vim.api.nvim_create_autocmd({ 'TextChanged', 'TextChangedI' }, {
    pattern = '*.go',
    group = augroup_go,
    callback = function()
        local namespaces = vim.diagnostic.get_namespaces()
        for namespace, source in pairs(namespaces) do
            if source.name == 'golangcilint' then
                vim.diagnostic.reset(namespace)
            end
        end
    end,
    desc = 'Reset golangci-lint diagnostics when text is changed',
})
