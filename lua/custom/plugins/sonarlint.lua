vim.pack.add { 'https://gitlab.com/schrieveslaach/sonarlint.nvim' }
local analyzers_dir = vim.fn.join({ vim.fn.stdpath 'data', 'mason', 'share', 'sonarlint-analyzers' }, '/')
require('sonarlint').setup {
  connected = {
    get_credentials = function(client_id, url)
      return vim.fn.getenv 'SONAR_TOKEN'
    end,
  },
  server = {
    cmd = {
      'sonarlint-language-server',
      '-stdio',
      '-analyzers',
      analyzers_dir .. '/sonarjava.jar',
      analyzers_dir .. '/sonarjs.jar',
      analyzers_dir .. '/sonarhtml.jar',
      analyzers_dir .. '/sonarxml.jar',
    },
    settings = {
      sonarlint = {
        connectedMode = {
          connections = {
            sonarqube = {
              {
                connectionId = 'sonar',
                serverUrl = 'https://sonar.siteos-lokal.de',
                disableNotifications = false,
              },
            },
          },
        },
      },
    },
    before_init = function(params, config)
      local root = config.root_dir or vim.fn.getcwd()
      local props_file = root .. '/sonar-project.properties'
      if vim.uv.fs_stat(props_file) then
        local f = io.open(props_file, 'r')
        if f then
          for line in f:lines() do
            local key = line:match('^sonar%.projectKey%s*=%s*(.-)%s*$')
            if key then
              config.settings.sonarlint.connectedMode.project = {
                connectionId = 'sonar',
                projectKey = key,
              }
              break
            end
          end
          f:close()
        end
      end
      -- no sonar-project.properties → connectedMode.project stays unset
      -- → SonarLint runs in standalone (local) mode for that project
    end,
  },
  filetypes = {
    'java',
    'typescript',
    'typescriptreact',
    'html',
    'xml',
  },
}
