-- Snacks.nvim: picker, explorer and related keymaps.
-- Moved out of init.lua (old SECTION 5) so picker config lives with the other
-- per-plugin files. Note: the `gr` prefix is reserved as a *group* for LSP
-- actions (grn/gra/grD from LspAttach, grd from nvim-html-css), so references
-- is bound to `grr` here to avoid shadowing those.
vim.pack.add { 'https://github.com/folke/snacks.nvim' }
require('snacks').setup {
  picker = {
    exclude = { 'node_modules' },
    layout = {
      cycle = true,
      --- Use the default layout or vertical if the window is too narrow
      preset = function() return vim.o.columns >= 200 and 'default' or 'vertical' end,
      layout = {
        width = 0.9,
      },
    },
    win = {
      -- input window
      input = {
        keys = {
          -- to close the picker on ESC instead of going to normal mode
          ['<Esc>'] = { 'close', mode = { 'n', 'i' } },
        },
      },
    },
  },
}

vim.keymap.set('n', '<leader><space>', function() Snacks.picker.smart() end, { desc = 'Smart Find Files' })
vim.keymap.set('n', '<leader>,', function() Snacks.picker.buffers() end, { desc = 'Buffers' })
vim.keymap.set('n', '<leader>/', function() Snacks.picker.grep() end, { desc = 'Grep' })
vim.keymap.set('n', '<leader>e', function() Snacks.explorer() end, { desc = 'File Explorer' })
-- find
vim.keymap.set('n', '<leader>fb', function() Snacks.picker.buffers() end, { desc = 'Buffers' })
vim.keymap.set('n', '<leader>fc', function() Snacks.picker.files { cwd = vim.fn.stdpath 'config' } end, { desc = 'Find Config File' })
vim.keymap.set('n', '<leader>fr', function() Snacks.picker.recent() end, { desc = 'Recent' })
-- grep
vim.keymap.set({ 'n', 'x' }, '<leader>sw', function() Snacks.picker.grep_word() end, { desc = 'Visual selection or word' })
-- search
vim.keymap.set('n', '<leader>s/', function() Snacks.picker.search_history() end, { desc = 'Search History' })
vim.keymap.set('n', '<leader>sd', function() Snacks.picker.diagnostics() end, { desc = 'Diagnostics' })
vim.keymap.set('n', '<leader>sD', function() Snacks.picker.diagnostics_buffer() end, { desc = 'Buffer Diagnostics' })
vim.keymap.set('n', '<leader>sk', function() Snacks.picker.keymaps() end, { desc = 'Keymaps' })
vim.keymap.set('n', '<leader>sq', function() Snacks.picker.qflist() end, { desc = 'Quickfix List' })
vim.keymap.set('n', '<leader>sR', function() Snacks.picker.resume() end, { desc = 'Resume' })
vim.keymap.set('n', '<leader>su', function() Snacks.picker.undo() end, { desc = 'Undo History' })
-- LSP
vim.keymap.set('n', 'gd', function() Snacks.picker.lsp_definitions() end, { desc = 'Goto Definition' })
vim.keymap.set('n', 'gD', function() Snacks.picker.lsp_declarations() end, { desc = 'Goto Declaration' })
vim.keymap.set('n', 'grr', function() Snacks.picker.lsp_references() end, { desc = '[R]eferences' })
vim.keymap.set('n', 'gI', function() Snacks.picker.lsp_implementations() end, { desc = 'Goto Implementation' })
vim.keymap.set('n', 'gy', function() Snacks.picker.lsp_type_definitions() end, { desc = 'Goto T[y]pe Definition' })
vim.keymap.set('n', 'gai', function() Snacks.picker.lsp_incoming_calls() end, { desc = 'C[a]lls Incoming' })
vim.keymap.set('n', 'gao', function() Snacks.picker.lsp_outgoing_calls() end, { desc = 'C[a]lls Outgoing' })
vim.keymap.set('n', '<leader>ss', function() Snacks.picker.lsp_symbols() end, { desc = 'LSP Symbols' })
vim.keymap.set('n', '<leader>sS', function() Snacks.picker.lsp_workspace_symbols() end, { desc = 'LSP Workspace Symbols' })
