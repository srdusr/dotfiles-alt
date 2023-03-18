local dap = require('dap')
local home_path = vim.fn.expand('$HOME')

-- Unsafe Defaults
local mi_mode = ""
local mi_debugger_path = ""

-- Unix
if vim.loop.os_uname().sysname == 'Linux' then
    mi_mode = "gdb"
    mi_debugger_path = vim.trim(vim.fn.system('which gdb'))
-- MacOS
elseif vim.loop.os_uname().sysname == 'Darwin' then
    mi_mode = "lldb"
    mi_debugger_path = vim.trim(vim.fn.system('which lldb-mi'))
else
    error("Unsupported OS")
end

dap.adapters.cppdbg = {
    id = 'cppdbg',
    type = 'executable',
    command = home_path .. '/extension/debugAdapters/bin/OpenDebugAD7',
}

dap.configurations.cpp = {
    {
        name = "Launch file",
        type = "cppdbg",
        request = "launch",
        program = function()
            return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
        end,
        cwd = '${workspaceFolder}',
        stopAtEntry = true,
        MIMode = mi_mode,
        miDebuggerPath = mi_debugger_path
    }
}

dap.configurations.c = dap.configurations.cpp
dap.configurations.rust = dap.configurations.cpp

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

