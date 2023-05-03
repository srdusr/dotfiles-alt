--[[ key.lua ]]
------------- Shorten Function Names --------------
local keymap = vim.keymap
local map = function(mode, l, r, opts)
  opts = opts or {}
  opts.silent = true
  opts.noremap = true
  keymap.set(mode, l, r, opts)
end
local term_opts = { noremap = true, silent = false }

--------------- Standard Operations ---------------
-- Semi-colon as leader key
vim.g.mapleader = ";"

-- Jump to next match on line using `.` instead of `;` NOTE: commented out in favour of "ggandor/flit.nvim"
--map("n", ".", ";")

-- Repeat last command using `<Space>` instead of `.` NOTE: commented out in favour of "ggandor/flit.nvim"
--map("n", "<Space>", ".")

-- "jj" to exit insert-mode
map("i", "jj", "<esc>")

-- Reload nvim config
map("n", "<leader><CR>",
  "<cmd>luafile ~/.config/nvim/init.lua<CR> | :echom ('Nvim config loading...') | :sl! | echo ('')<CR>")


--------------- Extended Operations ---------------
-- Conditional 'q' to quit on floating/quickfix/help windows otherwise still use it for macros
-- TODO: Have a list of if available on system/packages, example "Zen Mode" to not work on it (quit Zen Mode)
map('n', 'q', function()
  local config = vim.api.nvim_win_get_config(0)
  if config.relative ~= "" then -- is_floating_window?
    return ":silent! close!<CR>"
  elseif
      vim.o.buftype == 'quickfix' then
    return ":quit<CR>"
  elseif
      vim.o.buftype == 'help' then
    return ":close<CR>"
  else
    return "q"
  end
end, { expr = true, replace_keycodes = true })

-- Combine buffers list with buffer name
map("n", "<Leader>b", ":buffers<CR>:buffer<Space>")

-- Buffer confirmation
map("n", "<leader>y", ":BufferPick<CR>")

-- Map buffer next, prev and delete to <leader>+(n/p/d) respectively
map("n", "<leader>n", ":bn<cr>")
map("n", "<leader>p", ":bp<cr>")
map("n", "<leader>d", ":bd<cr>")

-- List marks
map("n", "<Leader>m", ":marks<CR>")

-- Messages
map("n", "<Leader>M", ":messages<CR>")

-- Clear messages

-- Clear messages or just refresh/redraw the screen
map("n", "<leader>u", ":echo '' | redraw<CR>")

-- Unsets the 'last search pattern' register by hitting return
--map("n", "<CR>", "!silent :noh<CR><CR>")

-- Toggle set number
map("n", "<leader>$", ":NumbersToggle<CR>")
map("n", "<leader>%", ":NumbersOnOff<CR>")

-- Easier split navigations, just ctrl-j instead of ctrl-w then j
--map("n", "<C-J>", "<C-W><C-J>")
--map("n", "<C-K>", "<C-W><C-K>")
--map("n", "<C-L>", "<C-W><C-L>")
--map("n", "<C-H>", "<C-W><C-H>")

-- Split window
map("n", "<leader>h", ":split<CR>")
map("n", "<leader>v", ":vsplit<CR>")
map("n", "<leader>c", "<C-w>c")

-- Resize Panes
map("n", "<Leader>+", ":resize +5<CR>")
map("n", "<Leader>-", ":resize -5<CR>")
map("n", "<Leader><", ":vertical resize +5<CR>")
map("n", "<Leader>>", ":vertical resize -5<CR>")
map("n", "<Leader>=", "<C-w>=")

-- Map Alt+(h/j/k/l) in insert mode to move directional
map("i", "<A-h>", "<left>")
map("i", "<A-j>", "<down>")
map("i", "<A-k>", "<up>")
map("i", "<A-l>", "<right>")

-- Map Alt+(h/j/k/l) in command mode to move directional
vim.api.nvim_set_keymap('c', '<A-h>', '<Left>', { noremap = true })
vim.api.nvim_set_keymap('c', '<A-j>', '<Down>', { noremap = true })
vim.api.nvim_set_keymap('c', '<A-k>', '<Up>', { noremap = true })
vim.api.nvim_set_keymap('c', '<A-l>', '<Right>', { noremap = true })

-- Create tab, edit and move between them
map("n", "<C-T>n", ":tabnew<CR>")
map("n", "<C-T>e", ":tabedit")
map("n", "<leader>[", ":tabprev<CR>")
map("n", "<leader>]", ":tabnext<CR>")

-- "Zoom" a split window into a tab and/or close it
--map("n", "<Leader>,", ":tabnew %<CR>")
--map("n", "<Leader>.", ":tabclose<CR>")

