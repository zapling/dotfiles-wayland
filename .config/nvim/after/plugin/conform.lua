local path = require('plenary.path')
local util = require("conform.util")
local vtsls = require("vtsls")

-- TODO: mason integration somehow?

-- exists in plenary but have unresolved bug where
-- the scanning get stuck on root
-- https://github.com/nvim-lua/plenary.nvim/pull/506
function find_upwards(filename)
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

require("conform").formatters.prettier = vim.tbl_deep_extend("force", require("conform.formatters.prettier"), {
    cwd = util.root_file({ ".prettierrc" }),
    require_cwd = true,
})

require("conform").formatters.biome = vim.tbl_deep_extend("force", require("conform.formatters.biome"), {
    condition = function(ctx)
        local cfg_path = find_upwards("biome.json")
        if cfg_path == "" then
            return false
        end

        local cfg = vim.fn.json_decode(path:new(cfg_path):read())

        if cfg.formatter ~= nil and cfg.formatter.enabled == false then
            return false
        end

        return true
    end,
})

local frontend_fmt = { 'biome', 'prettier' }

require("conform").setup({
    formatters_by_ft = {
        -- frontend
        javascript = frontend_fmt,
        javascriptreact = frontend_fmt,
        typescript = frontend_fmt,
        typescriptreact = frontend_fmt,
        html = frontend_fmt,
        css = frontend_fmt,
    },
})

local js_and_ts_filetypes = { js = 1, jsx = 1, ts = 1, tsx = 1 }

vim.api.nvim_create_autocmd({ "BufWritePre" }, {
    pattern = "*",
    callback = function(args)
        local file_ext = vim.fn.expand('%:e')
        if js_and_ts_filetypes[file_ext] then
            vtsls.commands.add_missing_imports()
            require("conform").format({ bufnr = args.buf })
            return
        end

        require("conform").format({ bufnr = args.buf, lsp_fallback = true })
    end,
    desc = 'Format with conform.nvim on save'
})
