-- If you started neovim within `~/dev/xy/project-1` this would resolve to `project-1`
local root = vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')

local dap = require 'dap'

local function create_java_attach_config(name, port)
  return {
    type = "java",
    request = "attach",
    name = name,
    hostName = "127.0.0.1",
    port = port,
    projectName = function()
      return os.getenv("JAVA_PROJECT_NAME") or vim.fn.input("Project Name: ")
    end,
  }
end

dap.configurations.java = {
  create_java_attach_config("Debug (Attach) - Remote 8000", 8000),
  create_java_attach_config("Debug (Attach) - Remote 8100", 8100),
}

local on_attach = function(client, bufnr)
  require('jdtls').setup_dap { hotcodereplace = 'auto' }
  require('jdtls.dap').setup_dap_main_class_configs()
  -- Other on_attach configurations...
end

local workspace_dir = '/home/sxae55/.local/share/nvim/workspaces/' .. root
--                                               ^^
--                                               string concattenation in Lua

-- See `:help vim.lsp.start_client` for an overview of the supported `config` options.
local config = {
  -- The command that starts the language server
  -- See: https://github.com/eclipse/eclipse.jdt.ls#running-from-the-command-line
  cmd = {

    -- 💀
    -- 'java', -- or '/path/to/java17_or_newer/bin/java'
    '/usr/lib/jvm/java-21-openjdk/bin/java',
    -- depends on if `java` is in your $PATH env variable and if it points to the right version.

    '-Declipse.application=org.eclipse.jdt.ls.core.id1',
    '-Dosgi.bundles.defaultStartLevel=4',
    '-Declipse.product=org.eclipse.jdt.ls.core.product',
    '-Dlog.protocol=true',
    '-Dlog.level=ALL',
    '-Xmx1g',
    '--add-modules=ALL-SYSTEM',
    '--add-opens',
    'java.base/java.util=ALL-UNNAMED',
    '--add-opens',
    'java.base/java.lang=ALL-UNNAMED',

    -- 💀
    -- '-jar', '/path/to/jdtls_install_location/plugins/org.eclipse.equinox.launcher_VERSION_NUMBER.jar',
    '-jar',
    '/home/sxae55/.local/share/nvim/mason/packages/jdtls/plugins/org.eclipse.equinox.launcher_1.7.0.v20250331-1702.jar',
    -- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^                                       ^^^^^^^^^^^^^^
    -- Must point to the                                                     Change this to
    -- eclipse.jdt.ls installation                                           the actual version

    -- 💀
    -- '-configuration', '/path/to/jdtls_install_location/config_SYSTEM',
    '-configuration',
    '/home/sxae55/.local/share/nvim/mason/packages/jdtls/config_linux',
    -- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^        ^^^^^^
    -- Must point to the                      Change to one of `linux`, `win` or `mac`
    -- eclipse.jdt.ls installation            Depending on your system.

    -- 💀
    -- See `data directory configuration` section in the README
    -- '-data', '/path/to/unique/per/project/workspace/folder'
    '-data',
    workspace_dir,
  },

  -- 💀
  -- This is the default if not provided, you can remove it. Or adjust as needed.
  -- One dedicated LSP server & client will be started per unique root_dir
  --
  -- vim.fs.root requires Neovim 0.10.
  -- If you're using an earlier version, use: require('jdtls.setup').find_root({'.git', 'mvnw', 'gradlew'}),
  root_dir = vim.fs.root(0, { '.git', 'mvnw', 'gradlew' }),

  -- Here you can configure eclipse.jdt.ls specific settings
  -- See https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
  -- for a list of options
  settings = {
    java = {
      configuration = {
        runtimes = {
          -- {
          --   name = "JavaSE-17",
          --   path = "/usr/lib/jvm/java-17-openjdk",
          -- },
          {
            name = 'JavaSE-21',
            path = '/usr/lib/jvm/java-21-openjdk',
          },
        },
      }, -- }
      format = {
        enabled = true,
        settings = {
          url = '/home/sxae55/.config/code_conventions.xml',
          profile = "My Java Conventions"
        }
      }
      -- maybe needed in the future?
      -- maven = {
      --   -- userSettings = '/home/sxae55/.m2/settings.xml'
      --   updateSnapshots = true,
      --   downloadSources = true
    },
  },

  -- Language server `initializationOptions`
  -- You need to extend the `bundles` with paths to jar files
  -- if you want to use additional eclipse.jdt.ls plugins.
  --
  -- See https://github.com/mfussenegger/nvim-jdtls#java-debug-installation
  --
  -- If you don't plan on using the debugger or other eclipse.jdt.ls plugins you can remove this
  init_options = {
    bundles = {
      vim.fn.glob '/home/sxae55/.local/share/nvim/mason/packages/java-debug-adapter/extension/server/com.microsoft.java.debug.plugin-0.53.1.jar',
    },
  },
  ['on_attach'] = on_attach,
}

-- This starts a new client & server,
-- or attaches to an existing client & server depending on the `root_dir`.
require('jdtls').start_or_attach(config)
