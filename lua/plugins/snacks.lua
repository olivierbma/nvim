return {
  "folke/snacks.nvim",
  ---@type  snacks.Config
  opts = {
    image = {
      enabled = true,

    },
    indent = {
      priority = 1,
      enabled = true,
      animate = { enabled = false },
      indent = {
        char = '▎',
        enabled = true,
        animate = { enabled = false },

      },
      scope = {
        enabled = true,
        char = '▎',
      }

    },
  }
}
