return {
  "L3MON4D3/LuaSnip",

  build = "make install_jsregexp",
  config = function()
    local snippet_path = vim.fn.stdpath 'config' .. '/snippets'
    require("luasnip.loaders.from_lua").load({ paths = snippet_path })
    
  end,
}
