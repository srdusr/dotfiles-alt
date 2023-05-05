local dap = require('dap')
dap.defaults.fallback.external_terminal = {
  command = '/usr/bin/wezterm';
  args = {'-e'};
}
--dap.adapters.lldb = {
--  type = 'executable',
--  --command = '/usr/bin/lldb-vscode', -- adjust as needed, must be absolute path
--  --command = '/usr/bin/vscode-lldb', -- adjust as needed, must be absolute path
--  command = 'codelldb',
--  --command = 'lldb',
--  --command = codelldb_root,
--  --command = vim.fn.stdpath("data") .. '/mason/bin/codelldb',
--  name = 'lldb',
--  host = '127.0.0.1',
--  port = 13000
--}
--
--local lldb = {
--	name = "Launch lldb",
--	type = "lldb", -- matches the adapter
--	request = "launch", -- could also attach to a currently running process
--	program = function()
--		return vim.fn.input(
--			"Path to executable: ",
--			vim.fn.getcwd() .. "/",
--			"file"
--		)
--	end,
--	cwd = "${workspaceFolder}",
--	stopOnEntry = false,
--	args = {},
--	runInTerminal = false,
--	--type = 'server',
--  port = "${port}",
--  executable = {
--    --command = vim.fn.stdpath("data") .. '/mason/bin/codelldb',
--    args = { "--port", "${port}" },
--  }
--}
dap.adapters.cppdbg = {
  id = 'cppdbg',
  type = 'executable',
  --command = vim.fn.stdpath('data') .. '/mason/bin/OpenDebugAD7',
  command = os.getenv("HOME") .. '/apps/cpptools/extension/debugAdapters/bin/OpenDebugAD7',
}

dap.adapters.codelldb = {
  type = 'server',
  port = '${port}',
  executable = {
    --command = os.getenv("HOME") .. '/apps/codelldb/extension/adapter/codelldb',
    --command = vim.env.HOME .. "/.vscode-oss/extensions/vadimcn.vscode-lldb-1.9.0-universal/adapter/codelldb",
    command = os.getenv("HOME") .. "/.vscode-oss/extensions/vadimcn.vscode-lldb-1.9.0-universal/adapter/codelldb",
    args = {'--port', '${port}'},
  }
}

dap.adapters.lldb = {
  type = 'executable',
  command = '/usr/bin/lldb-vscode',
  name = "lldb"
}
dap.configurations.cpp = {
  {
    name = "Launch file",
    --type = "cppdbg",
    type = "codelldb",
    request = "launch",
    --request = "Attach",
    --processId = function()
    --  return tonumber(vim.fn.input({ prompt = "Pid: "}))
    --end,
    program = function()
      return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
    end,
    stopAtEntry = true,
    args = {},
    runInTerminal = false,
    --MIMode = 'gdb',
    --miDebuggerServerAddress = 'localhost:1234',
    --miDebuggerPath = 'gdb-oneapi',
    --miDebuggerPath = '/usr/bin/gdb',
    --externalConsole = true,
    --setupCommands = {
    --  {
    --    text = '-enable-pretty-printing',
    --    description =  'enable pretty printing',
    --    ignoreFailures = false
    --  }
    --},
    cwd = '${workspaceFolder}',
},
}
--  dap.adapters.cppdbg = {
--    name = 'cppdbg',
--    type = 'executable',
--    command = vim.fn.stdpath('data') .. '/mason/bin/OpenDebugAD7',
--  }
--   dap.configurations.cpp = {
--    {
--      name = 'Launch',
--      type = 'cppdbg',
--      request = 'launch',
--      --request = 'attach',
--      MIMode = 'gdb',
--      --cwd = '${workspaceFolder}',
--      -- udb='live',
--      -- miDebuggerPath = 'udb',
--      setupCommands= {
--				{
--					description= "Enable pretty-printing for gdb",
--					text= "-enable-pretty-printing",
--					ignoreFailures= true,
--				}
--      },
--      program = '${file}',
--      cwd = vim.fn.getcwd(),
--      --attach = {
--      --  pidProperty = "processId",
--      --  pidSelect = "ask"
--      --},
--      stopAtEntry = true,
--      --program = 'main',
--      --program = '${workspaceFolder}/main'
--      --program = '${file}',
--      --program = function()
--      --  return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
--      --end,
--    },
--   }

--require('dap').configurations.c = {
--	lldb -- different debuggers or more configurations can be used here
--}

-- cpp (c,c++,rust)
--dap.configurations.c = {
--  {
--    name = 'Launch',
--    type = 'lldb',
--    request = 'launch',
--    --program = function()
--    --  return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
--    --end,
--    terminal = 'integrated',
--    console = 'integratedTerminal',
--    program = function()
--        return vim.fn.input('program: ', vim.loop.cwd() .. '/', 'file')
--    end,
--    cwd = "${workspaceFolder}",
--    stopOnEntry = false,
--    args = {},
-- },
--}

-- If you want to use this for Rust and C, add something like this:
dap.configurations.c = dap.configurations.cpp
dap.configurations.rust = dap.configurations.cpp
-- javascript
--dap.adapters.node2 = {
--  type = 'executable',
--  command = 'node-debug2-adapter',
--  args = {},
--}

--dap.configurations.javascript = {
--  {
--    name = 'Launch',
--    type = 'node2',
--    request = 'attach',
--    program = '${file}',
--    cwd = vim.fn.getcwd(),
--    sourceMaps = true,
--    protocol = 'inspector',
--    console = 'integratedTerminal',
--  },
--}

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
    --controls = { enabled = false },
    floating = { border = "rounded", mappings = { close = { "q", "<esc>", "<c-o>" } } },
})

-- signs
vim.fn.sign_define("DapStopped", { text = '=>', texthl = 'DiagnosticWarn', numhl = 'DiagnosticWarn' })
vim.fn.sign_define("DapBreakpoint", { text = '<>', texthl = 'DiagnosticInfo', numhl = 'DiagnosticInfo' })
vim.fn.sign_define("DapBreakpointRejected", { text = '!>', texthl = 'DiagnosticError', numhl = 'DiagnosticError' })
vim.fn.sign_define("DapBreakpointCondition", { text = '?>', texthl = 'DiagnosticInfo', numhl = 'DiagnosticInfo' })
vim.fn.sign_define("DapLogPoint", { text = '.>', texthl = 'DiagnosticInfo', numhl = 'DiagnosticInfo' })

dap.listeners.after.event_initialized["dapui_config"] = function()
  dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
  dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
  dapui.close()
end

-- options
dap.defaults.fallback.focus_terminal = false
dap.defaults.fallback.terminal_win_cmd = '10split new'
