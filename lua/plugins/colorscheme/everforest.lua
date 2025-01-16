return {
  'neanias/everforest-nvim',
  priority = 2000,

  config = function()
    require('everforest').setup({
      background = "hard",
      transparent_background_level = 0,
      italics = false,
      disable_italic_comments = false,
      sign_column_background = "none",
      ui_contrast = "high",
      dim_inactive_windows = false,
      diagnostic_text_highlight = false,
      diagnostic_virtual_text = "coloured",
      diagnostic_line_highlight = false,
      spell_foreground = false,
      show_eob = true,
      float_style = "bright",
      inlay_hints_background = "none",
      on_highlights = function(highlight_groups, palette) end,
      colours_override = function(palette) end
    })

    -- vim.o.background = "light"
    --
    -- vim.cmd.colorscheme 'everforest'
  end
}
