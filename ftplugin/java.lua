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
    -- projectName = function()
    --   return os.getenv("JAVA_PROJECT_NAME") or vim.fn.input("Project Name: ")
    -- end,
  }
end

dap.configurations.java = {
  create_java_attach_config("Debug (Attach) - Remote 8000", 8000),
  create_java_attach_config("Debug (Attach) - Remote 8100", 8100),
  create_java_attach_config("Debug (Attach) - Remote 5005", 5005),
}

local on_attach = function(client, bufnr)
  require('jdtls').setup_dap { hotcodereplace = 'auto' }
  require('jdtls.dap').setup_dap_main_class_configs()
  -- Other on_attach configurations...
end

local mason_packages = vim.fn.join({ vim.fn.stdpath 'data', 'mason', 'packages' }, '/')

local workspace_dir = vim.fn.join({ vim.fn.stdpath 'data', 'workspaces', root }, '/')
--                                                                  ^^
--                                                                  string concatenation in Lua

-- jdtls ships a versioned launcher jar; pick the newest one mason has installed
local launchers = vim.fn.glob(mason_packages .. '/jdtls/plugins/org.eclipse.equinox.launcher_*.jar', true, true)
assert(#launchers > 0, 'jdtls launcher jar not found, run :MasonInstall jdtls')
table.sort(launchers)
local launcher = launchers[#launchers]

-- See `:help vim.lsp.start_client` for an overview of the supported `config` options.
local config = {
  -- The command that starts the language server
  -- See: https://github.com/eclipse/eclipse.jdt.ls#running-from-the-command-line
  cmd = {

    -- 💀
    -- 'java', -- or '/path/to/java17_or_newer/bin/java'
    '/usr/lib/jvm/java-25-openjdk/bin/java',
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
    launcher,
    -- ^^^^^^ resolved above via glob, survives `:MasonUpdate`

    -- 💀
    -- '-configuration', '/path/to/jdtls_install_location/config_SYSTEM',
    '-configuration',
    mason_packages .. '/jdtls/config_linux',
    -- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ one of `linux`, `win` or `mac`, depending on your system

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
          {
            name = "JavaSE-17",
            path = "/usr/lib/jvm/java-17-temurin-jdk",
          },
          {
            name = 'JavaSE-25',
            path = '/usr/lib/jvm/java-25-openjdk',
          },
        },
      }, -- }
      compile = {
        nullAnalysis = {
          mode = "automatic",
          nullable = { "org.jspecify.annotations.Nullable" },
          nonnull = { "org.jspecify.annotations.NonNull" },
          nonnullbydefault = { "org.jspecify.annotations.NullMarked" },
        },
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
    bundles = vim.fn.glob(mason_packages .. '/java-debug-adapter/extension/server/com.microsoft.java.debug.plugin-*.jar', true, true),
  },
  ['on_attach'] = on_attach,
  -- jdtls also reports diagnostics for files in build output dirs (bin/, build/,
  -- target/), e.g. "type already defined" for JPA metamodel classes that exist in
  -- both bin/generated-sources and build/generated. That's noise for the
  -- workspace-diagnostics picker, so swallow it.
  handlers = {
    -- NOTE: Lua patterns have no `|` alternation, hence the plain :find calls
    ['textDocument/publishDiagnostics'] = function(err, params, ctx)
      local path = vim.uri_to_fname(params.uri)
      if path:find('/bin/', 1, true) or path:find('/build/', 1, true) or path:find('/target/', 1, true) then
        return
      end
      return vim.lsp.diagnostic.on_publish_diagnostics(err, params, ctx)
    end,
  },
}

-- This starts a new client & server,
-- or attaches to an existing client & server depending on the `root_dir`.
require('jdtls').start_or_attach(config)
