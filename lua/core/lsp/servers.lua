-- Language servers to enable. Everything listed here is auto-installed
-- by mason-tool-installer (see core/lsp/init.lua).
--  See `:help lsp-config` for information about keys and how to configure
local mason_packages = vim.fn.join({ vim.fn.stdpath 'data', 'mason', 'packages' }, '/')

---@type table<string, vim.lsp.Config>
return {
  -- clangd = {},
  -- gopls = {},
  -- pyright = {},
  -- rust_analyzer = {},
  --
  -- Some languages (like typescript) have entire language plugins that can be useful:
  --    https://github.com/pmizio/typescript-tools.nvim
  --
  -- But for many setups, the LSP (`ts_ls`) will work just fine
  ts_ls = {},
  jdtls = {},
  html = {},
  gradle_ls = {
    settings = {
      -- derived from mason's install dir instead of a hardcoded absolute path,
      -- so it keeps working after `:MasonUpdate`
      cmd = { mason_packages .. '/gradle-language-server/gradle-language-server' },
    },
  },
  cssls = {},
  eslint = {},
  angularls = {},
  docker_compose_language_service = {},

  stylua = {}, -- Used to format Lua code

  -- Special Lua Config, as recommended by neovim help docs
  lua_ls = {
    on_init = function(client)
      client.server_capabilities.documentFormattingProvider = false -- Disable formatting (formatting is done by stylua)

      if client.workspace_folders then
        local path = client.workspace_folders[1].name
        if path ~= vim.fn.stdpath 'config' and (vim.uv.fs_stat(path .. '/.luarc.json') or vim.uv.fs_stat(path .. '/.luarc.jsonc')) then return end
      end

      local current_settings = client.config.settings --[[@as lspconfig.settings.lua_ls]]
      client.config.settings.Lua = vim.tbl_deep_extend('force', current_settings.Lua, {
        runtime = {
          version = 'LuaJIT',
          path = { 'lua/?.lua', 'lua/?/init.lua' },
        },
        workspace = {
          checkThirdParty = false,
          -- NOTE: this is a lot slower and will cause issues when working on your own configuration.
          --  See https://github.com/neovim/nvim-lspconfig/issues/3189
          library = vim.api.nvim_get_runtime_file('', true),
        },
      })
    end,
    ---@type lspconfig.settings.lua_ls
    settings = {
      Lua = {
        format = { enable = false }, -- Disable formatting (formatting is done by stylua)
      },
    },
  },
}
