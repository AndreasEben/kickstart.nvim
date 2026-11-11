local M = {}

--- Shortcut to build a github URL for `vim.pack` specs.
---@param repo string
---@return string
function M.gh(repo)
  return 'https://github.com/' .. repo
end

return M
