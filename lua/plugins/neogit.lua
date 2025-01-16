return {
  "NeogitOrg/neogit",
  dependencies = {
    "nvim-lua/plenary.nvim",         -- required
    "nvim-telescope/telescope.nvim", -- optional
    "sindrets/diffview.nvim",        -- optional
    -- "ibhagwan/fzf-lua",              -- optional
  },
  config = function()
    -- require("telescope").load_extension("lazygit")
    require('diffview').setup {
      -- Configuration options
    }
    require("neogit").setup({
      integrations = {
        -- Neogit only provides inline diffs. If you want a more traditional way to look at diffs, you can use `diffview`.
        -- The diffview integration enables the diff popup.
        --
        -- Requires you to have `sindrets/diffview.nvim` installed.
        diffview = true, -- Use diffview.nvim for viewing commits
        merge_editor = {
          kind = "diffview",
        },
      }
    })
    vim.keymap.set('n', '<leader>lg', ':Neogit <CR>', { desc = "[G]it [N]eo" })
    return true
  end,


}
