local null_ls = require("null-ls")
local vtsls = require("vtsls")
local biome = require("biome")

-- vim.keymap.set('', '<Leader>gd', function() vtsls.commands.goto_source_definition() end, {silent = true})

local augroup_typescript = vim.api.nvim_create_augroup('TS_LSP', { clear = true })

vim.api.nvim_create_autocmd({ 'BufWritePre' }, {
  pattern = '*.ts,*.tsx',
  group = augroup_typescript,
  callback = function()
      local clients = vim.lsp.buf_get_clients()

      local servers = {}
      for _, client in pairs(clients) do
          servers[client.name] = 1
      end

      vtsls.commands.add_missing_imports()

      if servers['biome'] then
          biome.format_on_save()
      else
          vim.lsp.buf.format({filter = function(client) return client.name == 'vtsls' end})
      end
  end,
  desc = 'Format buffer before save with client NOT named tsserver',
})
