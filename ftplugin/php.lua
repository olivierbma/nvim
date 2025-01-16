require('lspconfig').intelephense.setup {
  capabilities = vim.lsp.protocol.make_client_capabilities(vim.lsp),
}


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
