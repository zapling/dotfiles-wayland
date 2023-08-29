local null_ls = require("null-ls")
local vtsls = require("vtsls")
local Job = require'plenary.job'
local path = require'plenary.path'

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

      if servers['rome'] then
          local rome_cfg_path = path:new("."):find_upwards("rome.json")
          local rome_cfg = path:new(rome_cfg_path):read()
          local rome_cfg_json = vim.fn.json_decode(rome_cfg)

          if rome_cfg_json.formatter == nil then
              return
          end

          if rome_cfg_json.formatter.enabled ~= true then
              return
          end

          local bufnr = vim.fn.bufnr("%")
          local filename = vim.fn.expand('%')
          local buffer_lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
          local buffer_content = table.concat(buffer_lines, '\n')

          local rome_formatter_output = nil
          Job:new({
              command = 'rome',
              args = {'format', '--stdin-file-path='..filename},
              writer = buffer_content,
              on_exit = function(result, exit_code)
                  if exit_code ~= 0 then
                      return
                  end
                  rome_formatter_output = result:result()
              end,
          }):sync()

          vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, rome_formatter_output)
      else
          vim.lsp.buf.format({filter = function(client) return client.name == 'vtsls' end})
      end

      vtsls.commands.add_missing_imports()
  end,
  desc = 'Format buffer before save with client NOT named tsserver',
})

vim.api.nvim_create_autocmd({ 'TextChanged', 'TextChangedI' }, {
  pattern = '*.ts,*.tsx',
  group = augroup_typescript,
  callback = function()
      local source = null_ls.get_source({
          name = "eslint_d",
          method = null_ls.methods.DIAGNOSTICS
      })[1]

      if source == nil then
          return
      end

      local namespace = require("null-ls.diagnostics").get_namespace(source.id)
      if namespace ~= nil then
          vim.diagnostic.reset(namespace)
      end
  end,
  desc = 'Reset/Clear eslint diagnostics when text is changed',
})

