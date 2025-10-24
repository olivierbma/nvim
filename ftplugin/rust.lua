vim.bo.tabstop = 2      -- size of a hard tabstop (ts).
vim.bo.shiftwidth = 2   -- size of an indentation (sw).
vim.bo.expandtab = true -- always uses spaces instead of tab characters (et).
vim.bo.softtabstop = 2  -- number of spaces a <Tab> counts for. When 0, feature is off (sts).
vim.o.pumheight = 7

vim.cmd('set fileformat=unix')
-- Normal setup

local dap = require("dap")

local debug_session_active = false;

dap.listeners.after.event_initialized["debug_on_save"] = function()
  debug_session_active = true
end
dap.listeners.before.event_terminated["debug_on_save"] = function()
  debug_session_active = false
end
dap.listeners.before.event_exited["debug_on_save"] = function()
  debug_session_active = false
end

local function setup_debug()
  vim.cmd('wa')
  os.execute('cargo build')
  require('dap').continue()
end

vim.keymap.set("n", "<F5>", setup_debug, { desc = 'Start or continue debug execution' })



local extension_path = vim.fn.stdpath("data") .. "/mason/packages/codelldb/extension/" -- Update this path
local codelldb_path = extension_path .. "adapter/codelldb"
local liblldb_path = extension_path .. "lldb/lib/liblldb"


dap.adapters.codelldb = {
  type = 'server',
  port = "${port}",
  executable = {
    -- CHANGE THIS to your path!
    command = codelldb_path,
    args = { "--port", "${port}" },
    -- On windows you may have to uncomment this:
    -- detached = false,
  }
}

local root_dir = vim.fs.dirname(vim.fs.find({ 'Cargo.toml', '.git' }, { upward = true })[1])
local program_name = vim.fn.fnamemodify(root_dir, ':p:h:t')
local program_path = root_dir .. '/target/debug/' .. program_name

dap.configurations.rust = {
  {
    name = "Launch file",
    type = "codelldb",
    request = "launch",
    program = program_path,
    cwd = '${workspaceFolder}',
    stopOnEntry = false,
  },
}
