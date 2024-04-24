return {
    mapping = {
        ['<C-d>'] = require('cmp').mapping(require('cmp').mapping.scroll_docs(-4), { 'i', 'c' }),
        ['<C-f>'] = require('cmp').mapping(require('cmp').mapping.scroll_docs(4), { 'i', 'c' }),
        ['<C-Space>'] = require('cmp').mapping(require('cmp').mapping.complete(), { 'i', 'c' }),
        ['<C-e>'] = require('cmp').mapping({
            i = require('cmp').mapping.abort(),
            c = require('cmp').mapping.close(),
        }),
        ['<CR>'] = require('cmp').mapping.confirm({ select = true }),
        ['<Up>'] = require('cmp').mapping(require('cmp').mapping.select_prev_item(), { 'i', 'c' }),
        ['<Down>'] = require('cmp').mapping(require('cmp').mapping.select_next_item(), { 'i', 'c' }),
        ["<Tab>"] = function(fallback)
            if require('cmp').visible() then
                require('cmp').select_next_item()
            else
                fallback()
            end
        end,
        ["<S-Tab>"] = function(fallback)
            if require('cmp').visible() then
                require('cmp').select_prev_item()
            else
                fallback()
            end
        end,
    },

    sources = {
        { name = "nvim_lsp" },
        { name = "nvim_lua" },
        -- { name = "luasnip" },
        { name = "buffer",  keyword_length = 5 },
        { name = 'orgmode' },
        { name = "path" },
    },

    snippet = {
        expand = function(args)
            require("luasnip").lsp_expand(args.body)
        end,
    },
    formatting = {
        format = require("lspkind").cmp_format(
            {
                with_text = false,
                maxwidth = 50,
                menu = ({
                    buffer = "[BUF]",
                    nvim_lsp = "[LSP]",
                    luasnip = "[SNIP]",
                    nvim_lua = "[LUA]",
                })
            }
        )
    },
}
