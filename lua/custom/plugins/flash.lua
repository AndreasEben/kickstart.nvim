vim.pack.add { 'https://github.com/folke/flash.nvim' }
require('flash').setup {}
vim.keymap.set({ 'n', 'x', 'o' }, 'S', function() require('flash').jump() end, { desc = 'Flash' })
-- return {
--   'folke/flash.nvim',
--   event = 'VeryLazy',
--   opts = {},
--   keys = {
--     {
--       'S',
--       mode = { 'n', 'x', 'o' },
--       function() require('flash').jump() end,
--       desc = 'Flash',
--     },
--   },
-- }
