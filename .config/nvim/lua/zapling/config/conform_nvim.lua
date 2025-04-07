local M = {}

local setup_prettier = function()
    require("conform").formatters.prettier = vim.tbl_deep_extend("force", require("conform.formatters.prettier"), {
        cwd = require('conform.util').root_file({ ".prettierrc" }),
        require_cwd = true,
    })
end

local setup_biome = function()
    require("conform").formatters.biome = vim.tbl_deep_extend("force", require("conform.formatters.biome"), {
        condition = function(ctx)
            local cfg_path = require('zapling.util').find_upwards("biome.json")
            if cfg_path == "" then
                return false
            end

            local cfg = vim.fn.json_decode(require('plenary.path'):new(cfg_path):read())

            if cfg.formatter ~= nil and cfg.formatter.enabled == false then
                return false
            end

            return true
        end,
    })
end

local frontend_formatters = { 'biome', 'prettier' }
local conform_config = {
    formatters_by_ft = {
        -- frontend
        javascript = frontend_formatters,
        javascriptreact = frontend_formatters,
        typescript = frontend_formatters,
        typescriptreact = frontend_formatters,
        html = frontend_formatters,
        htmlangular = frontend_formatters,
        css = frontend_formatters,
        json = frontend_formatters,
    },
}

M.get_filetypes = function()
    local filetypes = {}
    for k, _ in pairs(conform_config['formatters_by_ft']) do
        table.insert(filetypes, k)
    end
    return filetypes
end

M.register_on_save_autocmd = function()
    local js_and_ts_filetypes = { js = 1, jsx = 1, ts = 1, tsx = 1 }
    vim.api.nvim_create_autocmd({ "BufWritePre" }, {
        pattern = "*",
        callback = function(args)
            local file_ext = vim.fn.expand('%:e')
            if js_and_ts_filetypes[file_ext] then
                require("conform").format({ bufnr = args.buf }, function()
                    require('vtsls').commands.add_missing_imports(args.buf)
                end)
                return
            end

            require("conform").format({ bufnr = args.buf, lsp_fallback = true })
        end,
        desc = 'Format with conform.nvim on save, fallbacks to lsp'
    })
end

M.setup = function()
    setup_prettier()
    setup_biome()

    require('conform').setup(conform_config)
    require('mason-conform').setup()
end

return M
