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

local map = vim.keymap.set

-- top level
map('n', '<leader><space>', Snacks.picker.smart, { desc = 'Smart Find Files' })
map('n', '<leader>,', Snacks.picker.buffers, { desc = 'Buffers' })
map('n', '<leader>/', Snacks.picker.grep, { desc = 'Grep' })
map('n', '<leader>e', function() Snacks.explorer() end, { desc = 'File Explorer' })

-- find
map('n', '<leader>fc', function() Snacks.picker.files { cwd = vim.fn.stdpath 'config' } end, { desc = 'Config Files' })
map('n', '<leader>fr', Snacks.picker.recent, { desc = 'Recent' })

-- grep
map({ 'n', 'x' }, '<leader>sw', Snacks.picker.grep_word, { desc = 'Visual selection or word' })

-- search
map('n', '<leader>s/', Snacks.picker.search_history, { desc = 'Search History' })
map('n', '<leader>sd', Snacks.picker.diagnostics, { desc = 'Diagnostics' })
map('n', '<leader>sD', Snacks.picker.diagnostics_buffer, { desc = 'Buffer Diagnostics' })
map('n', '<leader>sk', Snacks.picker.keymaps, { desc = 'Keymaps' })
map('n', '<leader>sq', Snacks.picker.qflist, { desc = 'Quickfix List' })
map('n', '<leader>sR', Snacks.picker.resume, { desc = 'Resume' })
map('n', '<leader>su', Snacks.picker.undo, { desc = 'Undo History' })
map('n', '<leader>ss', Snacks.picker.lsp_symbols, { desc = 'LSP Symbols' })
map('n', '<leader>sS', Snacks.picker.lsp_workspace_symbols, { desc = 'LSP Workspace Symbols' })

-- LSP call hierarchy (not covered by Neovim's built-in defaults)
map('n', 'gai', Snacks.picker.lsp_incoming_calls, { desc = 'C[a]lls Incoming' })
map('n', 'gao', Snacks.picker.lsp_outgoing_calls, { desc = 'C[a]lls Outgoing' })
