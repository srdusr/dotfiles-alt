local dap = require('dap')
dap.adapters.lldb = {
  type = 'executable',
  --command = '/usr/bin/lldb-vscode', -- adjust as needed, must be absolute path
  --command = '/usr/bin/vscode-lldb', -- adjust as needed, must be absolute path
  command = 'codelldb',
  --command = 'lldb',
  --command = codelldb_root,
  name = 'lldb'
}

-- cpp (c,c++,rust)
dap.configurations.cpp = {
  {
    name = 'Launch',
    type = 'lldb',
    request = 'launch',
    --program = function()
    --  return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
    --end,
    terminal = 'integrated',
    console = 'integratedTerminal',
    program = function()
        return vim.fn.input('program: ', vim.loop.cwd() .. '/', 'file')
    end,
    cwd = "${workspaceFolder}",
    stopOnEntry = false,
    args = {},
 },
}

-- If you want to use this for Rust and C, add something like this:
dap.configurations.c = dap.configurations.cpp
dap.configurations.rust = dap.configurations.cpp

-- javascript
dap.adapters.node2 = {
  type = 'executable',
  command = 'node-debug2-adapter',
  args = {},
}

dap.configurations.javascript = {
  {
    name = 'Launch',
    type = 'node2',
    request = 'attach',
    program = '${file}',
    cwd = vim.fn.getcwd(),
    sourceMaps = true,
    protocol = 'inspector',
    console = 'integratedTerminal',
  },
}

dap.adapters.python = {
    type = 'executable';
    command = vim.trim(vim.fn.system('which python'));
    args = { '-m', 'debugpy.adapter' };
}

dap.configurations.python = {
    {
        -- The first three options are required by nvim-dap
        type = 'python'; -- the type here established the link to the adapter definition: `dap.adapters.python`
        request = 'launch';
        name = "Launch file";
        -- Options below are for debugpy, see https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings for supported options
        program = "${file}"; -- This configuration will launch the current file if used.
        stopOnEntry = true,
    },
}

local dapui = require('dapui')

-- setup repl
dap.repl.commands = vim.tbl_extend('force', dap.repl.commands, {
    exit = { 'q', 'exit' },
    custom_commands = {
        ['.run_to_cursor'] = dap.run_to_cursor,
        ['.restart'] = dap.run_last
    }
})

-- setup dapui
dapui.setup({
    mappings = {
        expand = "<CR>",
        open = "o",
        remove = "D",
        edit = "e",
        repl = "r",
        toggle = "t",
    },
    layouts = {
        { elements = { "scopes", "breakpoints", "stacks" }, size = 0.33, position = "right" },
        { elements = { "repl", "watches" },                 size = 0.27, position = "bottom" },
    },
    icons = { expanded = "-", collapsed = "$" },
    controls = { enabled = false },
    floating = { border = "rounded", mappings = { close = { "q", "<esc>", "<c-o>" } } },
})

-- signs
vim.fn.sign_define("DapStopped", { text = '=>', texthl = 'DiagnosticWarn', numhl = 'DiagnosticWarn' })
vim.fn.sign_define("DapBreakpoint", { text = '<>', texthl = 'DiagnosticInfo', numhl = 'DiagnosticInfo' })
vim.fn.sign_define("DapBreakpointRejected", { text = '!>', texthl = 'DiagnosticError', numhl = 'DiagnosticError' })
vim.fn.sign_define("DapBreakpointCondition", { text = '?>', texthl = 'DiagnosticInfo', numhl = 'DiagnosticInfo' })
vim.fn.sign_define("DapLogPoint", { text = '.>', texthl = 'DiagnosticInfo', numhl = 'DiagnosticInfo' })

-- options
dap.defaults.fallback.focus_terminal = false
dap.defaults.fallback.terminal_win_cmd = '10split new'

