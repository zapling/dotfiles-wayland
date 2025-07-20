local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
            { out,                            "WarningMsg" },
            { "\nPress any key to exit..." },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
end
vim.opt.rtp:prepend(lazypath)

if vim.tbl_count(vim.fn.argv()) == 0 then
    local augroup = vim.api.nvim_create_augroup('zapling-lazy', { clear = true })
    vim.api.nvim_create_autocmd("User", {
        pattern = "LazyVimStarted",
        group = augroup,
        callback = function()
            vim.defer_fn(function()
                local stats = require("lazy").stats()
                if stats.startuptime > 100 then
                    vim.notify("Startup time over 100ms: " .. stats.startuptime .. "ms", vim.log.levels.WARN)
                end
            end, 100)
        end,
    })
end

local initial_boot_performed = vim.fn.stdpath('data') .. '/initial_boot_performed'
if not (vim.uv or vim.loop).fs_stat(initial_boot_performed) then
    vim.api.nvim_create_autocmd('UIEnter', {
        callback = function()
            require('lazy.view').view:close()
            require("mason-registry").update(function()
                vim.cmd [[ MasonLockRestore ]]
                vim.cmd [[ Mason ]]
                vim.fn.writefile({ '' }, initial_boot_performed, 's')
            end)
        end,
        once = true
    })
end

require("lazy").setup({
    spec = {
        { import = "zapling.plugins" },
    },
    install = { colorscheme = { "habamax" } },
    checker = { enabled = false },
})
