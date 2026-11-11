-- Automatically detect and set the indentation
local gh = require('core.util').gh
vim.pack.add { gh 'NMAC427/guess-indent.nvim' }
require('guess-indent').setup {}
