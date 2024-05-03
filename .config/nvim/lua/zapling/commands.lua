local M = {}

local function get_substr(text, pattern)
    local i, j = string.find(text, pattern)

    if not i then
        return ''
    end

    return text:sub(i, j)
end

local git_rebase_current_branch = function()
    local current_branch = require('zapling.util').get_git_current_branch()
    if current_branch == nil then
        print('Not in a git repo')
        return
    end

    local origin_head_branch = require('zapling.util').get_git_origin_head()
    if origin_head_branch == nil then
        print('Failed to get origin HEAD')
        return
    end

    local compare = 'origin/' .. origin_head_branch .. '..' .. current_branch

    local num_commits = nil
    require('plenary.job'):new({
        command = "git",
        args = { "rev-list", "--count", compare },
        on_exit = function(j, return_val)
            if return_val ~= 0 then
                return
            end

            num_commits = j:result()[1]
        end,
    }):sync()

    if num_commits == nil then
        print('No commits to rebase')
        return
    end

    local command = 'Git rebase -i HEAD~' .. num_commits

    vim.api.nvim_command(command)
end

local function insert_uuid()
    local uuid = nil
    require('plenary.job'):new({
        command = 'uuidgen',
        on_exit = function(j, return_val)
            if return_val ~= 0 then
                return
            end

            uuid = j:result()[1]
        end,
    }):sync()
    vim.cmd('normal i' .. uuid)
end

local function insert_timestamp()
    local timestamp = nil
    require('plenary.job'):new({
        command = 'timestamp',
        args = { 'rfc3339' },
        on_exit = function(j, return_val)
            if return_val ~= 0 then
                return
            end

            timestamp = j:result()[1]
        end,
    }):sync()
    vim.cmd('normal i' .. timestamp)
end

local function open_line_in_browser()
    local filepath = vim.fn.expand('%')
    local linenum = vim.fn.line('.')

    local origin = nil
    require('plenary.job'):new({
        command = 'git',
        args = { 'config', '--get', 'remote.origin.url' },
        on_exit = function(j, return_val)
            if return_val ~= 0 then
                return
            end

            origin = j:result()[1]
        end,
    }):sync()

    if origin == nil then
        print("Not in a git repo")
        return
    end

    local host = get_substr(origin, "@.+:")
    local namespace = get_substr(origin, ":.+/")
    local repo = get_substr(origin, "/.+%.git")

    if host == "" or namespace == "" or repo == "" then
        return ""
    end

    host = host:sub(2, host:len() - 1)                -- remove starting "@" and ending ":"
    namespace = namespace:sub(2, namespace:len() - 1) -- remove starting ":" and ending "/"
    repo = repo:sub(2, repo:len() - 4)                -- remove starting "/" and ending ".git"

    local head_sha1 = nil
    require('plenary.job'):new({
        command = 'git',
        args = { 'rev-parse', 'HEAD' },
        on_exit = function(j, return_val)
            if return_val ~= 0 then
                return
            end

            head_sha1 = j:result()[1]
        end,
    }):sync()

    local function get_github_url()
        return string.format('https://%s/%s/%s/tree/%s/%s#L%s', host, namespace, repo, head_sha1, filepath, linenum)
    end

    local function get_gitlab_url()
        return string.format('https://%s/%s/%s/-/tree/%s/%s#L%s', host, namespace, repo, head_sha1, filepath, linenum)
    end

    local function get_bitbucket_url()
        return string.format('https://%s/%s/%s/src/%s/%s#lines-%s', host, namespace, repo, head_sha1, filepath, linenum)
    end

    local link = nil

    if string.find(host, "github") then
        link = get_github_url()
    elseif string.find(host, "gitlab") then
        link = get_gitlab_url()
    elseif string.find(host, "bitbucket") then
        link = get_bitbucket_url()
    end

    if link == nil then
        print('Unsupported host: ' .. host)
        return
    end

    require('plenary.job'):new({ command = 'xdg-open', args = { link } }):sync()
end

M.setup = function()
    vim.api.nvim_create_user_command('Gitrebase', git_rebase_current_branch, {})
    vim.api.nvim_create_user_command('GitOpen', open_line_in_browser, {})
    vim.api.nvim_create_user_command('UUIDGen', insert_uuid, {})
    vim.api.nvim_create_user_command('TimestampUTC', insert_timestamp, {})
    vim.api.nvim_create_user_command(
        'FilesChangedComparedToMain',
        function()
            require('zapling.config.telescope').files_compared_to_main()
        end,
        {}
    )
end

return M
