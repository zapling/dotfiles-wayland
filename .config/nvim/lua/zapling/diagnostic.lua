local M = {}

-- Ignore any CursorHold event until the cursor is moved within
-- the buffer.
local ignore_cursorhold_event_until_moved = function()
    vim.api.nvim_command('set eventignore=CursorHold')
    vim.api.nvim_command('autocmd CursorMoved <buffer> ++once set eventignore=""')
end

-- Ignore CursorHold autocmd until the cursor moves inside the
-- the buffer. This fixes an issue where a CursorHold event
-- would trigger the Diagnostic popup while trying to hover
-- on the same line, effectivly making it impossible to
-- user hover if there was an diagnostic on the same line.
local lsp_hover = function()
    ignore_cursorhold_event_until_moved()
    vim.lsp.buf.hover()
end

local lsp_signature_help = function()
    ignore_cursorhold_event_until_moved()
    vim.lsp.buf.signature_help()
end

local focus_diagnostic = function()
    -- nvim 0.6.1 seems to have resolved this issue.
    -- vim.api.nvim_command('set eventignore=WinLeave')
    -- vim.api.nvim_command('autocmd CursorMoved <buffer> ++once set eventignore=""')
    vim.diagnostic.open_float(nil, { focusable = true, scope = 'line' })
end

M.setup = function()
    vim.diagnostic.config({
        virtual_text = false,
        underline = true,
        signs = {
            text = {
                [vim.diagnostic.severity.ERROR] = '',
                [vim.diagnostic.severity.WARN] = '',
                [vim.diagnostic.severity.INFO] = '',
                [vim.diagnostic.severity.HINT] = '',
            },
        },

        float = {
            source = true,
            focusable = false,
        },
        severity_sort = true,
    }, nil)

    vim.api.nvim_command('autocmd CursorHold * lua vim.diagnostic.open_float(nil, {scope = \'line\'})')
    vim.api.nvim_command [[autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()]]

    vim.api.nvim_create_user_command('LspHover', lsp_hover, {})
    vim.api.nvim_create_user_command('LspSignatureHelp', lsp_signature_help, {})
    vim.api.nvim_create_user_command('FocusDiagnostic', focus_diagnostic, {})
end

return M
