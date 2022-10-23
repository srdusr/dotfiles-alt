--[[init.]]
-- ========================================================================== --
-- ==                            DEPENDENCIES                              == --
-- ========================================================================== --

-- ripgrep    - https://github.com/BurntSushi/ripgrep
-- fd         - https://github.com/sharkdp/fd
-- git        - https://git-scm.com/
-- make       - https://www.gnu.org/software/make/
-- c compiler - gcc or tcc or zig

-- Initialize config with this one liner in the terminal
--nvim --headless -c 'call mkdir(stdpath("config"), "p") | exe "edit" stdpath("config") . "/init.lua" | write | quit'
--
--local impatient_ok, impatient = pcall(require, "impatient")
--if impatient_ok then
--	impatient.enable_profile()
--end
--local stdpath = vim.fn.stdpath
local api = vim.api
local utils = require("user.utils")
vim.g.snippets = "luasnip"
-- check if we have the latest stable version of nvim
local expected_ver = "0.8.0"
local nvim_ver = utils.get_nvim_version()

if nvim_ver ~= expected_ver then
	local msg = string.format("Unsupported nvim version: expect %s, but got %s instead!", expected_ver, nvim_ver)
	api.nvim_err_writeln(msg)
	return
end
-- schedule reading shadafile to improve the startup time
vim.opt.shadafile = "NONE"
vim.schedule(function()
	vim.opt.shadafile = ""
	vim.cmd("silent! rsh")
end)
-- IMPORTS
require("impatient")

--for k, v in pairs(package.loaded) do
--for k in pairs(package.loaded) do
--  if string.match(k, "^user") then
--    package.loaded[k] = nil
--  end
--end

--for k, v in pairs(package.loaded) do
--  if string.match(k, "^user" ) then
--    package.loaded[k] = nil
--  else string.match(v, "^plugins" )
--    package.loaded[v] = nil
--  end
--end
require("user.utils")
require("user.keys") -- Keymaps
require("user.opts") -- Options
require("user.pack") -- Plugins
--require("user.reload")
--requirdkfse("mods") -- Modules/functions
--requirdkfe("deps") -- Plugins
require("plugins.treesitter")
require("plugins.telescope")
require("plugins.nvim-tree")
--requirdfke("scripts")
require("plugins.cmp")
require("plugins.luasnip")
--require("plugins.toggleterm")
--requirdfe("plugins.floatterm")
require("plugins.autopairs")
--requirdfe("plugins.vimspector")
--requirdfe("plugins.mason")
--requirdfe("plugins.dap")
require("plugins.colorizer")
require("plugins.prettier")
require("plugins.git")
require("plugins.gitsigns")
require("plugins.neoscroll")
require("plugins.lsp")
--requirdfe("plugins.lspconfig")
--requirdfe("plugins.lspsaga")
--requirdfe("plugins.lspkind")
require("plugins.null-ls")
require("plugins.web-devicons")
require("plugins.zen-mode")
require("plugins.colorscheme")
--requirdfe("plugins.lsp-colors")
--vim.opt.laststatus = 3

require("plugins.heirline")

--vim.api.nvim_command("luafile '/home/sxrdusr/.config/nvim/lua/plugins/heirline.lua'")
--vim.api.nvim_command(':luafile ~/.config/nvim/lua/plugins/heirline.lua')
---- Hide statusline by setting laststatus and cmdheight to 0.
--vim.o.ls = 0
--vim.o.ch = 0
--
---- Set the winbar to the statusline.
--vim.o.wbr = vim.o.stl
--
---- With vertical splits, the statusline would still show up at the
---- bottom of the split. A quick fix is to just set the statusline
---- to empty whitespace (it can't be an empty string because then
---- it'll get replaced by the default stline).
--vim.o.stl = " "

--for builtin, status in pairs({
--	["2html_plugin"] = 1,
--	["getscript"] = 1,
--	["getscriptPlugin"] = 1,
--	["gzip"] = 1,
--	["logipat"] = 1,
--	["netrwPlugin"] = 1,
--	["tar"] = 1,
--	["tarPlugin"] = 1,
--	["rrhelper"] = 1,
--	["vimball"] = 1,
--	["vimballPlugin"] = 1,
--	["zip"] = 1,
--	["zipPlugin"] = 1,
--	["tutor_mode_plugin"] = 1,
--	["fzf"] = 1,
--	["spellfile_plugin"] = 1,
--	["sleuth"] = 1,
--}) do
--	vim.g["loaded_" .. builtin] = status
--end


--local core_conf_files = {
--  "globals.lua", -- some global settings
--  "options.vim", -- setting options in nvim
--  "autocommands.vim", -- various autocommands
--  "mappings.lua", -- all the user-defined mappings
--  "plugins.vim", -- all the plugins installed and their configurations
--  "colorschemes.lua", -- colorscheme settings
--}
--
---- source all the core config files
--for _, name in ipairs(core_conf_files) do
--  local path = string.format("%s/core/%s", vim.fn.stdpath("config"), name)
--  local source_cmd = "source " .. path
--  vim.cmd(source_cmd)
--end

local builtins = {
	"gzip",
	"zip",
	"zipPlugin",
	"tar",
	"tarPlugin",
	"getscript",
	"getscriptPlugin",
	"vimball",
	"vimballPlugin",
	"2html_plugin",
	--"matchit",
	--"matchparen",
	"logiPat",
	"rrhelper",
	"netrw",
	"netrwPlugin",
	"netrwSettings",
	"netrwFileHandlers",
}

for _, plugin in ipairs(builtins) do
	vim.g["loaded_" .. plugin] = 1
end
vim.g.do_filetype_nvim = 1
vim.g.did_load_filetypes = 0
