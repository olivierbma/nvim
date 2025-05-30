vim.bo.tabstop = 2      -- size of a hard tabstop (ts).
vim.bo.shiftwidth = 2   -- size of an indentation (sw).
vim.bo.expandtab = true -- always uses spaces instead of tab characters (et).
vim.bo.softtabstop = 2  -- number of spaces a <Tab> counts for. When 0, feature is off (sts).
vim.o.pumheight = 7

vim.opt.colorcolumn = "80"
local java_cmds = vim.api.nvim_create_augroup('java_cmds', { clear = true })
local cache_vars = {}

local root_files = {
  '.git',
  'mvnw',
  'gradlew',
  'pom.xml',
  'build.gradle'
}

local features = {
  -- change this to `true` to enable codelens
  codelens = true,

  -- change this to `true` if you have `nvim-dap`,
  -- `java-test` and `java-debug-adapter` installed
  debugger = true,
}

local function get_jdtls_paths()
  if cache_vars.paths then
    return cache_vars.paths
  end

  local path = {}

  path.data_dir = vim.fn.stdpath('cache') .. '/nvim-jdtls'

  local jdtls_install = require('mason-registry')
      .get_package('jdtls')
      :get_install_path()

  path.java_agent = jdtls_install .. '/lombok.jar'
  path.launcher_jar = vim.fn.glob(jdtls_install .. '/plugins/org.eclipse.equinox.launcher_*.jar')

  if vim.fn.has('mac') == 1 then
    path.platform_config = jdtls_install .. '/config_mac'
  elseif vim.fn.has('unix') == 1 then
    path.platform_config = jdtls_install .. '/config_linux'
  elseif vim.fn.has('win32') == 1 then
    path.platform_config = jdtls_install .. '/config_win'
  end

  path.bundles = {}


  ---
  -- Include java-test bundle if present
  ---
  local java_test_path = require('mason-registry')
      .get_package('java-test')
      :get_install_path()

  local java_test_bundle = vim.split(
    vim.fn.glob(java_test_path .. '/extension/server/*.jar'),
    '\n'
  )

  if java_test_bundle[1] ~= '' then
    vim.list_extend(path.bundles, java_test_bundle)
  end

  ---
  -- Include java-debug-adapter bundle if present
  ---
  local java_debug_path = require('mason-registry')
      .get_package('java-debug-adapter')
      :get_install_path()

  local java_debug_bundle = vim.split(
    vim.fn.glob(java_debug_path .. '/extension/server/com.microsoft.java.debug.plugin-*.jar'),
    '\n'
  )

  if java_debug_bundle[1] ~= '' then
    vim.list_extend(path.bundles, java_debug_bundle)
  end

  ---
  -- Useful if you're starting jdtls with a Java version that's
  -- different from the one the project uses.
  ---
  path.runtimes = {
    -- Note: the field `name` must be a valid `ExecutionEnvironment`,
    -- you can find the list here:
    -- https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
    --
    -- This example assume you are using sdkman: https://sdkman.io
    {
      name = "JavaSE-1.8",
      path = "/home/olivier/.asdf/installs/java/adoptopenjdk-8.0.392+8", -- or '/path/to/java17_or_newer/bin/java'
    },
    {
      name = "JavaSE-19",
      path = "/home/olivier/.asdf/installs/java/openjdk-19.0.2"
    },
    {
      name = "JavaSE-11",
      path = "/home/olivier/.asdf/installs/java/openjdk-11.0.2"
    },
    {
      name = "JavaSE-21",
      path = "/home/olivier/.asdf/installs/java/openjdk-21.0.1"
    },
    {
      name = 'JavaSE-22',
      path = vim.fn.expand('~/.asdf/installs/java/openjdk-22/'),
    }
  }

  cache_vars.paths = path

  return path
end

