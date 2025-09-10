return {
  "nvim-neotest/neotest",
  dependencies = {
    "nvim-neotest/nvim-nio",
    "nvim-lua/plenary.nvim",
    "antoinemadec/FixCursorHold.nvim",
    "nvim-treesitter/nvim-treesitter",
    -- "nvim-neotest/neotest-jest",
    "rcasia/neotest-java",
    "nvim-neotest/neotest-go",
    "lawrence-laz/neotest-zig",
    "jfpedroza/neotest-elixir"
  },

  config = function()
    require("neotest").setup({
      adapters = {
--        require('neotest-jest')({
--          jestCommand = "npm test --",
--          jestConfigFile = "jest.config.ts",
--          env = { CI = true },
--          cwd = function(path)
--            return vim.fn.getcwd()
--         end,
--        }),
        require('neotest-java')({
          ignore_wrapper = false, -- whether to ignore maven/gradle wrapper
          junit_jar = vim.fn.glob(vim.fn.stdpath("data") .. "/neotest-java/junit-platform-console-standalone-*.jar"),

        }),
        require('neotest-go'),
        require("neotest-elixir"),
        require("neotest-zig")({
          dap = {
            adapter = "lldb",
          }
        }),
      },
    })


    vim.keymap.set('n', '<leader>nts', "<cmd> Neotest summary<cr><C-w>l<cr>", { desc = '[N]eo [T]est [S]ummary' })
    vim.keymap.set('n', '<leader>ntr', "<cmd> Neotest run<cr>", { desc = '[N]eo [T]est [R]un' })
    vim.keymap.set('n', '<leader>nto', "<cmd> Neotest output<cr>", { desc = '[N]eo [T]est [O]utput' })
  end


}
