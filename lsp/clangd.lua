return {
  cmd = { 'clangd', '--background-index', '--query-driver=/usr/bin/arm-none-eabi-g*' },
  root_markers = { 'compile_commands.json', 'compile_flags.txt', '.git' },
  filetypes = { 'c', 'cpp' },
}
