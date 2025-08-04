return {
  {
    'https://gitlab.com/schrieveslaach/sonarlint.nvim',
    config = function()
      require('sonarlint').setup {
        connected = {
          -- client_id is the ID of the Sonar LSP
          -- url is the url it wants to connect to
          get_credentials = function(client_id, url)
            -- This must return a string (User token)
            -- This is the default function. You can just set the environment variable.
            return vim.fn.getenv 'SONAR_TOKEN'
          end,
        },
        server = {
          cmd = {
            'sonarlint-language-server',
            -- Ensure that sonarlint-language-server uses stdio channel
            '-stdio',
            '-analyzers',
            vim.fn.expand '/home/sxae55/.local/share/nvim/mason/share/sonarlint-analyzers/sonarjava.jar',
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
            -- Your personal configuration needs to provide a mapping of root folders and project keys
            --
            -- In the future a integration with https://github.com/folke/neoconf.nvim or some similar
            -- plugin, might be worthwhile.
            local project_root_and_ids = {
              ['/home/sxae55/projects/mcop2/mcop2-main/'] = 'mcop2-main',
              -- … further mappings …
            }

            config.settings.sonarlint.connectedMode.project = {
              connectionId = 'sonar',
              projectKey = project_root_and_ids[params.rootPath],
            }
          end,
        },
        filetypes = {
          'java',
        },
      }
    end,
  },
}
