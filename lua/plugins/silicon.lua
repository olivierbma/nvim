return {
  "michaelrommel/nvim-silicon",
  lazy = true,
  cmd = "Silicon",
  main = "nvim-silicon",
  opts = {
    -- Configuration here, or leave empty to use defaults
    line_offset = function(args)
      return args.line1
    end,
    to_clipboard = true,
    theme = "gruvbox-dark",
    language = function()
      return vim.bo.filetype
    end,
    background = "#A1AEB9"
  }

}