-- Vim TABs
map("n", "<leader>1", "1gt<CR>")
map("n", "<leader>2", "2gt<CR>")
map("n", "<leader>3", "3gt<CR>")
map("n", "<leader>4", "4gt<CR>")
map("n", "<leader>5", "5gt<CR>")
map("n", "<leader>6", "6gt<CR>")
map("n", "<leader>7", "7gt<CR>")
map("n", "<leader>8", "8gt<CR>")
map("n", "<leader>9", "9gt<CR>")
map("n", "<leader>0", "10gt<CR>")

-- Move to the next and previous item in the quickfixlist
--map("n", "]c", "<Cmd>cnext<CR>")
--map("n", "[c", "<Cmd>cprevious<CR>")

-- Hitting ESC when inside a terminal to get into normal mode
--map("t", "<Esc>", [[<C-\><C-N>]])

-- Move block (indentation) easily
map("n", "<", "<<", term_opts)
map("n", ">", ">>", term_opts)
map("x", "<", "<gv", term_opts)
map("x", ">", ">gv", term_opts)

-- Set alt+(j/k) to switch lines of texts or simply move them
map("n", "<A-k>", ':let save_a=@a<Cr><Up>"add"ap<Up>:let @a=save_a<Cr>')
map("n", "<A-j>", ':let save_a=@a<Cr>"add"ap:let @a=save_a<Cr>')

-- Search and replace
map("v", "<leader>sr", 'y:%s/<C-r><C-r>"//g<Left><Left>c')

-- Toggle Diff
map("n", "<leader>dt", "<Cmd>call utils#ToggleDiff()<CR>")

-- Map delete to Ctrl+l
map("i", "<C-l>", "<Del>")

-- Clear screen
map("n", "<leader><C-l>", "<Cmd>!clear<CR>")

-- Change file to an executable
map("n", "<leader>x", ":!chmod +x %<CR>")

-- Paste without replace clipboard
map("v", "p", '"_dP')

-- Swap two pieces of text, use x to cut in visual mode, then use Ctrl-x in
-- visual mode to select text to swap with
map("v", "<C-X>", "<Esc>`.``gvP``P")

-- Change Working Directory to current project
map("n", "<leader>cd", ":cd %:p:h<CR>:pwd<CR>")

-- Open the current file in the default program (on Mac this should just be just `open`)
map('n', '<leader>o', ':!xdg-open %<cr><cr>')

-- URL handling
if vim.fn.has("mac") == 1 then
  map("", "gx", '<Cmd>call jobstart(["open", expand("<cfile>")], {"detach": v:true})<CR>', {})
elseif vim.fn.has("unix") == 1 then
  map("", "gx", '<Cmd>call jobstart(["xdg-open", expand("<cfile>")], {"detach": v:true})<CR>', {})
elseif vim.fn.has("wsl") == 1 then
  map("", "gx", '<Cmd>call jobstart(["wslview", expand("<cfile>")], {"detach": v:true})<CR>', {})
else
  map[''].gx = { '<Cmd>lua print("Error: gx is not supported on this OS!")<CR>' }
end

-- Toggle completion
map("n", "<Leader>tc", ":lua require('user.mods').toggle_completion()<CR>")

-- Disable default completion.
map('i', '<C-n>', '<Nop>')
map('i', '<C-p>', '<Nop>')

-- Set line wrap
map("n", "<M-z>", function()
  local wrap_status = vim.api.nvim_exec("set wrap ?", true)

  if wrap_status == "nowrap" then
    vim.api.nvim_command("set wrap linebreak")
    print("Wrap enabled")
  else
    vim.api.nvim_command("set wrap nowrap")
    print("Wrap disabled")
  end
end, { silent = true })

-- Toggle between folds
--utils.map("n", "<F2>", "&foldlevel ? 'zM' : 'zR'", { expr = true })

-- Use space to toggle fold
--utils.map("n", "<Space>", "za")

-- Make a copy of current file
vim.cmd([[
  map <leader>s :up \| saveas! %:p:r-<C-R>=strftime("%y.%m.%d-%H:%M")<CR>-bak.<C-R>=expand("%:e")<CR> \| 3sleep \| e #<CR>
]])

-- Toggle transparency
map('n', '<leader>tb', ':call utils#Toggle_transparent_background()<CR>')

-- Toggle zoom
map("n", "<leader>z", ":call utils#ZoomToggle()<CR>")
map("n", "<C-w>z", "<C-w>|<C-w>_")

