vim.pack.add { 'https://gitlab.com/schrieveslaach/sonarlint.nvim' }
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
      vim.fn.expand '/home/sxae55/.local/share/nvim/mason/share/sonarlint-analyzers/sonarjava.jar',
      vim.fn.expand '/home/sxae55/.local/share/nvim/mason/share/sonarlint-analyzers/sonarjs.jar',
      vim.fn.expand '/home/sxae55/.local/share/nvim/mason/share/sonarlint-analyzers/sonarhtml.jar',
      vim.fn.expand '/home/sxae55/.local/share/nvim/mason/share/sonarlint-analyzers/sonarxml.jar',
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
