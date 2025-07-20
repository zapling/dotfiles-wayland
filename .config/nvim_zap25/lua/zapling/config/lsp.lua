vim.api.nvim_create_autocmd('LspDetach', {
    group = vim.api.nvim_create_augroup('zapling-lsp-shutdown', { clear = true }),
    callback = function(event)
        local client = vim.lsp.get_client_by_id(event.data.client_id)
        if client == nil then
            return
        end
        -- Defer this 100ms so the lsp gets time to dettach
        vim.defer_fn(function()
            if vim.tbl_count(vim.lsp.get_buffers_by_client_id(client.id)) > 0 then
                return
            end

            local two_minutes = 1000 * 60 * 2
            vim.defer_fn(function()
                if vim.tbl_count(vim.lsp.get_buffers_by_client_id(client.id)) > 0 then
                    return
                end
                vim.lsp.stop_client(client.id, true) -- Force stop client
            end, two_minutes)
        end, 100)
    end,
    desc = 'Stop lstp clients afer 2min if there is no buffers attached to it',
})

-- This will close all floating windows opened via vim.lsp.util.open_floating_preview
vim.api.nvim_create_autocmd('BufEnter', {
    group = vim.api.nvim_create_augroup('zapling-lsp-close-float', { clear = true }),
    callback = function(event)
        -- This breaks if neovim changes or removes the following window variable.
        -- https://github.com/neovim/neovim/blob/ace254c9fff1e4173ed8094e0c986b1c3fd8e120/runtime/lua/vim/lsp/util.lua#L1701
        local window_variable = 'lsp_floating_bufnr'

        local win_ids = vim.api.nvim_list_wins()
        for _, win in ipairs(win_ids) do
            if vim.w[win][window_variable] then
                local winbuf = vim.api.nvim_win_get_buf(win)
                if event.buf ~= winbuf and vim.api.nvim_win_is_valid(win) then
                    vim.api.nvim_win_close(win, false)
                end
            end
        end
    end,
    desc = 'Close floating lsp window when entering a buffer',
})

-- ignore_cursorhold_event_until_cursor_moved ignores the CursorHold event
-- until the cursor has moved within the buffer. This is needed because we have an
-- CursorHold event that tries to open an diagnostics float, which will in turn close
-- the window we are trying to look at.
local ignore_cursorhold_event_until_cursor_moved = function()
    vim.api.nvim_command('set eventignore=CursorHold')
    vim.api.nvim_command('autocmd CursorMoved <buffer> ++once set eventignore=""')
end

local lsp_hover = function()
    ignore_cursorhold_event_until_cursor_moved()
    vim.lsp.buf.hover()
end

local lsp_signature_help = function()
    ignore_cursorhold_event_until_cursor_moved()
    vim.lsp.buf.signature_help()
end

vim.api.nvim_create_user_command('LspHover', lsp_hover, {})
vim.api.nvim_create_user_command('LspSignatureHelp', lsp_signature_help, {})