-- Toggle statusline
map('n', '<S-h>', ':call ToggleHiddenAll()<CR>')

-- Open last closed buffer
map("n", "<C-t>", ":call OpenLastClosed()<CR>")


---------------- Plugin Operations ----------------
-- Packer
map("n", "<leader>Pc", "<cmd>PackerCompile<cr>")
map("n", "<leader>Pi", "<cmd>PackerInstall<cr>")
map("n", "<leader>Ps", "<cmd>PackerSync<cr>")
map("n", "<leader>PS", "<cmd>PackerStatus<cr>")
map("n", "<leader>Pu", "<cmd>PackerUpdate<cr>")

-- Tmux navigation (aserowy/tmux.nvim)
map('n', '<C-h>', '<CMD>NavigatorLeft<CR>')
map('n', '<C-l>', '<CMD>NavigatorRight<CR>')
map('n', '<C-k>', '<CMD>NavigatorUp<CR>')
map('n', '<C-j>', '<CMD>NavigatorDown<CR>')

-- ToggleTerm
--map("n", "<leader>tt", "<cmd>ToggleTerm<cr>")

-- LazyGit
map({ "n", "t" }, "<leader>gg", "<cmd>lua Lazygit_toggle()<CR>")

-- Fugitive git bindings
map("n", "<leader>ga", ":Git add %:p<CR><CR>")
--map("n", "<leader>gs", ":Gstatus<CR>")
map("n", "<leader>gc", ":Gcommit -v -q<CR>")
map("n", "<leader>gt", ":Gcommit -v -q %:p<CR>")
--map("n", "<leader>gd", ":Gdiff<CR>")
map("n", "<leader>ge", ":Gedit<CR>")
--map("n", "<leader>gr", ":Gread<Cj>")
map("n", "<leader>gw", ":Gwrite<CR><CR>")
map("n", "<leader>gl", ":silent! Glog<CR>:bot copen<CR>")
--map("n", "<leader>gp", ":Ggrep<Space>")
--map("n", "<Leader>gp", ":Git push<CR>")
--map("n", "<Leader>gb", ":Gblame<CR>")
map("n", "<leader>gm", ":Gmove<Space>")
--map("n", "<leader>gb", ":Git branch<Space>")
--map("n", "<leader>go", ":Git checkout<Space>")
--map("n", "<leader>gps", ":Dispatch! git push<CR>")
--map("n", "<leader>gpl", ":Dispatch! git pull<CR>")
--  map["<C-\\>"] = { "<cmd>ToggleTerm<cr>", desc = "Toggle terminal" }
--  map["<leader>tn"] = { function() toggle_term_cmd "node" end, desc = "ToggleTerm node" }
--  map["<leader>tu"] = { function() toggle_term_cmd "ncdu" end, desc = "ToggleTerm NCDU" }
--  map["<leader>tt"] = { function() toggle_term_cmd "htop" end, desc = "ToggleTerm htop" }
--  map["<leader>tp"] = { function() toggle_term_cmd "python" end, desc = "ToggleTerm python" }
--  map["<leader>tl"] = { function() toggle_term_cmd "lazygit" end, desc = "ToggleTerm lazygit" }
--  map["<leader>tf"] = { "<cmd>ToggleTerm direction=float<cr>", desc = "ToggleTerm float" }
--  map["<leader>th"] = { "<cmd>ToggleTerm size=10 direction=horizontal<cr>", desc = "ToggleTerm horizontal split" }
--  map["<leader>tv"] = { "<cmd>ToggleTerm size=80 direction=vertical<cr>", desc = "ToggleTerm vertical split" }
--end

