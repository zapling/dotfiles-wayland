local M = {}

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

M.is_lazy_installed = function()
    if vim.loop.fs_stat(lazypath) then
        return true
    end
    return false
end

M.ensure_lazy_is_installed = function()
    if not vim.loop.fs_stat(lazypath) then
        vim.fn.system({
            "git",
            "clone",
            "--filter=blob:none",
            "https://github.com/folke/lazy.nvim.git",
            "--branch=stable", -- latest stable release
            lazypath,
        })
    end
    vim.opt.rtp:prepend(lazypath)
end

M.setup = function()
    local should_lazyload = M.is_lazy_installed()

    M.ensure_lazy_is_installed()

    require('zapling.plugins').setup(should_lazyload)
    require('zapling.diagnostic').setup()
    require('zapling.options').setup()
    require('zapling.commands').setup()
    require('zapling.autocmds').setup()
    require('zapling.keymaps').setup()
end

return M