local function enable_codelens(bufnr)
  pcall(vim.lsp.codelens.refresh)

  vim.api.nvim_create_autocmd('BufWritePost', {
    buffer = bufnr,
    group = java_cmds,
    desc = 'refresh codelens',
    callback = function()
      pcall(vim.lsp.codelens.refresh)
    end,
  })
end


local function enable_debugger(bufnr)
  require('jdtls').setup_dap({ hotcodereplace = 'auto', config_overrides = {} })
  require('jdtls.dap').setup_dap_main_class_configs()

  local opts = { buffer = bufnr }
  vim.keymap.set('n', '<leader>df', "<cmd>lua require('jdtls').test_class()<cr>", opts)
  vim.keymap.set('n', '<leader>dn', "<cmd>lua require('jdtls').test_nearest_method()<cr>", opts)

  -- require('jdtls.dap').setup_dap_main_class_configs()
  --
end




local function jdtls_on_attach(client, bufnr)
  if features.debugger then
    enable_debugger(bufnr)
  end

  if features.codelens then
    enable_codelens(bufnr)
  end



  -- The following mappings are based on the suggested usage of nvim-jdtls
  -- https://github.com/mfussenegger/nvim-jdtls#usage

  local opts = { buffer = bufnr }
  vim.keymap.set('n', '<A-o>', "<cmd>lua require('jdtls').organize_imports()<cr>", opts)
  vim.keymap.set('n', 'crv', "<cmd>lua require('jdtls').extract_variable()<cr>", opts)
  vim.keymap.set('x', 'crv', "<esc><cmd>lua require('jdtls').extract_variable(true)<cr>", opts)
  vim.keymap.set('n', 'crc', "<cmd>lua require('jdtls').extract_constant()<cr>", opts)
  vim.keymap.set('x', 'crc', "<esc><cmd>lua require('jdtls').extract_constant(true)<cr>", opts)
  vim.keymap.set('x', 'crm', "<esc><Cmd>lua require('jdtls').extract_method(true)<cr>", opts)
end

