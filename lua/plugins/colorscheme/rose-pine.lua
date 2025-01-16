return {
  'rose-pine/neovim',
  priority = 2000,
  config = function()
    require("rose-pine").setup({
      variant = "dawn",      -- auto, main, moon, or dawn
      dark_variant = "dawn", -- main, moon, or dawn
      dim_inactive_windows = false,
      extend_background_behind_borders = true,

      enable = {
        terminal = true,
        legacy_highlights = false, -- Improve compatibility for previous versions of Neovim
        migrations = true,         -- Handle deprecated options automatically
      },

      styles = {
        bold = true,
        italic = true,
        transparency = false,
      },

      groups = {
        border = "muted",
        link = "iris",
        panel = "surface",

        error = "love",
        hint = "iris",
        info = "foam",
        note = "pine",
        todo = "rose",
        warn = "gold",

        git_add = "foam",
        git_change = "rose",
        git_delete = "love",
        git_dirty = "rose",
        git_ignore = "muted",
        git_merge = "iris",
        git_rename = "pine",
        git_stage = "iris",
        git_text = "rose",
        git_untracked = "subtle",

        h1 = "iris",
        h2 = "foam",
        h3 = "rose",
        h4 = "gold",
        h5 = "pine",
        h6 = "foam",
      },

      palette = {
        dawn = {
          -- surface = "#f7f1ea",
          surface = "#FAF0E8",
          base = "#FAF0E8",
          gold = "#dd9530",
          overlay = "#ede7e1"

        }
      },

      highlight_groups = {
        Comment = { fg = "#a4a4a4" },
        Keyword = { fg = "love" },

        ColorColumn = { bg = "overlay" }, --80 char line
        CursorLineNr = { fg = "gold" },   -- line number color


        CursorLine = { bg = "overlay" },
        -- Cursor = { fg = "gold", bg = "gold" },
        CursorColumn = { bg = "gold" },

        -- barbar buffer line styling
        BufferCurrent = {
          fg = "love",
          bg = "#faf0e8"
        },
        BufferInactive = {
          bg = "#e8e2dc",
        },


      },

      before_highlight = function(group, highlight, palette)
      end,
    })


    vim.cmd.colorscheme 'rose-pine-dawn'
  end
}
