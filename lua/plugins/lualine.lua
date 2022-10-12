local lualine_status_ok, lualine = pcall(require, "lualine")
if not lualine_status_ok then
	print("lualine.nvim is etiher broken or is not installed.")
	return
end

--local colors = require('tokyonight.colors').setup()
--local colors = {
--bg_dark = "#1f2335",
--bg = "#24283b",
--fg = "#c0caf5",
--fg_gutter = "#3b4261",
--green = "#a6e3a1",
--red = "#f38ba8",
--}

--local colors = {
--    gray       = '#23232e',
--    lightgray  = '#5f6a8e',
--    orange     = '#ffb86c',
--    purple     = '#bd93f9',
--    red        = '#ff5555',
--    yellow     = '#f1fa8c',
--    green      = '#50fa7b',
--    white      = '#f8f8f2',
--    black      = '#282a36',
--}
local colors = {
	nobg = nil,
	blue = "#87b0f9",
	mauve = "#cba6f7",
	red = "#f38ba8",
	green = "#a6e3a1",
	peach = "#fab387",
	white = "#c6d0f5",
	gray = "#a1a8c9",
	black = "#1e1e2e",
	innerbg = nil,
	outerbg = "#16161D",
}
--require("lualine").setup({
-- Your lua part of config goes here
require("lualine").setup({
	options = {
		icons_enabled = true,
		--theme = "auto",
		theme = require("plugins.linecolor").theme(),
		--theme = {
		-- We are going to use lualine_c an lualine_x as left and
		-- right section. Both are highlighte by c theme .  So we
		-- are just setting default looks o statusline
		--normal = { c = { fg = colors.fg, bg = colors.bg } },
		--inactive = { c = { fg = colors.fg, bg = colors.bg } },
		--},
		component_separators = { left = "", right = "" },
		section_separators = { left = "", right = "" },
		--component_separators = { left = '|', right = '|'},
		--section_separators = { left = '', right = ''},
		disabled_filetypes = {
			statusline = {},
			winbar = {},
		},
		ignore_focus = {},
		always_divide_middle = true,
		globalstatus = true,
		refresh = {
			statusline = 1000,
			tabline = 1000,
			winbar = 1000,
		},
	},
	sections = {
		lualine_a = { "mode" },
		lualine_b = {
			"branch",
			{
				"diff",
				colored = true,
				diff_color = {
					added = "DiffAdd",
					modified = "DiffChange",
					removed = "DiffDelete",
				},
			},
			{
				"diagnostics",

				sources = { "nvim_lsp" },
				sections = { "error", "warn", "info" },

				diagnostics_color = {
					error = "DiagnosticError",
					warn = "DiagnosticWarn",
					info = "DiagnosticInfo",
				},
				colored = true,
				update_in_insert = false,
				always_visible = false,
			},
		},
		--lualine_b = { "branch", "diff", "diagnostics" },
		lualine_c = {
			--{"filetype", padding={right=0}, icon_only = true, component_separators = {left = "", right = ""}},
			--{"filename", padding={left=0}, color = {gui = "bold,italic"}},
			--{ "filetype",
			--  icon_only = true,
			--},
			{
				"filename",
				--color = {gui = "bold,italic", fg = '#ffaa88', bg = 'nil' },
				--component_separators = {left = "", right = ""},
			},
		},
		lualine_x = { "encoding", "fileformat", "filetype" },
		--lualine_x = {
		--  {"encoding", color = { bg = colors.black }, component_separators = {left = "", right = ""}},
		--  {"fileformat", color = { bg = colors.black }, component_separators = {left = "", right = ""}},
		--  {"filetype", color = { bg = colors.black }, component_separators = {left = "", right = ""}},
		--},
		lualine_y = { "progress" },
		lualine_z = { "location" },
	},
	inactive_sections = {
		lualine_a = {},
		lualine_b = {},
		lualine_c = { "filename" },
		lualine_x = { "location" },
		lualine_y = {},
		lualine_z = {},
	},
	--	tabline = {},
	tabline = {
		--lualine_a = { "mode" },
		--lualine_a = {custom_fname},
		lualine_a = {
			{
				"buffers",
				show_filename_only = false,
				show_modified_status = true,
				mode = 4,
				buffers_color = {
					active = { bg = colors.nobg, fg = colors.black }, -- color for active buffer
					--inactive = { bg = colors.white, fg = colors.fg_gutter }, -- color for inactive buffer
					--active = { bg = colors.bg, fg = colors.white },   -- color for active buffer
					--inactive = { bg = colors.bg_dark, fg = colors.fg_gutter }, -- color for inactive buffer
					----color = function()
					----  return { bg = vim.bo.modified and '#aa3355' or '#33aa88' }
					----end,
				},
				symbols = {
					modified = " ●", -- Text to show when the buffer is modified
					alternate_file = "", -- Text to show to identify the alternate file
					--directory = "", -- Text to show when the buffer is a directory
				},
				max_length = vim.o.columns * 5 / 6,
				--{{function()
				--  local bg = 'hi! lualine_buffers_color' -- not modified
				--  if vim.bo.modified then bg = '#c70039' -- unsaved
				--  elseif not vim.bo.readonly then bg = 'hi! lualine_buffers_color' end -- readonly
				--  vim.cmd('hi! lualine_buffers_color guibg='..bg)
				--end,
				--color = 'hi! lualine_buffers_color',
				--}},
			},
		},
		lualine_b = {},
		lualine_c = {},
		lualine_x = {},
		lualine_y = {},
		lualine_z = {},
		--lualine_z = { "tabs" },
	},
	--tabline = {
	--  lualine_a = { "mode" },
	--  lualine_b = { "buffers" },
	--  lualine_c = { "branch" },
	--  --lualine_c = { "branch", "diff", "diagnostics" },
	--  lualine_x = {},
	--  lualine_y = {},
	--  lualine_z = { "tabs" },
	--},
	--winbar = {
	--  lualine_a = {},
	--  lualine_b = {},
	--  lualine_c = {'filename'},
	--  lualine_x = {},
	--  lualine_y = {},
	--  lualine_z = {}
	--},
	--inactive_winbar = {
	--  lualine_a = {},
	--  lualine_b = {},
	--  lualine_c = {},
	--  lualine_x = {},
	--  lualine_y = {},
	--  lualine_z = {}
	--},
	winbar = {},
	inactive_winbar = {},
	--extensions = {},
	extensions = { "quickfix" },
})
--require("lualine").statusline()
--require("lualine").tabline()
--if not lualine_status_ok then
--	print("lualine.nvim is etiher broken or is not installed.")
--	return
--end
--local lualine_status_ok, lualine = pcall(require, "lualine")
--if not lualine_status_ok then
--  print("lualine.nvim is etiher broken or is not installed.")
--  return
--end
--local utils = require("heirline.utils")

--local M = {}

-- stylua: ignore start
--M.colours = {--{{{
---- Color table for highlights
---- stylua: ignore
--local colors = {
--  bg       = '#2E3440',
--  fg       = '#E5E9F0',
--  yellow   = '#EBCB8B',
--  cyan     = '#88C0D0',
--  darkblue = '#5E81AC',
--  green    = '#A3BE8C',
--  orange   = '#D08770',
--  violet   = '#B48EAD',
--  magenta  = '#B48EAD',
--  blue     = '#81A1C1',
--  red      = '#BF616A',
--}
--
--local conditions = {
--	buffer_not_empty = function()
--		return vim.fn.empty(vim.fn.expand("%:t")) ~= 1
--	end,
--	hide_in_width = function()
--		return vim.fn.winwidth(0) > 80
--	end,
--	check_git_workspace = function()
--		local filepath = vim.fn.expand("%:p:h")
--		local gitdir = vim.fn.finddir(".git", filepath .. ";")
--		return gitdir and #gitdir > 0 and #gitdir < #filepath
--	end,
--}

-- Config
--local config = {
--require('lualine').setup {
--	options = {
--		-- Disable sections and component separators
--		component_separators = "",
--		section_separators = "",
--		theme = {
--			-- We are going to use lualine_c an lualine_x as left and
--			-- right section. Both are highlighte by c theme .  So we
--			-- are just setting default looks o statusline
--			normal = { c = { fg = colors.fg, bg = colors.bg } },
--			inactive = { c = { fg = colors.fg, bg = colors.bg } },
--		},
--		disabled_filetypes = { "NvimTree" },
--	},
--	sections = {
--		-- these are to remove the defaults
--		lualine_a = {},
--		lualine_b = {},
--		lualine_y = {},
--		lualine_z = {},
--		-- These will be filled later
--		lualine_c = {},
--		lualine_x = {},
--	},
--	inactive_sections = {
--		-- these are to remove the defaults
--		lualine_a = {},
--		lualine_b = {},
--		lualine_y = {},
--		lualine_z = {},
--		lualine_c = {},
--		lualine_x = {},
--	},
--}
--
---- Inserts a component in lualine_c at left section
--local function ins_left(component)
--	table.insert(lualine.sections.lualine_c, component)
--end
--
---- Inserts a component in lualine_x ot right section
--local function ins_right(component)
--	table.insert(lualine.sections.lualine_x, component)
--end
--
--ins_left({
--	function()
--		return "▊"
--	end,
--	color = { fg = colors.green }, -- Sets highlighting of component
--	padding = { left = 0, right = 1 }, -- We don't need space before this
--})
--
--ins_left({
--	-- mode component
--	function()
--		return ""
--	end,
--	color = function()
--		-- auto change color according to neovims mode
--		local mode_color = {
--			n = colors.blue,
--			i = colors.green,
--			v = colors.violet,
--			["�"] = colors.blue,
--			V = colors.blue,
--			c = colors.magenta,
--			no = colors.red,
--			s = colors.orange,
--			S = colors.orange,
--			ic = colors.yellow,
--			R = colors.violet,
--			Rv = colors.violet,
--			cv = colors.red,
--			ce = colors.red,
--			r = colors.cyan,
--			rm = colors.cyan,
--			["r?"] = colors.cyan,
--			["!"] = colors.red,
--			t = colors.red,
--		}
--		return { fg = mode_color[vim.fn.mode()] }
--	end,
--	padding = { right = 1 },
--})
--
--ins_left({
--	-- mode component
--	"mode",
--	color = function()
--		-- auto change color according to neovims mode
--		local mode_color = {
--			n = colors.red,
--			i = colors.green,
--			v = colors.violet,
--			["�"] = colors.blue,
--			V = colors.blue,
--			c = colors.magenta,
--			no = colors.red,
--			s = colors.orange,
--			S = colors.orange,
--			ic = colors.yellow,
--			R = colors.violet,
--			Rv = colors.violet,
--			cv = colors.red,
--			ce = colors.red,
--			r = colors.cyan,
--			rm = colors.cyan,
--			["r?"] = colors.cyan,
--			["!"] = colors.red,
--			t = colors.red,
--		}
--		return { fg = mode_color[vim.fn.mode()] }
--	end,
--	padding = { right = 1 },
--})
--
--ins_left({
--	"branch",
--	icon = "",
--	color = { fg = colors.violet, gui = "bold" },
--})
--
--ins_left({
--	"filename",
--	cond = conditions.buffer_not_empty,
--	color = { fg = colors.aqua, gui = "bold" },
--})
--
--ins_left({
--	-- filesize component
--	"filesize",
--	cond = conditions.buffer_not_empty,
--})
--
---- Add components to right sections
--ins_right({
--	"o:encoding", -- option component same as &encoding in viml
--	fmt = string.lower, -- I'm not sure why it's upper case either ;)
--	cond = conditions.hide_in_width,
--	color = { fg = colors.yellow },
--})
--
--ins_right({
--	"fileformat",
--	fmt = string.upper,
--	icons_enabled = true, -- I think icons are cool but Eviline doesn't have them. sigh
--	color = { fg = colors.fg, gui = "bold" },
--})
--
--ins_right({
--	"filetype",
--})
--
--ins_right({ "progress", color = { fg = colors.fg, gui = "bold" } })
--
--ins_right({
--	"location",
--})
--
--ins_right({
--	function()
--		return "▊"
--	end,
--	color = { fg = colors.green },
--	padding = { left = 1 },
--})
--return M
-- Now don't forget to initialize lualine
--require("lualine").setup(config)
--require"lualine".setup(config)
--lualine.setup(config)
