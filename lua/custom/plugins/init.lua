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
    opts = {},
  },
}