-- Telescope
map("n", "<leader>ff", function() require("telescope.builtin").find_files { hidden = true, no_ignore = true } end) -- find all files
map("n", "<leader>fF", "<cmd>lua require('telescope.builtin').find_files()<cr>")                                   -- find files with hidden option
map("n", "<leader>fg", "<cmd>lua require('telescope.builtin').live_grep()<cr>")
map("n", "<leader>fb", "<cmd>lua require('telescope.builtin').buffers()<cr>")
map("n", "<leader>fh", "<cmd>lua require('telescope.builtin').help_tags()<cr>")
map("n", "<leader>fc", "<cmd>lua require('telescope.builtin').commands()<cr>")
map("n", "<leader>ffc", "<cmd>lua require('telescope.builtin').current_buffer_fuzzy_find()<cr>")
map("n", "<leader>cf", "<cmd>Telescope changed_files<cr>")
map("n", "<leader>fp", "<cmd>Telescope pickers<cr>")
map("n", "<leader>fr", "<cmd>lua require('telescope.builtin').registers({})<CR>") -- registers picker
map("n", "<leader>fd", "<cmd>lua require('telescope.builtin').diagnostics()<cr>")
map("n", "<leader>fk", "<cmd>lua require('telescope.builtin').keymaps()<cr>")
map("n", "<leader>fn", [[<Cmd>lua require'plugins.telescope'.find_notes()<CR>]])                   -- find notes
map("n", "<leader>fgn", [[<Cmd>lua require'plugins.telescope'.grep_notes()<CR>]])                  -- search notes
map("n", "<leader>f.", [[<Cmd>lua require'plugins.telescope'.find_configs()<CR>]])                 -- find configs
map("n", "<leader>fs", [[<Cmd>lua require'plugins.telescope'.find_scripts()<CR>]])                 -- find scripts
map("n", "<leader>fw", [[<Cmd>lua require'plugins.telescope'.find_projects()<CR>]])                -- find projects
map("n", "<leader>fm", "<cmd>lua require('telescope').extensions.media_files.media_files({})<cr>") -- find media files
map("n", "<leader>fi", "<cmd>lua require('telescope').extensions.notify.notify({})<cr>")           -- find notifications

-- FZF
map("n", "<leader>fz", "<cmd>lua require('fzf-lua').files()<CR>")

-- Nvim-tree
map("n", "<leader>f", ":NvimTreeToggle<CR>", {})

-- Markdown-preview
map("n", "<leader>md", "<Plug>MarkdownPreviewToggle")
map("n", "<leader>mg", "<CMD>Glow<CR>")

-- Autopairs
map("n", "<leader>ww", "<cmd>lua require('user.mods').Toggle_autopairs()<CR>")

-- Zen-mode toggle
map("n", "<leader>zm", "<CMD>ZenMode<CR> | :echom ('Zen Mode')<CR> | :sl! | echo ('')<CR>")

-- Vim-rooter
map("n", "<leader>ro", "<CMD>Rooter<CR> | :echom ('cd to root/project directory')<CR> | :sl! | echo ('')<CR>", term_opts)

-- Trouble (UI to show diagnostics)
map("n", "<leader>t", "<CMD>TroubleToggle<CR>")
map("n", "<leader>tw", "<CMD>TroubleToggle workspace_diagnostics<CR>")
map("n", "<leader>td", "<CMD>TroubleToggle document_diagnostics<CR>")
map("n", "<leader>tq", "<CMD>TroubleToggle quickfix<CR>")
map("n", "<leader>tl", "<CMD>TroubleToggle loclist<CR>")
map("n", "gR", "<CMD>TroubleToggle lsp_references<CR>")

-- Replacer
map('n', '<Leader>qr', ':lua require("replacer").run()<CR>')

-- Quickfix
map("n", "<leader>q", function()
  if vim.fn.getqflist({ winid = 0 }).winid ~= 0 then
    require('plugins.quickfix').close()
  else
    require('plugins.quickfix').open()
    --require("quickfix").open()
  end
end, { desc = "Toggle quickfix window" })

-- Dap (debugging)
local dap_ok, dap = pcall(require, "dap")
local dap_ui_ok, ui = pcall(require, "dapui")

if not (dap_ok and dap_ui_ok) then
  require("notify")("nvim-dap or dap-ui not installed!", "warning")
  return
end

vim.fn.sign_define('DapBreakpoint', { text = '🐞' })

-- Start debugging session
map("n", "<leader>ds", function()
  dap.continue()
  ui.toggle({})
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-w>=", false, true, true), "n", false) -- Spaces buffers evenly
end)

-- Set breakpoints, get variable values, step into/out of functions, etc.
map("n", "<leader>dl", require("dap.ui.widgets").hover)
map("n", "<leader>dc", dap.continue)
map("n", "<leader>db", dap.toggle_breakpoint)
map("n", "<leader>dn", dap.step_over)
map("n", "<leader>di", dap.step_into)
map("n", "<leader>do", dap.step_out)
map("n", "<leader>dC", function()
  dap.clear_breakpoints()
  require("notify")("Breakpoints cleared", "warn")
end)

-- Close debugger and clear breakpoints
map("n", "<leader>de", function()
  dap.clear_breakpoints()
  ui.toggle({})
  dap.terminate()
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-w>=", false, true, true), "n", false)
  require("notify")("Debugger session ended", "warn")
end)

-- Dashboard
map("n", "<leader><Space>", "<CMD>Dashboard<CR>")

-- Lsp Lines toggle
map("", "<Leader>l", require("lsp_lines").toggle, { desc = "Toggle lsp_lines" })
