local dap = require('dap')

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "dap-float" },
  callback = function(event)
    vim.keymap.set("n", "<Tab>", "", { buffer = event.buf, silent = true })
    vim.keymap.set("n", "<S-Tab>", "", { buffer = event.buf, silent = true })
  end,
})

--dap.defaults.fallback.external_terminal = {
--  command = '/usr/bin/wezterm';
--  args = {'-e'};
--}
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
  --command = cpptools:get_install_path() .. '/extension/debugAdapters/bin/OpenDebugAD7'
}

dap.adapters.codelldb = {
  type = 'server',
  port = '${port}',
  --host = "localhost",
  --host = '127.0.0.1',
  --port = 13000, -- 💀 Use the port printed out or specified with `--port`
  executable = {
    --command = os.getenv("HOME") .. '/apps/codelldb/extension/adapter/codelldb',
    command = os.getenv("HOME") .. "/.vscode-oss/extensions/vadimcn.vscode-lldb-1.9.0-universal/adapter/codelldb",
    args = {'--port', '${port}'},
  },
  --detached = true,
}

dap.adapters.lldb = {
  type = 'executable',
  command = '/usr/bin/lldb-vscode',
  name = "lldb"
}
dap.configurations.cpp = {
  {
    name = "Launch file",
    --type = "lldb",
    --type = "cppdbg",
    type = "codelldb",
    request = "launch",
    --request = "Attach",
    --processId = function()
    --  return tonumber(vim.fn.input({ prompt = "Pid: "}))
    --end,
    cwd = '${workspaceFolder}',
    program = function()
      return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
    end,
    --program = function()
    --  -- First, check if exists CMakeLists.txt
    --  local cwd = vim.fn.getcwd()
    --  if (file.exists(cwd, "CMakeLists.txt")) then
    --    -- Todo. Then invoke cmake commands
    --    -- Then ask user to provide execute file
    --    return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
    --  else
    --    local fileName = vim.fn.expand("%:t:r")
    --    if (not file.exists(cwd, "bin")) then
    --      -- create this directory
    --      os.execute("mkdir " .. "bin")
    --    end
    --    local cmd = "!gcc -g % -o bin/" .. fileName
    --    -- First, compile it
    --    vim.cmd(cmd)
    --    -- Then, return it
    --    return "${fileDirname}/bin/" .. fileName
    --  end
    --end,
    stopAtEntry = true,
    args = {},
    --runInTerminal = true,
    --runInTerminal = false,
    --console = 'integratedTerminal',

    --MIMode = 'gdb',
    --miDebuggerServerAddress = 'localhost:1234',
    --miDebuggerPath = 'gdb-oneapi',
    --miDebuggerPath = '/usr/bin/gdb',
    externalConsole = true,
    --setupCommands = {
    --  {
    --    text = '-enable-pretty-printing',
    --    description =  'enable pretty printing',
    --    ignoreFailures = false
    --  }
    --},
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

--local dapui = require('dapui')
local dap_ui_status_ok, dapui = pcall(require, "dapui")
if not dap_ui_status_ok then
  return
end

-- setup repl
--dap.repl.commands = vim.tbl_extend('force', dap.repl.commands, {
--    exit = { 'q', 'exit' },
--    custom_commands = {
--        ['.run_to_cursor'] = dap.run_to_cursor,
--        ['.restart'] = dap.run_last
--    }
--})

--dapui.setup({
--  layouts = {
--    {
--      elements = {
--        "watches",
--      },
--      size = 0.2,
--      position = "left",
--    },
--  },
--  controls = {
--    enabled = false,
--  },
--  render = {
--    max_value_lines = 3,
--  },
--  floating = {
--    max_height = nil, -- These can be integers or a float between 0 and 1.
--    max_width = nil, -- Floats will be treated as percentage of your screen.
--    border = "single", -- Border style. Can be "single", "double" or "rounded"
--    mappings = {
--      close = { "q", "<Esc>" },
--    },
--  },
--})

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
  controls = {
    enabled = true,
  },
  layouts = {
    {
      elements = {
        -- Elements can be strings or table with id and size keys.
        --{ id = "scopes", size = 0.4 },
        "watches",
        "scopes",
        "breakpoints",
        "stacks",
      },
      size = 50, -- 40 columns
      position = "left",
    },
    --{
    --  elements = {
    --    "repl",
    --  },
    --  size = 50,
    --  position = "center",
    --},
    {
      elements = {
        --"console",
        { id = "console", size = 0.6 },
        --"repl",
        { id = "repl", size = 0.4 },
      },
      size = 0.3,
      position = "bottom",
    },
  },
  render = {
    max_value_lines = 3,
  },
  floating = {
    max_height = nil, -- These can be integers or a float between 0 and 1.
    max_width = nil, -- Floats will be treated as percentage of your screen.
    border = "single", -- Border style. Can be "single", "double" or "rounded"
    mappings = {
      close = { "q", "<Esc>" },
    },
  },
  --icons = { expanded = "-", collapsed = "$" },
  icons = {
    expanded = "",
    collapsed = "",
    current_frame = "",
  },
  { "theHamsta/nvim-dap-virtual-text", config = true },
})

