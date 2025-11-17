return {
    "ibhagwan/fzf-lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    lazy = true,
    cmd = 'FzfLua',
    opts = {
        grep = {
            hidden = true
        }
    }
}
