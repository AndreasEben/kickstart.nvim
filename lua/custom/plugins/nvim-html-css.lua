vim.pack.add { 'https://github.com/Jezda1337/nvim-html-css' }
require('html-css').setup {
  enable_on = {
    'html',
    'htmldjango',
    'tsx',
    'jsx',
    'erb',
    'svelte',
    'vue',
    'blade',
    'php',
    'templ',
    'astro',
  },
  handlers = {
    definition = {
      bind = 'grd',
    },
    hover = {
      bind = 'K',
      wrap = true,
      border = 'none',
      position = 'cursor',
    },
  },
  documentation = {
    auto_show = true,
  },
  style_sheets = {},
}
