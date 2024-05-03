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

function M.get_git_origin_head()
    local origin_head_branch = nil
    require('plenary.job'):new({
        command = "git",
        args = { "symbolic-ref", "refs/remotes/origin/HEAD" },
        on_exit = function(j, return_val)
            if return_val ~= 0 then
                return
            end

            origin_head_branch = j:result()[1]:sub(21)
        end,
    }):sync()
    return origin_head_branch
end

function M.get_git_current_branch()
    local branch = nil
    require('plenary.job'):new({
        command = "git",
        args = { "branch", "--show-current" },
        on_exit = function(j, return_val)
            if return_val ~= 0 then
                return
            end

            branch = j:result()[1]
        end,
    }):sync()
    return branch
end

return M
