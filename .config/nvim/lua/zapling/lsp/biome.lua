local util = require('lspconfig.util')

local M = {}

M.config = {
    root_dir = util.root_pattern('biome.json'),
    single_file_support = false,
}

return M
