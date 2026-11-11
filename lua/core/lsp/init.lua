-- LSP & Mason setup.
--  See `:help lsp-vs-treesitter` for an overview of what LSP is.

local gh = require('core.util').gh

-- Useful status updates for LSP.
vim.pack.add { gh 'j-hui/fidget.nvim' }
require('fidget').setup {}

-- Runs when an LSP client attaches to a particular buffer,
-- i.e. every time a new file with an associated language server is opened.
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
  callback = require 'core.lsp.on_attach',
})

vim.pack.add {
  gh 'neovim/nvim-lspconfig',
  gh 'mason-org/mason.nvim',
  gh 'mason-org/mason-lspconfig.nvim',
  gh 'WhoIsSethDaniel/mason-tool-installer.nvim',
}

-- Automatically install LSPs and related tools to stdpath for Neovim
require('mason').setup {}

-- Translates between nvim-lspconfig server names and mason.nvim package names (e.g. lua_ls <-> lua-language-server)
require('mason-lspconfig').setup {
  automatic_enable = false, -- Change this to true if you want to automatically enable servers that are installed manually (e.g. via :Mason / :MasonInstall)
}

-- Ensure the servers and tools below are installed
--
-- To check the current status of installed tools and/or manually install
-- other tools you can run
--    :Mason
--
-- You can press `g?` for help in this menu.
local servers = require 'core.lsp.servers'
local ensure_installed = vim.tbl_keys(servers)
vim.list_extend(ensure_installed, {
  -- You can add other tools here that you want Mason to install
  'java-debug-adapter'
})

require('mason-tool-installer').setup { ensure_installed = ensure_installed }

for name, server in pairs(servers) do
  vim.lsp.config(name, server)
  vim.lsp.enable(name)
end
