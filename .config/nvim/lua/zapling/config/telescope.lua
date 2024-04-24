local M = {}

local rg_additional_args = function(args)
    return { '--hidden' }
end

-- https://github.com/nvim-telescope/telescope.nvim/issues/1048#issuecomment-1679797700
local select_one_or_multi = function(prompt_bufnr)
    local picker = require('telescope.actions.state').get_current_picker(prompt_bufnr)
    local multi = picker:get_multi_selection()
    if not vim.tbl_isempty(multi) then
        require('telescope.actions').close(prompt_bufnr)
        -- TODO: safe window number and close after opening the other ones?
        for _, j in pairs(multi) do
            if j.path ~= nil then
                print(j.path)
                vim.cmd(string.format('%s %s', 'vsp', j.path))
            end
        end
    else
        require('telescope.actions').select_default(prompt_bufnr)
    end
end

M.files_compared_to_main = function()
    require('telescope.builtin').find_files({
        find_command = { 'git', 'diff', '--name-only', 'main' },
        prompt_title = 'Git files modified compared to main'
    })
end

M.setup = function()
    require('telescope').setup({
        defaults = {
            preview = {
                msg_bg_fillchar = "░",
            },
            file_ignore_patterns = {
                "node%_modules/.*",  -- npm packages
                ".angular/cache/.*", -- angular cache
                "vendor/*",          -- go dependencies
            },
            mappings = {
                i = {
                    ['<CR>'] = select_one_or_multi,
                }
            },
        },
        pickers = {
            live_grep = {
                additional_args = rg_additional_args
            },
            grep_string = {
                additional_args = rg_additional_args
            },
        },
        extensions = {
            fzf = {
                fuzzy = true,                   -- false will only do exact matching
                override_generic_sorter = true, -- override the generic sorter
                override_file_sorter = true,    -- override the file sorter
                case_mode = "smart_case",       -- or "ignore_case" or "respect_case"
                -- the default case_mode is "smart_case"
            }
        }
    })
end

return M