-- signs
local sign = vim.fn.sign_define
sign("DapBreakpoint", { text = "●", texthl = "DapBreakpoint", linehl = "", numhl = "" })
sign("DapBreakpointCondition", { text = "◆", texthl = "DapBreakpointCondition", linehl = "", numhl = "" }) --
sign("DapBreakpointRejected", { text = 'R', texthl = 'DiagnosticError', numhl = 'DiagnosticError' })
sign("DapLogPoint", { text = "L", texthl = "DapLogPoint", linehl = "", numhl = "" })
sign('DapStopped', { text = '', texthl = 'DiagnosticSignHint', numbhl = '', linehl = '' })

--sign('DapBreakpoint', { text = '', texthl = 'DiagnosticSignError', numbhl = '', linehl = '' })
--sign("DapLogPoint", { text = '.>', texthl = 'DiagnosticInfo', numhl = 'DiagnosticInfo' })
--vim.fn.sign_define("DapBreakpointCondition", { text = '?>', texthl = 'DiagnosticInfo', numhl = 'DiagnosticInfo' })
--vim.fn.sign_define("DapStopped", { text = '=>', texthl = 'DiagnosticWarn', numhl = 'DiagnosticWarn' })
--vim.fn.sign_define("DapBreakpoint", { text = '<>', texthl = 'DiagnosticInfo', numhl = 'DiagnosticInfo' })

dap.listeners.after.event_initialized["dapui_config"] = function()
  dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
  dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
  dapui.close()
end
dap.listeners.before.disconnect["dapui_config"] = function()
  dapui.close()
end

local dap_virtual_text_status_ok, dap_virtual_text_status = pcall(require, "nvim-dap-virtual-text")
if not dap_virtual_text_status_ok then
  return
end
--require("nvim-dap-virtual-text").setup()

dap_virtual_text_status.setup({
  enabled = true, -- enable this plugin (the default)
  enabled_commands = true, -- create commands DapVirtualTextEnable, DapVirtualTextDisable, DapVirtualTextToggle, (DapVirtualTextForceRefresh for refreshing when debug adapter did not notify its termination)
  highlight_changed_variables = true, -- highlight changed values with NvimDapVirtualTextChanged, else always NvimDapVirtualText
  highlight_new_as_changed = false, -- highlight new variables in the same way as changed variables (if highlight_changed_variables)
  show_stop_reason = true, -- show stop reason when stopped for exceptions
  commented = true, -- prefix virtual text with comment string
  only_first_definition = true, -- only show virtual text at first definition (if there are multiple)
  all_references = false, -- show virtual text on all all references of the variable (not only definitions)
  filter_references_pattern = "<module", -- filter references (not definitions) pattern when all_references is activated (Lua gmatch pattern, default filters out Python modules)
  -- experimental features:
  virt_text_pos = "eol", -- position of virtual text, see `:h nvim_buf_set_extmark()`
  all_frames = false, -- show virtual text for all stack frames not only current. Only works for debugpy on my machine.
  virt_lines = false, -- show virtual lines instead of virtual text (will flicker!)
  virt_text_win_col = nil -- position the virtual text at a fixed window column (starting from the first text column) ,
  -- e.g. 80 to position at column 80, see `:h nvim_buf_set_extmark()`
})

vim.cmd([[
  autocmd TermClose * if !v:event.status | exe 'bdelete! '..expand('<abuf>') | endif
]])
-- options
--dap.set_exception_breakpoints("default")
dap.defaults.fallback.switchbuf = 'uselast'
dap.defaults.fallback.focus_terminal = true
--dap.defaults.fallback.terminal_win_cmd = '10split new'
