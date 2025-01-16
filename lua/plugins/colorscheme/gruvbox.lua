return {
  'ellisonleao/gruvbox.nvim',
  priority = 2000,
  config = function()
    -- vim.cmd.colorscheme 'gruvbox'
    local g = require("gruvbox")

    local p = g.palette
    g.setup({
      overrides = {
        BufferInactive = {
          fg = p.gray,
          bg = p.dark1
        },
        BufferCurrent = {
          fg = p.bright_orange,
        },
      }
    })
  end,
}
