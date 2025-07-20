vim.filetype.add({
    extension = {
        templ = "templ",
    },
    pattern = {
        [".envrc"] = "bash",
        [".env"] = "dotenv",
        ["%.env%.[%w_.-]+"] = "dotenv"
    }
})

local insert_uuid = function()
    local uuid = vim.fn.system('uuidgen'):gsub("\n", "")
    vim.api.nvim_paste(uuid, true, -1)
end

local insert_ksuid = function()
    local ksuid = vim.fn.system('ksuid'):gsub("\n", "")
    vim.api.nvim_paste(ksuid, true, -1)
end

local insert_date = function()
    local date = vim.fn.system('date +%F'):gsub("\n", "")
    vim.api.nvim_paste(date, true, -1)
end

local insert_unix_ts = function()
    local ts = vim.fn.system('date +%s'):gsub("\n", "")
    vim.api.nvim_paste(ts, true, -1)
end

local insert_rfc3339_ts = function()
    local ts = vim.fn.system('date -u +"%Y-%m-%dT%H:%M:%SZ"'):gsub("\n", "")
    vim.api.nvim_paste(ts, true, -1)
end

vim.api.nvim_create_user_command('InsertUUID', insert_uuid, {})
vim.api.nvim_create_user_command('InsertKSUID', insert_ksuid, {})
vim.api.nvim_create_user_command('InsertDate', insert_date, {})
vim.api.nvim_create_user_command('InsertUnixTS', insert_unix_ts, {})
vim.api.nvim_create_user_command('InsertRFC3339TS', insert_rfc3339_ts, {})

local git_rebase_ahead = function(opts)
    local base_branch = opts.args ~= "" and opts.args or "main"

    local result = vim.fn.systemlist("git rev-list --count " .. base_branch .. "..HEAD")

    if vim.v.shell_error ~= 0 or #result == 0 then
        vim.notify("Failed to count commits ahead of '" .. base_branch .. "'", vim.log.levels.ERROR)
        return
    end

    local ahead_count = tonumber(result[1])
    if ahead_count == 0 then
        vim.notify("No commits ahead of '" .. base_branch .. "'", vim.log.levels.INFO)
        return
    end

    vim.cmd("G rebase -i HEAD~" .. ahead_count)
end

vim.api.nvim_create_user_command("GitRebase", git_rebase_ahead, {
    nargs = "?",
    complete = function(_, _, _)
        return vim.fn.systemlist("git branch --format='%(refname:short)'")
    end,
    desc = "Interactive rebase against number of commits ahead of base branch (default: main)",
})
