return {
  'stevearc/conform.nvim',
  event = { 'BufWritePre' },
  cmd = { 'ConformInfo' },
  keys = {
    {
      '<leader>f',
      function()
        require('conform').format { async = true, lsp_format = 'fallback' }
      end,
      mode = '',
      desc = '[F]ormat buffer',
    },
  },
  opts = {
    notify_on_error = false,
    -- format_on_save = function(bufnr)
    -- Disable "format_on_save lsp_fallback" for languages that don't
    -- have a well standardized coding style. You can add additional
    -- languages here or re-enable it for the disabled ones.
    -- comment out?
    --   local disable_filetypes = { c = true, cpp = true }
    --   if disable_filetypes[vim.bo[bufnr].filetype] then
    --     return nil
    --   else
    --     return {
    --       timeout_ms = 500,
    --       lsp_format = 'fallback',
    --     }
    --   end
    -- end,
    formatters_by_ft = {
      lua = { 'stylua' },
      -- use jdtls lsp if eclipse style code_conventions.xml found in project root
      -- !! as of now this is only a trigger, doesnt actually use this file, jdtls looks for this file in ~/.config
      java = function()
        local eclipse = vim.fs.root(0, 'code_conventions.xml')
        if eclipse then
          return { 'spotless_maven' }
        end
        return { 'prettier' }
      end,
      javascript = { 'prettier' },
      typescript = { 'prettier' },
      typescriptreact = { 'prettier' },
      javascriptreact = { 'prettier' },
      css = { 'prettier' },
      html = { 'prettier' },
      json = { 'prettier' },
      yaml = { 'prettier' },
      xml = { 'prettier' },
    },
    -- support for spotless added with https://github.com/stevearc/conform.nvim/pull/754
    -- overridden to use mvn instead of ./mvnw and due to pom.xml not in root
    formatters = {
      spotless_maven = {
        inherit = false,
        command = 'mvn',
        args = function(_, ctx)
          return {
            'spotless:apply',
            '-DspotlessIdeHook=' .. ctx.filename,
            '-DspotlessIdeHookUseStdIn',
            '-DspotlessIdeHookUseStdOut',
            '--quiet',
          }
        end,
        cwd = function()
          -- Absolute path to the subdir with the pom.xml:
          -- TODO: make generally viable
          return '/home/sxae55/projects/mcop2/mcop2-main/siteos.flos.parent'
        end,
        require_cwd = true,
        stdin = true,
      },
    },
  },
}
