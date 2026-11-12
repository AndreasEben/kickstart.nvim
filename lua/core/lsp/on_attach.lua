-- Callback for the `LspAttach` autocmd
return function(event)
  local map = function(keys, func, desc)
    vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
  end

  -- 0.11 defaults already cover grn, gra, grr, gri, grt, gO and K.
  -- Only add what isn't built in: gd/gD, which would otherwise be Vim's local search.
  map('gd', vim.lsp.buf.definition, 'Definition')
  map('gD', vim.lsp.buf.declaration, 'Declaration')

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
