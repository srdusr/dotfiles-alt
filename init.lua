--[[
              ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗
              ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║
              ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║
              ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║
              ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║
              ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝
              " ------------------------------------------------
              Author: srdusr
               Email: trevorgray@srdusr.com
                 Url: https://github.com/srdusr/nvim.git
              ------------------------------------------------ "
--]]
--[[init.]]
-- ========================================================================== --
-- ==                            DEPENDENCIES                              == --
-- ========================================================================== --

-- ripgrep    - https://github.com/BurntSushi/ripgrep
-- fd         - https://github.com/sharkdp/fd
-- git        - https://git-scm.com/
-- make       - https://www.gnu.org/software/make/
-- c compiler - gcc or tcc or zig

-- -------------------------------------------------------------------------- --

-- ================================== --
-- ==    Install neovim-nightly    == --
-- ================================== --

-- Download nvim-linux64.tar.gz:
--$ curl -L -o nvim-linux64.tar.gz https://github.com/neovim/neovim/releases/download/nightly/nvim-linux64.tar.gz
-- Extract:
--$ tar xzvf nvim-linux64.tar.gz --install-dir=/bin
-- Run:
--$ ./nvim-linux64/bin/nvim

-- ---------------------------------- --

-- Initialize config with this one liner in the terminal
--$ nvim --headless -c 'call mkdir(stdpath("config"), "p") | exe "edit" stdpath("config") . "/init.lua" | write | quit'

-- Command to see startup time
--$ nvim --startuptime startup.log -c exit && tail -100 startup.log

-- Load impatient (Faster loading times)
local impatient_ok, impatient = pcall(require, 'impatient')
if impatient_ok then
  impatient.enable_profile()
end

-- Schedule reading shadafile to improve the startup time
vim.opt.shadafile = 'NONE'
vim.schedule(function()
  vim.opt.shadafile = ''
  vim.cmd('silent! rsh')
end)

-- Load/reload modules
local modules = {
  'user.pack', -- Packer plugin manager
  'user.opts', -- Options
  'user.keys', -- Keymaps
  'user.mods', -- Modules/functions
  --"user.scripts",
  'plugins.treesitter',
  'plugins.neodev',
  --'plugins.colorscheme',
  'plugins.telescope',
  'plugins.nvim-tree',
  'plugins.web-devicons',
  'plugins.cmp',
  'plugins.quickfix',
  --"plugins.snippets",
  --"plugins.colorizer",
  --"plugins.prettier",
  --"plugins.git",
  'plugins.lsp',
  --"plugins.fugitive",
  'plugins.gitsigns',
  'plugins.sniprun',
  'plugins.session',
  'plugins.neoscroll',
  'plugins.statuscol',
  'plugins.trouble',
  'plugins.goto-preview',
  'plugins.autopairs',
  'plugins.navic',
  'plugins.toggleterm',
  'plugins.zen-mode',
  'plugins.fidget',
  'plugins.dap',
  'plugins.neotest',
  'plugins.heirline',
  'plugins.dashboard',
  'plugins.which-key',
  'plugins.harpoon',
  --"plugins.modify-blend",
}

-- Refresh module cache
for k, v in pairs(modules) do
  package.loaded[v] = nil
  require(v)
end

-- Improve speed by disabling some default plugins/modules
local builtins = {
  'gzip',
  'zip',
  'zipPlugin',
  'tar',
  'tarPlugin',
  'getscript',
  'getscriptPlugin',
  'vimball',
  'vimballPlugin',
  '2html_plugin',
  --"matchit",
  --"matchparen",
  'logiPat',
  'rrhelper',
  'netrw',
  'netrwPlugin',
  'netrwSettings',
  'netrwFileHandlers',
  'tutor_mode_plugin',
  'fzf',
  'spellfile_plugin',
  'sleuth',
}

for _, plugin in ipairs(builtins) do
  vim.g['loaded_' .. plugin] = 1
end
vim.g.do_filetype_lua = 1
vim.g.did_load_filetypes = 0

-- Snippets
--vim.g.snippets = 'luasnip'

-- Notifications
vim.notify = require('notify') -- Requires plugin "rcarriga/nvim-notify"

-- Colorscheme

-- Colors
vim.opt.termguicolors = true

-- Available colorschemes:
-- [[ nightfly ayu onedark doom-one nvimgelion github_dark tokyonight ]]

require('tokyonight').setup({
  style = 'night',
  transparent = true,
  transparent_sidebar = true,
  styles = {
    sidebars = 'transparent',
    floats = 'transparent',
  },
})

-- Define default color scheme
local default_colorscheme = 'tokyonight'
local fallback_colorscheme = 'desert'

-- Attempt to set the default color scheme
local status_ok, _ = pcall(vim.cmd, 'colorscheme ' .. default_colorscheme)

-- If the default color scheme is not found, use the fallback color scheme
if not status_ok then
  vim.cmd('colorscheme ' .. fallback_colorscheme)
end

vim.api.nvim_command('syntax on')
vim.api.nvim_command('highlight Normal guibg=NONE ctermbg=NONE')
vim.api.nvim_command('highlight NonText guibg=NONE ctermbg=NONE')
vim.api.nvim_command('highlight NormalNC guibg=NONE')
vim.api.nvim_command('highlight SignColumn guibg=NONE')
vim.api.nvim_command('highlight FoldColumn guibg=NONE')
vim.api.nvim_command('highlight CursorLineSign guibg=NONE ctermbg=NONE')
vim.api.nvim_command('highlight TabLine guibg=#333842 gui=bold')
vim.api.nvim_command('highlight Title guibg=NONE gui=bold')
vim.api.nvim_command('highlight TabLineSel guibg=#333842 gui=bold')
vim.api.nvim_command('highlight TabLineFill guibg=NONE gui=bold')
vim.api.nvim_command('highlight WinBar guibg=NONE gui=bold')
vim.api.nvim_command('highlight NormalFloat guibg=NONE')
vim.api.nvim_command('highlight LineNr guibg=NONE')
vim.api.nvim_command('highlight WinSeparator guibg=NONE gui=bold')
vim.api.nvim_command('highlight MsgSeparator guibg=NONE')
vim.api.nvim_command('highlight PmenuSel guibg=NONE')
vim.api.nvim_command('highlight winblend guibg=NONE')
vim.api.nvim_command('highlight EndOfBuffer guibg=NONE guifg=Normal')

-- Set different window separator colorscheme
vim.cmd([[
au WinEnter * setl winhl=WinSeparator:WinSeparatorA
au WinLeave * setl winhl=WinSeparator:WinSeparator
]])

require('notify').setup({
  background_colour = '#000000',
})
