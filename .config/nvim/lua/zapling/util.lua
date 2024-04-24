local path = require('plenary.path')

local M = {}

-- This function exists in plenary but has an unresolved bug
-- where the scanning get stuck on root.
-- https://github.com/nvim-lua/plenary.nvim/pull/506
function M.find_upwards(filename)
    local folder = path:new(".")
    while folder:absolute() ~= path.root do
        local p = folder:joinpath(filename)
        if p:exists() then
            return p
        end

        local parent = folder:parent()

        if folder.filename == "/" and parent.filename == "/" then
            return ""
        end

        folder = parent
    end
    return ""
end

return M
