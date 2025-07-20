-- No automatic insert of comment leader of 'o' and 'O'.
-- This override is needed in here because the lua ftplugin sets 'o' by default.
vim.opt_local.formatoptions:remove { 'o' }
