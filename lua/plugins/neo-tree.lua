return {
  'echasnovski/mini.files',
  dependencies = {
    "echasnovski/mini.icons"
  },
  config = function()
    require('mini.files').setup()

    vim.keymap.set('n', '<leader>`', ':lua MiniFiles.open()<CR>', { desc = "Open Mini Files" })
  end
}
