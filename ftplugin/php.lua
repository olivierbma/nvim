

require('telescope').setup({
  defaults = {
    find_ignore_files = { ".git", ".idea", "vendor" },
    file_ignore_patterns = {
      "node_modules",
      "vendor",
      "build",
      "dist",
      "public",
      "resources/css",
      "resources/markdown",
      "resources/js",
      "storage",
    },
  },
})
