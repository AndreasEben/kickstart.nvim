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
      config.settings.sonarlint.connectedMode.project = {
        connectionId = 'sonar',
        projectKey = 'entole',
      }
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
