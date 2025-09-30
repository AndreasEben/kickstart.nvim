-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
return {
  {
    'max397574/better-escape.nvim',
    config = function()
      require('better_escape').setup()
    end,
  },
  {
    'iamcco/markdown-preview.nvim',
    cmd = { 'MarkdownPreviewToggle', 'MarkdownPreview', 'MarkdownPreviewStop' },
    build = 'nvm use 20 && cd app && yarn install',
    init = function()
      vim.g.mkdp_filetypes = { 'markdown', 'puml' }
      vim.g.mkdp_port = 4300
      vim.g.mkdp_browser = 'none'
    end,
    ft = { 'markdown' },
  },
  { 'artempyanykh/marksman' },
  {
    'stevearc/oil.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    opts = {},
  },
  {
    'folke/flash.nvim',
    event = 'VeryLazy',
    opts = {},
    keys = {
      {
        'S',
        mode = { 'n', 'x', 'o' },
        function()
          require('flash').jump()
        end,
        desc = 'Flash',
      },
    },
  },
  { 'sindrets/diffview.nvim' },
  {
    'JoosepAlviste/nvim-ts-context-commentstring',
    config = function()
      require('ts_context_commentstring').setup {
        enable_autocmd = false,
      }
    end,
  },
  {
    'chentoast/marks.nvim',
    event = 'VeryLazy',
    config = function()
      require('marks').setup()
    end,
  },
  {
    'weirongxu/plantuml-previewer.vim',
    ft = { 'plantuml', 'puml', 'uml' }, -- optional: load only for PlantUML files
    dependencies = {
      'tyru/open-browser.vim',
      'aklt/plantuml-syntax',
    },
  },
  { 'aklt/plantuml-syntax', ft = { 'plantuml', 'puml', 'uml' } },
  -- Open browser support
  { 'tyru/open-browser.vim', lazy = true },
  {
    'folke/tokyonight.nvim',
    lazy = false,
    priority = 1000,
    opts = {
      style = 'moon',
      on_colors = function(colors)
        colors.fg_gutter = '#505878'
      end
    },
  },
  {
    'ThePrimeagen/harpoon',
    config = function()
      require('harpoon').setup {
        menu = {
          width = vim.api.nvim_win_get_width(0) - 4,
        },
      }
      vim.keymap.set('n', '<leader>a', require('harpoon.mark').add_file, { desc = 'Add file to harpoon list' })
      vim.keymap.set('n', '<leader>l', require('harpoon.ui').toggle_quick_menu, { desc = 'Toggle harpoon menu' })
      vim.keymap.set('n', '<leader>n', require('harpoon.ui').nav_next, { desc = 'Navigate to [n]ext harpoon mark' })
      vim.keymap.set('n', '<leader>p', require('harpoon.ui').nav_prev, { desc = 'Navigate to [p]revious harpoon mark' })
      for i = 1, 9 do
        vim.keymap.set('n', '<leader>' .. i, function()
          require('harpoon.ui').nav_file(i)
        end, { desc = 'Go to harpoon file ' .. i })
      end
    end,
  },
}
