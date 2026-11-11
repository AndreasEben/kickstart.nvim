-- Highlight todo, notes, etc in comments
local gh = require('core.util').gh
vim.pack.add { gh 'folke/todo-comments.nvim' }
require('todo-comments').setup { signs = false }
