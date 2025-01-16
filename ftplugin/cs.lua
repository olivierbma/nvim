vim.bo.tabstop = 2      -- size of a hard tabstop (ts).
vim.bo.shiftwidth = 2   -- size of an indentation (sw).
vim.bo.expandtab = true -- always uses spaces instead of tab characters (et).
vim.bo.softtabstop = 2  -- number of spaces a <Tab> counts for. When 0, feature is off (sts).
vim.o.pumheight = 7

vim.opt.colorcolumn = "80"
vim.cmd('set fileformat=unix')


local dap = require("dap")
local dapui = require("dapui")


local debugger = vim.fn.stdpath("data") .. "/mason/packages/netcoredbg/netcoredbg" -- Update this path

local function find_project_name()
  -- Find the root directory containing the .git folder
  local root_dir = vim.fn.finddir('.git', vim.fn.getcwd() .. ';')
  if root_dir == '' then
    print("No .git directory found.")
    return
  end

  -- Navigate to the root directory
  root_dir = vim.fn.fnamemodify(root_dir, ':h')

  -- Search for .csproj files in the root directory
  local csproj_file = vim.fn.glob(root_dir .. '/*.csproj')
  if csproj_file == '' then
    print("No .csproj file found.")
    return
  end

  -- Extract the project name from the .csproj file
  local project_name = vim.fn.fnamemodify(csproj_file, ':r')
  print("Project Name: " .. project_name)
  return project_name, root_dir
end

dap.adapters.coreclr = {
  type = 'executable',
  command = debugger,
  args = { '--interpreter=vscode' }
}
dap.configurations.cs = {
  {
    type = "coreclr",
    name = "launch - netcoredbg",
    request = "launch",
    program = function()
      local name, root = find_project_name()
      return root .. "/bin/Debug/net8.0/" .. name .. ".dll"
    end,
    console = 'integratedTerminal',
  },
}

local function setup_debug()
  os.execute('dotnet build > /dev/null 2>&1')
  require('dap').continue()
end

vim.keymap.set("n", "<F5>", setup_debug, { desc = 'Start or continue debug execution' })
