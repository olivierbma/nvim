return {

  'https://gitlab.com/itaranto/plantuml.nvim',

  dependencies = { 'javiorfo/nvim-nyctophilia' },
  ft = { "markdown", "plantuml", "puml" },

  config = function()
    require('plantuml').setup({
      renderer = {
        type = 'image',
        options = {
          prog = 'nsxiv',
          dark_mode = false,
          format = 'svg', -- Allowed values: nil, 'png', 'svg'.
        }
      },
      render_on_write = true,
    })


    vim.filetype.add({
      extension = {
        puml = 'plantuml'
      }
    })
  end
}
