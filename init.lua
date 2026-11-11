--[[
  Personal Neovim config (based on kickstart.nvim).

  Layout:
    lua/core/options.lua       core options (leader etc.) - must load first
    lua/core/keymaps.lua       basic keymaps & autocmds
    lua/core/build.lua         post-install build steps for plugins
    lua/core/lsp/              LSP & mason setup (servers, on_attach)
    lua/custom/plugins/*.lua   one file per plugin, auto-loaded in sorted order
                               (better-escape is loaded last, see its init.lua)
    ftplugin/                  filetype-specific setup (e.g. jdtls for java)
]]

require 'core.options'
require 'core.keymaps'
require 'core.build'

-- LSP & mason
require 'core.lsp'

-- Kickstart built-in examples
require 'kickstart.plugins.debug'
require 'kickstart.plugins.autopairs'
require 'kickstart.plugins.neo-tree'
require 'kickstart.plugins.gitsigns' -- adds gitsigns recommended keymaps

-- All other plugins (auto-loads lua/custom/plugins/*.lua)
require 'custom.plugins'

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
