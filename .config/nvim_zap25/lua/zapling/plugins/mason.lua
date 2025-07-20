local plugin_conform = require('zapling.plugins.conform')
local plugin_nvim_lint = require('zapling.plugins.nvim_lint')

return {
    'mason-org/mason.nvim',
    priority = 60,
    dependencies = {
        'neovim/nvim-lspconfig',
        'stevearc/conform.nvim',
        'mfussenegger/nvim-lint',
        'WhoIsSethDaniel/mason-tool-installer.nvim',
        'zapling/mason-lock.nvim',
    },
    cmd = function()
        local cmd = { 'Mason', 'MasonInstall', 'MasonLock', 'MasonLockRestore' }
        vim.list_extend(cmd, plugin_conform.cmd)
        vim.list_extend(cmd, plugin_nvim_lint.cmd)
        return cmd
    end,
    event = function()
        local event = { 'LspAttach' }
        vim.list_extend(event, plugin_conform.event)
        vim.list_extend(event, plugin_nvim_lint.event)
    end,
    ft = function()
        local ft = {}
        vim.list_extend(ft, plugin_conform.ft)
        vim.list_extend(ft, plugin_nvim_lint.ft)
    end,
    config = function()
        -- lsp server name to mason package name
        local lsp_to_mason_package = {
            ["lua_ls"] = "lua-language-server",
            ["bashls"] = "bash-language-server",

            ["angularls"] = "angular-language-server",
            ["cssls"] = "css-lsp",
            ["eslint"] = "eslint-lsp",
        }

        -- nvim/lint name to mason package name
        local lint_to_mason_package = {
            ["golangcilint"] = "golangci-lint"
        }

        -- If one mason package should also bring in other mason packages, but those here.
        local mason_package_dependencies = {
            ["bash-language-server"] = { "shellcheck" }
        }

        require('mason').setup({
            -- install_root_dir = os.getenv('HOME') .. '.local/bin/nvim-mason2',
            -- PATH = 'skip',
        })
        require('mason-lock').setup({})

        local packages = {}

        -- lsp to mason
        for client_name in pairs(vim.lsp._enabled_configs) do
            local package_name = client_name
            local mason_package_name = lsp_to_mason_package[client_name]
            if mason_package_name ~= nil then
                package_name = mason_package_name
            end
            packages[package_name] = 1
        end

        -- conform to mason
        for _, formatters in pairs(require('conform').formatters_by_ft) do
            if type(formatters) == "table" then
                for key, formatter in pairs(formatters) do
                    if type(key) == "number" then
                        packages[formatter] = 1
                    end
                end
            end
        end

        -- nvim-lint to mason
        for _, linters in pairs(require('lint').linters_by_ft) do
            for _, linter in pairs(linters) do
                local package_name = linter
                local mason_package_name = lint_to_mason_package[linter]
                if mason_package_name ~= nil then
                    package_name = mason_package_name
                end
                packages[package_name] = 1
            end
        end

        -- optional mason package dependencies
        for package_name in pairs(packages) do
            local dependencies = mason_package_dependencies[package_name]
            if dependencies ~= nil then
                for _, mason_pkg in pairs(dependencies) do
                    packages[mason_pkg] = 1
                end
            end
        end

        local ensure_installed = {}
        for package_name in pairs(packages) do
            table.insert(ensure_installed, package_name)
        end

        require('mason-tool-installer').setup({ ensure_installed = ensure_installed })
    end,
}
