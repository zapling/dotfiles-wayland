local M = {}

M.config = {
    on_attach = function(client)
        -- Disable renaming, let vtsls handle this
        -- so we do not get multiple prompts.
        client.server_capabilities.renameProvider = false
    end,
}

return M
