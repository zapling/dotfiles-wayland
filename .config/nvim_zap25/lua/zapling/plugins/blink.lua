return {
    'saghen/blink.cmp',
    dependencies = { 'rafamadriz/friendly-snippets' },
    version = '1.*',
    opts = {
        keymap = { preset = 'enter' },

        signature = {
            enabled = true
        },

        appearance = {
            nerd_font_variant = 'mono'
        },

        completion = {
            documentation = {
                auto_show = true,
                auto_show_delay_ms = 0, -- Is is bad to set this to zero?
            }
        },

        cmdline = {
            enabled = false,
        },

        sources = {
            default = { 'lsp', 'path', 'snippets', 'buffer' },
        },

        fuzzy = { implementation = "prefer_rust_with_warning" }
    },
    opts_extend = { "sources.default" }
}
