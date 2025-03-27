local function find_init_lua(base_path)
  local results = {}
  local scan = vim.fn.glob(base_path .. "/*/lua/*/init.lua", true, true)

  for _, path in ipairs(scan) do
    table.insert(results, path)
  end

  return results
end


return {

  cmd = { 'lua-language-server' },
  root_markers = { '.luarc.json', '.luarc.jsonc', '.git' },
  filetypes = { 'lua' },
  settings = {
    Lua = {
      runtime = {
        version = 'LuaJIT',
      },
      codelens = {
        enable = true,
      },
      workspace = {
        library = {

          vim.fn.expand "$VIMRUNTIME/lua/",
          find_init_lua(vim.fn.stdpath('data') .. "/lazy")

        },
        checkThirdParty = 'ApplyInMemory',
      },
      telemetry = { enable = false },
      diagnostics = {
        globals = { 'vim' }
      }
    }
  }
}
