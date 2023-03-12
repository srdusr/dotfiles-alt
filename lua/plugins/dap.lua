--local status, dap = pcall(require,"dap")
--if (not status) then return end
--local status2, dapui = pcall(require,"dapui")
--if (not status2) then return end
--local status3, daptext = pcall(require,"nvim-dap-virtual-text")
--if (not status3) then return end
--
--dapui.setup()
--daptext.setup({})
--
--vim.fn.sign_define('DapBreakpoint', {text='🔴'})
--vim.fn.sign_define('DapStopped', {text='🟢'})
--
--dap.listeners.after.event_initialized["dapui_config"] = function ()
--    dapui.open()
--end
--dap.listeners.before.event_terminated["dapui_config"] = function ()
--    dapui.close()
--end
--dap.listeners.before.event_exited["dapui_config"] = function ()
--    dapui.close()
--end
--
---- --- Adapters --- --
--
---- CPP Setup
--dap.adapters.cppdbg = {
--          id = 'cppdbg',
--          type = 'executable',
--          command = os.getenv("USERPROFILE") .. '\\dap_adapters\\cpptools\\extension\\debugAdapters\\bin\\OpenDebugAD7.exe',
--          options = {
--            detached = false
--        }
--}
--
--dap.adapters.codelldb = {
--      type = 'server',
--      port = "${port}",
--      executable = {
--            -- CHANGE THIS to your path!
--            command = os.getenv("USERPROFILE") .. "\\dap_adapters\\codelldb\\extension\\adapter\\codelldb",
--        args = {"--port", "${port}"},
--
--        -- On windows you may have to uncomment this:
--        detached = false,
--    }
--}
--
---- --- configurations --- --
--
---- CPP Setup
--dap.configurations.cpp = {
--      {
--            name = "DBG Debug",
--        type = "cppdbg",
--        request = "launch",
--        program = function()
--          return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
--        end,
--        cwd = '${workspaceFolder}',
--        stopAtEntry = true
--          },
--      {
--            name = "LLDB Debug",
--        type = "codelldb",
--        request = "launch",
--        program = function()
--          return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
--        end,
--        cwd = '${workspaceFolder}',
--        stopOnEntry = false
--          }
--}
--
--dap.configurations.c = dap.configurations.cpp
--dap DAP setup commands.
--
--
--Trevor Gray
--Covert this to lua (local dap (require :dap))
--(local dapui (require :dapui))
--(dapui.setup)
--
--(vim.api.nvim_set_hl 0 :DapBreakpoint {:ctermbg 0 :fg "#993939" :bg "#31353f"})
--
--(vim.api.nvim_set_hl 0 :DapBreakpointLine {:bg "#251215"})
--
--(vim.api.nvim_set_hl 0 :DapLogPoint {:ctermbg 0 :fg "#61afef" :bg  "#31353f"})
--
--(vim.api.nvim_set_hl 0 :DapLogPointLine {:bg "#252849"})
--
--(vim.api.nvim_set_hl 0 :DapStopped {:ctermbg 0 :fg "#98c379" :bg "#31353f"})
--(vim.api.nvim_set_hl 0 :DapStoppedLine {:bg "#15171B"})
--
--(vim.fn.sign_define :DapBreakpoint
--                    {:text ""
--                         :texthl :DapBreakpoint
--                         :linehl :DapBreakpointLine
--                         :numhl :DapBreakpoint})
--
--(vim.fn.sign_define :DapBreakpointCondition
--                    {:text "ﳁ"
--                         :texthl :DapBreakpoint
--                         :linehl :DapBreakpointLine
--                         :numhl :DapBreakpoint})
--
--(vim.fn.sign_define :DapBreakpointRejected
--                    {:text ""
--                         :texthl :DapBreakpoint
--                         :linehl :DapBreakpointLine
--                         :numhl :DapBreakpoint})
--
--(vim.fn.sign_define :DapLogPoint
--                    {:text ""
--                         :texthl :DapLogPoint
--                         :linehl :DapLogPointLine
--                         :numhl :DapLogPoint})
--
--(vim.fn.sign_define :DapStopped
--                    {:text ""
--                         :texthl :DapStopped
--                         :linehl :DapStoppedLine
--                         :numhl :DapStopped})
--
--(tset dap.listeners.after.event_initialized :dapui_config dapui.open)
--
--(tset dap.listeners.before.event_terminated :dapui_config dapui.close)
--
--(tset dap.listeners.before.event_exited :dapui_config dapui.close)
--
--(set dap.adapters.lldb {:type :executable
--                          :attach {:pidProperty :pid :pidSelect :ask}
--                          :command :lldb-vscode
--                            :env {:LLDB_LAUNCH_FLAG_LAUNCH_IN_TTY :YES}
--                            :name :lldb})
--
--local dap = require("dap")
--local dapui = require("dapui")
--dapui.setup()
--
--vim.api.nvim_set_hl(0, "DapBreakpoint", {ctermbg = 0, fg = "#993939", bg = "#31353f"})
--vim.api.nvim_set_hl(0, "DapBreakpointLine", {bg = "#251215"})
--vim.api.nvim_set_hl(0, "DapLogPoint", {ctermbg = 0, fg = "#61afef", bg = "#31353f"})
--vim.api.nvim_set_hl(0, "DapLogPointLine", {bg = "#252849"})
--vim.api.nvim_set_hl(0, "DapStopped", {ctermbg = 0, fg = "#98c379", bg = "#31353f"})
--vim.api.nvim_set_hl(0, "DapStoppedLine", {bg = "#15171B"})
--
--vim.fn.sign_define("DapBreakpoint", {text = "", texthl = "DapBreakpoint", linehl = "DapBreakpointLine", numhl = "DapBreakpoint"})
--vim.fn.sign_define("DapBreakpointCondition", {text = "ﳁ", texthl = "DapBreakpoint", linehl = "DapBreakpointLine", numhl = "DapBreakpoint"})
--vim.fn.sign_define("DapBreakpointRejected", {text = "", texthl = "DapBreakpoint", linehl = "DapBreakpointLine", numhl = "DapBreakpoint"})
--vim.fn.sign_define("DapLogPoint", {text = "", texthl = "DapLogPoint", linehl = "DapLogPointLine", numhl = "DapLogPoint"})
--vim.fn.sign_define("DapStopped", {text = "", texthl = "DapStopped", linehl = "DapStoppedLine", numhl = "DapStopped"})
--
--dap.listeners.after.event_initialized["dapui_config"] = function()
--dapui.open()
--end
--
--dap.listeners.before.event_terminated["dapui_config"] = function()
--dapui.close()
--end
--
--dap.listeners.before.event_exited["dapui_config"] = function()
--dapui.close()
--end
--
--dap.adapters.lldb = ({
--  type = "executable",
--  attach = {
--    pidProperty = "pid",
--    pidSelect = "ask",
--  },
--  command = "lldb-vscode",
--  env = {
--  LLDB_LAUNCH_FLAG_LAUNCH_IN_TTY = "YES",
--  },
--  name = "lldb"
--}).configurations.rust == dap.configurations.cpp
local dap_ok, dap = pcall(require, "dap")
if not (dap_ok) then
    print("nvim-dap not installed!")
  return