local function jdtls_setup(event)
  local jdtls = require('jdtls')

  local path = get_jdtls_paths()

  local root_dir = jdtls.setup.find_root(root_files)
  -- local workspace_folder = root_dir .. '/' .. vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')
  local workspace_folder = vim.fn.fnamemodify(root_dir, ':h') ..
      '/workspace/' .. vim.fn.fnamemodify(root_dir, ':p:h:t')
  print(workspace_folder)

  path.data_dir = workspace_folder

  -- if cache_vars.capabilities == nil then
  --   jdtls.extendedClientCapabilities.resolveAdditionalTextEditsSupport = true
  --
  --   local ok_cmp, cmp_lsp = pcall(require, 'cmp_nvim_lsp')
  --   cache_vars.capabilities = vim.tbl_deep_extend(
  --     'force',
  --     vim.lsp.protocol.make_client_capabilities(),
  --     ok_cmp and cmp_lsp.default_capabilities() or {}
  --   )
  -- end

  -- The command that starts the language server
  -- See: https://github.com/eclipse/eclipse.jdt.ls#running-from-the-command-line
  local cmd = {
    'java',

    '-Declipse.application=org.eclipse.jdt.ls.core.id1',
    '-Dosgi.bundles.defaultStartLevel=4',
    '-Declipse.product=org.eclipse.jdt.ls.core.product',
    '-Dlog.protocol=true',
    '-Dlog.level=ALL',
    '-javaagent:' .. path.java_agent,
    '-Xms1g',
    '--add-modules=ALL-SYSTEM',
    '--add-opens', 'java.base/java.util=ALL-UNNAMED',
    '--add-opens', 'java.base/java.lang=ALL-UNNAMED',
    '--add-opens', 'java.desktop/java.awt=ALL-UNNAMED',
    '--add-opens', 'java.desktop/java.org=ALL-UNNAMED',
    '-classpath', path.bundles.java_test_bundle,

    '-jar',
    path.launcher_jar,

    '-configuration',
    path.platform_config,

    '-data',
    workspace_folder,

  }

  local lsp_settings = {
    java = {
      -- jdt = {
      --   ls = {
      --     vmargs = "-XX:+UseParallelGC -XX:GCTimeRatio=4 -XX:AdaptiveSizePolicyWeight=90 -Dsun.zip.disableMemoryMapping=true -Xmx1G -Xms100m"
      --   }
      -- },
      eclipse = {
        downloadSources = true,
      },
      configuration = {
        updateBuildConfiguration = 'interactive',
        runtimes = {
          -- Note: the field `name` must be a valid `ExecutionEnvironment`,
          -- you can find the list here:
          -- https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
          --
          -- This example assume you are using sdkman: https://sdkman.io
          {
            name = "JavaSE-1.8",
            path = "/home/olivier/.asdf/installs/java/adoptopenjdk-8.0.392+8", -- or '/path/to/java17_or_newer/bin/java'
          },
          {
            name = "JavaSE-19",
            path = "/home/olivier/.asdf/installs/java/openjdk-19.0.2"
          },
          {
            name = "JavaSE-11",
            path = "/home/olivier/.asdf/installs/java/openjdk-11.0.2"
          },
          {
            name = "JavaSE-21",
            path = "/home/olivier/.asdf/installs/java/openjdk-21.0.1"
          },
          {
            name = 'JavaSE-22',
            path = '/home/olivier/.asdf/installs/java/openjdk-22'
          }
        },
      },
      maven = {
        downloadSources = true,
      },
      implementationsCodeLens = {
        enabled = true,
      },
      referencesCodeLens = {
        enabled = true,
      },
      references = {
        includeDecompiledSources = true,
      },
      inlayHints = {
        parameterNames = {
          enabled = 'all' -- literals, all, none
        }
      },
      format = {
        enabled = true,
        -- settings = {
        --   profile = 'asdf'
        -- },
      }
    },
    signatureHelp = {
      enabled = true,
    },
    completion = {
      favoriteStaticMembers = {
        'org.hamcrest.MatcherAssert.assertThat',
        'org.hamcrest.Matchers.*',
        'org.hamcrest.CoreMatchers.*',
        'org.junit.jupiter.api.Assertions.*',
        'java.util.Objects.requireNonNull',
        'java.util.Objects.requireNonNullElse',
        'org.mockito.Mockito.*',
      },
    },
    contentProvider = {
      preferred = 'fernflower',
    },
    extendedClientCapabilities = jdtls.extendedClientCapabilities,
    sources = {
      organizeImports = {
        starThreshold = 9999,
        staticStarThreshold = 9999,
      }
    },
    codeGeneration = {
      toString = {
        template = '${object.className}{${member.name()}=${member.value}, ${otherMembers}}',
      },
      useBlocks = true,
    },
  }

  -- This starts a new client & server,
  -- or attaches to an existing client & server depending on the `root_dir`.
  jdtls.start_or_attach({
    cmd = cmd,
    settings = lsp_settings,
    on_attach = jdtls_on_attach,
    capabilities = cache_vars.capabilities,
    root_dir = jdtls.setup.find_root(root_files),
    flags = {
      allow_incremental_sync = true,
    },
    init_options = {
      bundles = path.bundles,
    },
  })
end

vim.api.nvim_create_autocmd('FileType', {
  group = java_cmds,
  pattern = { 'java' },
  desc = 'Setup jdtls',
  callback = jdtls_setup,
})
local attached = false







local function attach()
  if attached == true then
    vim.cmd('wall')
    require('jdtls').setup_dap({ hotcodereplace = 'auto', config_overrides = {} })
    require('jdtls.dap').setup_dap_main_class_configs()
    require('jdtls').compile();
    require('dap').continue()
  else
    enable_debugger(vim.api.nvim_get_current_buf())
    enable_codelens(vim.api.nvim_get_current_buf())
    attached = true
  end
end


vim.keymap.set("n", "<F5>", attach, { desc = 'Start or continue debug execution' })
require("jdtls")
