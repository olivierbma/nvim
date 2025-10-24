return {
  'saghen/blink.cmp',
  -- optional: provides snippets for the snippet source
  dependencies = { "L3MON4D3/LuaSnip" },

  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  opts = {
    keymap = {
      preset = 'enter',
      ['<TAB>'] = { 'select_next', 'fallback' },
      ['<CR>'] = { 'accept', 'fallback' },
    },

    appearance = {
      nerd_font_variant = 'mono'
    },
    signature = { enabled = true },


    completion = {
      list = {
        selection = { preselect = false, auto_insert = true }

      },
      documentation = {
        auto_show = true,
        window = {
          border = "single",
        },
      },
      menu = {
        draw = {
          columns = { { "kind_icon", "label", "label_description", gap = 1 }, { "kind" } },
        },
        border = 'none',
      },
      accept = {
        auto_brackets = {
          enabled = true,
          default_brackets = { '(', ')' },
          kind_resolution = { enabled = true },
          semantic_token_resolution = {
            enabled = true,
            blocked_filetypes = { '' },
            -- How long to wait for semantic tokens to return before assuming no brackets should be added
            timeout_ms = 300,
          },
        },
      },
    },

    snippets = { preset = 'luasnip' },
    sources = {
      default = { 'lsp', 'path', 'snippets', 'buffer' },
      --, 'lazydev' },

      -- providers = {
      --   lazydev = {
      --     name = "LazyDev",
      --     module = "lazydev.integrations.blink",
      --     -- make lazydev completions top priority (see `:h blink.cmp`)
      --     score_offset = 100,
      --   },
      -- },
    },




    fuzzy = {
      implementation = "prefer_rust_with_warning",
      prebuilt_binaries = {
        download = true,

        ignore_version_mismatch = false,

        force_version = "1.7.0",

        -- force_system_triple = nil,

        -- extra_curl_args = {}
      },
    }

  },
  opts_extend = { "sources.default" }
}