end

require('dap').set_log_level('INFO') -- Helps when configuring DAP, see logs with :DapShowLog

dap.configurations = {
      go = {
          {
        type = "go", -- Which adapter to use
        name = "Debug", -- Human readable name
        request = "launch", -- Whether to "launch" or "attach" to program
        program = "${file}", -- The buffer you are focused on when running nvim-dap
      },
    }
}
dap.adapters.go = {
    type = "server",
    port = "${port}",
    executable = {
        command = vim.fn.stdpath("data") .. '/mason/bin/dlv',
    args = { "dap", "-l", "127.0.0.1:${port}" },
  },
}
local dap_ui_ok, ui = pcall(require, "dapui")
if not (dap_ok and dap_ui_ok) then
    require("notify")("dap-ui not installed!", "warning")
  return
end

ui.setup({
    icons = { expanded = "▾", collapsed = "▸" },
  mappings = {
    open = "o",
    remove = "d",
    edit = "e",
    repl = "r",
    toggle = "t",
  },
  expand_lines = vim.fn.has("nvim-0.7"),
  layouts = {
    {
      elements = {
        "scopes",
      },
      size = 0.3,
      position = "right"
      },
    {
      elements = {
        "repl",
        "breakpoints"
        },
      size = 0.3,
      position = "bottom",
    },
  },
  floating = {
    max_height = nil,
    max_width = nil,
    border = "single",
    mappings = {
      close = { "q", "<Esc>" },
    },
  },
  windows = { indent = 1 },
  render = {
    max_type_length = nil,
  },
})
