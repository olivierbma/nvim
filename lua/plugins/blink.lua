return {
  'saghen/blink.cmp',
  -- optional: provides snippets for the snippet source
  dependencies = { 'rafamadriz/friendly-snippets' },

  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  opts = {
    keymap = {
      preset = 'default',
      ['<TAB>'] = { 'select_next', 'fallback' },
      ['<CR>'] = { 'accept', 'fallback' },
    },

    appearance = {
      nerd_font_variant = 'mono'
    },
    signature = { enabled = true },


    completion = {
      documentation = { auto_show = true },
      menu = {
        draw = {
          columns = { { "kind_icon", "label", "label_description", gap = 1 }, { "kind" } },

        },
      },
      accept = { auto_brackets = { enabled = false } },
    },


    sources = {
      default = { 'lsp', 'path', 'snippets', 'buffer' },
    },


    fuzzy = {
      implementation = "prefer_rust_with_warning",
      prebuilt_binaries = {
        download = true,

        ignore_version_mismatch = false,

        force_version = "v1.0.0",

        force_system_triple = nil,

        extra_curl_args = {}
      },
    }

  },
  opts_extend = { "sources.default" }
}
