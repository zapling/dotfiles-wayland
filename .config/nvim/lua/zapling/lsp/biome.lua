local util = require('lspconfig.util')

local M = {}

M.config = {
    root_dir = util.root_pattern('biome.js'),
    single_file_support = false,
}

return M
