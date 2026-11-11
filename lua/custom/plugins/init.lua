-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information

-- Iterate over all Lua files in the plugins directory and load them
-- in sorted (deterministic) order. better-escape is loaded last so it
-- can patch all keymaps created by the other plugins.
local plugins_dir = vim.fs.joinpath(vim.fn.stdpath 'config', 'lua', 'custom', 'plugins')
local modules = {}
for file_name, type in vim.fs.dir(plugins_dir, { follow = true }) do
  if (type == 'file' or type == 'link') and file_name:match '%.lua$' and file_name ~= 'init.lua' then
    modules[#modules + 1] = file_name:gsub('%.lua$', '')
  end
end
table.sort(modules)

for _, module in ipairs(modules) do
  if module ~= 'better-escape' then
    require('custom.plugins.' .. module)
  end
end

-- Load better-escape last so it wraps all keymaps set by other plugins
if vim.tbl_contains(modules, 'better-escape') then
  require('custom.plugins.better-escape')
end
