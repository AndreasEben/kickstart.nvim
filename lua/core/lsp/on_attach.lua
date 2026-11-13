-- Callback for the `LspAttach` autocmd
return function(event)
  local map = function(keys, func, desc)
    vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
  end

  -- 0.11 defaults already cover grn (rename), gra (code action) and K (hover).
  -- For navigation, override the built-in defaults with the Snacks picker window.
  local picker = Snacks.picker
  map('gd', function() picker.lsp_definitions() end, 'Definition')
  map('gD', function() picker.lsp_declarations() end, 'Declaration')
  map('grr', function() picker.lsp_references() end, 'References')
  map('gri', function() picker.lsp_implementations() end, 'Implementation')
  map('grt', function() picker.lsp_type_definitions() end, 'Type Definition')
  map('gO', function() picker.lsp_symbols() end, 'Document Symbols')

  -- Highlight references under the cursor
  local client = vim.lsp.get_client_by_id(event.data.client_id)
  if client and client:supports_method('textDocument/documentHighlight', event.buf) then
    local group = vim.api.nvim_create_augroup('lsp-highlight', { clear = false })
    vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
      buffer = event.buf, group = group, callback = vim.lsp.buf.document_highlight,
    })
    vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
      buffer = event.buf, group = group, callback = vim.lsp.buf.clear_references,
    })

    -- Clear highlights and remove the autocmds above when the client detaches,
    -- so they don't accumulate across re-attaches (e.g. server restarts).
    vim.api.nvim_create_autocmd('LspDetach', {
      group = vim.api.nvim_create_augroup('lsp-highlight-detach', { clear = true }),
      callback = function(detach_event)
        vim.lsp.buf.clear_references()
        vim.api.nvim_clear_autocmds { group = 'lsp-highlight', buffer = detach_event.buf }
      end,
    })
  end

  if client and client:supports_method('textDocument/inlayHint', event.buf) then
    map('<leader>th', function()
      vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
    end, 'Toggle Inlay Hints')
  end
end
