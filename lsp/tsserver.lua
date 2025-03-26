return {
  cmd = { 'typescript-language-server', '--stdio' },
  root_markers = { 'package.json', '.git', 'tsconfig.json' },
  filetypes = { 'cjs', 'typescript', 'javascript' },
}
