local conditions = require("heirline.conditions")
local utils = require("heirline.utils")

-- Colors
--local colors = {
--    bright_bg = utils.get_highlight("Folded").bg,
--    bright_fg = utils.get_highlight("Folded").fg,
--    red = utils.get_highlight("DiagnosticError").fg,
--    dark_red = utils.get_highlight("DiffDelete").bg,
--    green = utils.get_highlight("String").fg,
--    blue = utils.get_highlight("Function").fg,
--    gray = utils.get_highlight("NonText").fg,
--    orange = utils.get_highlight("Constant").fg,
--    purple = utils.get_highlight("Statement").fg,
--    cyan = utils.get_highlight("Special").fg,
--    diag_warn = utils.get_highlight("DiagnosticWarn").fg,
--    diag_error = utils.get_highlight("DiagnosticError").fg,
--    diag_hint = utils.get_highlight("DiagnosticHint").fg,
--    diag_info = utils.get_highlight("DiagnosticInfo").fg,
--    git_del = utils.get_highlight("diffDeleted").fg,
--    git_add = utils.get_highlight("diffAdded").fg,
--    git_change = utils.get_highlight("diffChanged").fg,
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
	bg = "#333842",
	nobg = nil,
	bright_fg = "#ffffff",
	bright_bg = "#000000",
	brown = "#504945",
	white = "#f8f8f0",
	grey = "#8F908A",
	pink = "#f92672",
	--green = "#a6e22e",
	green = "#AAD94C",
	--blue = "#66d9ef",
	blue = "#39BAE6",
	yellow = "#e6db74",
	--orange = "#fd971f",
	orange = "#FA8D3F",
	purple = "#ae81ff",
	--red = "#e95678",
	red = "#F07171",
	cyan = "#66d9eC",
	mode_fg = "#242424",
	diag = {
		warn = utils.get_highlight("DiagnosticSignWarn").fg,
		error = utils.get_highlight("DiagnosticSignError").fg,
		hint = utils.get_highlight("DiagnosticSignHint").fg,
		info = utils.get_highlight("DiagnosticSignInfo").fg,
	},
	git = {
		del = "#e95678",
		add = "#a6e22e",
		change = "#ae81ff",
	},
}

require("heirline").load_colors(colors)

--local mode_lable = {
--	n         = 'NORMAL',
--	no        = 'OPPEND',
--	nov       = 'N?',
--	noV       = 'N?',
--	['no\22'] = 'N?',
--	niI       = 'Ni',
--	niR       = 'Nr',
--	niV       = 'Nv',
--	nt        = 'N-TERM',
--	v         = 'VISUAL',
--	vs        = 'Vs',
--	V         = 'V-LINE',
--	Vs        = 'Vs',
--	['\22']   = 'V-BLCK',
--	['\22s']  = '^V',
--	s         = 'SELECT',
--	S         = 'S-LINE',
--	['\19']   = 'S-BLCK',
--	i         = 'INSERT',
--	ic        = 'ICOMPL',
--	ix        = 'Ix',
--	R         = 'REPLACE',
--	Rc        = 'Rc',
--	Rx        = 'Rx',
--	Rv        = 'VRPLCE',
--	Rvc       = 'Rv',
--	Rvx       = 'Rv',
--	c         = 'CMMAND',
--	cv        = 'PROMPT',
--	r         = '...',
--	rm        = 'MORE',
--	['r?']    = 'CNFIRM',
--	['!']     = 'SHELL',
--	t         = 'TERM',
--}
--
--local mode_colors_table = {
--	n        = 'red',
--	no       = 'blue',
--	nov      = 'blue',
--	noV      = 'blue',
--	niI      = 'red',
--	niR      = 'red',
--	niV      = 'red',
--	nt       = 'red',
--	v        = 'cyan',
--	vs       = 'cyan',
--	V        = 'cyan',
--	Vs       = 'cyan',
--	['\22']  = 'cyan',
--	['\22s'] = 'cyan',
--	s        = 'purple',
--	S        = 'purple',
--	['\19']  = 'purple',
--	i        = 'blue',
--	ic       = 'blue',
--	ix       = 'blue',
--	R        = 'orange',
--	Rc       = 'orange',
--	Rx       = 'orange',
--	Rv       = 'orange',
--	Rvc      = 'orange',
--	Rvx      = 'orange',
--	c        = 'green',
--	cv       = 'green',
--	r        = 'green',
--	rm       = 'green',
--	['r?']   = 'green',
--	['!']    = 'red',
--	t        = 'red',
--}
--
--local mode_colors = setmetatable({
--	n = { fg = 'red' }
--}, {
--	__index = function(_, mode)
--		return {
--			fg = 'mode_fg',
--			bg = mode_colors_table[mode],
--		}
--	end
--})
--
--
--local VimModeNormal = {
--	condition = function(self)
--		return self.mode == 'n'
--	end,
--	provider = ' ●',
--}
--
--local VimModeOthers = {
--	condition = function(self)
--		return self.mode ~= 'n'
--	end,
--
--	utils.surround({ '', '' },
--		function(self)
--			return mode_colors[self.mode].bg
--		end,
--		{
--			{
--				provider = function(self)
--					return '● ' .. mode_lable[self.mode]
--				end,
--			},
--			hl = function(self)
--				return mode_colors[self.mode]
--			end
--		}
--	),
--}
--
--local ViMode = {
--	init = function(self)
--		self.mode = vim.fn.mode(1)
--	end,
--
--	VimModeNormal, VimModeOthers,
--
--	update = { 'ModeChanged' }
--}
--local colors = require'kanagawa.colors'.setup() -- wink

--utils.surround({ "", "" }, function(self) return self:mode_color() end, {Ruler, hl = {fg = 'black'}} ),
-- we are surrounding the component and adjusting the foreground in one go!

-- ViMode truemode
--local ViMode = {
--	-- get vim current mode, this information will be required by the provider
--	-- and the highlight functions, so we compute it only once per component
--	-- evaluation and store it as a component attribute
--	init = function(self)
--		self.mode = vim.fn.mode(1) -- :h mode()
--
--		-- execute this only once, this is required if you want the ViMode
--		-- component to be updated on operator pending mode
--		if not self.once then
--			vim.api.nvim_create_autocmd("ModeChanged", {
--				pattern = "*:*o",
--				command = "redrawstatus",
--			})
--			self.once = true
--		end
--	end,
--	-- Now we define some dictionaries to map the output of mode() to the
--	-- corresponding string and color. We can put these into `static` to compute
--	-- them at initialisation time.
--	static = {
--		mode_names = { -- change the strings if you like it vvvvverbose!
--			["n"] = "NORMAL ",
--			["no"] = "N·OPERATOR PENDING ",
--			["v"] = "VISUAL ",
--			["V"] = "V·LINE ",
--			[""] = "V·BLOCK ",
--			["s"] = "SELECT ",
--			["S"] = "S·LINE ",
--			[""] = "S·BLOCK ",
--			["i"] = "INSERT ",
--			["R"] = "REPLACE ",
--			["Rv"] = "V·REPLACE ",
--			["c"] = "COMMAND ",
--			["cv"] = "VIM EX ",
--			["ce"] = "EX ",
--			["r"] = "PROMPT ",
--			["rm"] = "MORE ",
--			["r?"] = "CONFIRM ",
--			["!"] = "SHELL ",
--			["t"] = "TERMINAL ",
--		},
--		mode_colors = {
--			n = colors.blue,
--			i = colors.green,
--			v = colors.purple,
--			V = colors.purple,
--			[""] = colors.purple,
--			c = colors.red,
--			s = colors.purple,
--			S = colors.purple,
--			[""] = colors.purple,
--			R = colors.orange,
--			r = colors.orange,
--			["!"] = colors.red,
--			t = colors.red,
--			--n = "blue" ,
--			--i = "green",
--			--v = "cyan",
--			--V =  "cyan",
--			--["\22"] =  "cyan",
--			--c =  "orange",
--			--s =  "purple",
--			--S =  "purple",
--			--["\19"] =  "purple",
--			--R =  "orange",
--			--r =  "orange",
--			--["!"] =  "red",
--			--t =  "red",
--		},
--	},
--	-- We can now access the value of mode() that, by now, would have been
--	-- computed by `init()` and use it to index our strings dictionary.
--	-- note how `static` fields become just regular attributes once the
--	-- component is instantiated.
--	-- To be extra meticulous, we can also add some vim statusline syntax to
--	-- control the padding and make sure our string is always at least 2
--	-- characters long. Plus a nice Icon.
--	provider = function(self)
--		return " %2(" .. self.mode_names[self.mode] .. "%)"
--		--return " %2("..self.mode_names[self.mode].."%)"
--		--
--		--
--		--
--	end,
--	-- Same goes for the highlight. Now the foreground will change according to the current mode.
--	hl = function(self)
--		local mode = self.mode:sub(1, 1) -- get only the first mode character
--		--return { fg = self.mode_colors[mode], bold = true, }
--		return { bg = self.mode_colors[mode], fg = colors.bg, bold = true }
--	end,
--	-- Re-evaluate the component only on ModeChanged event!
--	-- This is not required in any way, but it's there, and it's a small
--	-- performance improvement.
--	update = {
--		"ModeChanged",
--	}, --optional
--}
local ViMode = {
	static = {
		mode_names = { -- change the strings if you like it vvvvverbose!
			["n"] = "NORMAL ",
			["no"] = "N·OPERATOR PENDING ",
			["v"] = "VISUAL ",
			["V"] = "V·LINE ",
			[""] = "V·BLOCK ",
			["s"] = "SELECT ",
			["S"] = "S·LINE ",
			[""] = "S·BLOCK ",
			["i"] = "INSERT ",
			["R"] = "REPLACE ",
			["Rv"] = "V·REPLACE ",
			["c"] = "COMMAND ",
			["cv"] = "VIM EX ",
			["ce"] = "EX ",
			["r"] = "PROMPT ",
			["rm"] = "MORE ",
			["r?"] = "CONFIRM ",
			["!"] = "SHELL ",
			["t"] = "TERMINAL ",
		},
	},
	provider = function(self)
		return " %2(" .. self.mode_names[vim.fn.mode(1)] .. "%)"
	end,
	hl = function(self)
		local color = self:mode_color() -- here!
		return { bg = color, fg = colors.bg, bold = true }
	end,
}

local ViModeColor = {
	static = {
		mode_colors_map = {
			n = colors.blue,
			i = colors.green,
			v = colors.purple,
			V = colors.purple,
			[""] = colors.purple,
			c = colors.red,
			s = colors.purple,
			S = colors.purple,
			[""] = colors.purple,
			R = colors.orange,
			r = colors.orange,
			["!"] = colors.red,
			t = colors.red,
		},
		mode_color = function(self)
			local mode = conditions.is_active() and vim.fn.mode() or "n"
			return self.mode_colors_map[mode]
		end,
	},
}

-- LSP

--local LSPActive = {
--    condition = conditions.lsp_attached,
--    update = {'LspAttach', 'LspDetach'},
--
--    -- You can keep it simple,
--    -- provider = " [LSP]",
--
--    -- Or complicate things a bit and get the servers names
--    provider  = function()
--        local names = {}
--        for i, server in pairs(vim.lsp.buf_get_clients(0)) do
--            table.insert(names, server.name)
--        end
--        return " [" .. table.concat(names, " ") .. "]"
--    end,
--    hl = { fg = "green", bold = true },
--    on_click = {
--        callback = function()
--            vim.defer_fn(function()
--                vim.cmd("LspInfo")
--            end, 100)
--        end,
--        name = "heirline_LSP",
--    },
--}
--
---- lsp status
---- I personally use it only to display progress messages!
---- See lsp-status/README.md for configuration options.
--
---- Note: check "j-hui/fidget.nvim" for a nice statusline-free alternative.
--local LSPMessages = {
--    provider = require("lsp-status").status,
--    hl = { fg = "gray" },
--}

-- Nvim Navic
--local Navic = {
--    condition = require("nvim-navic").is_available,
--    provider = require("nvim-navic").get_location,
--}
--local Navic = utils.make_flexible_component(3, Navic, { provider = "" })

-- Full nerd (with icon colors)!
local Navic = {
	condition = require("nvim-navic").is_available,
	static = {
		-- create a type highlight map
		type_hl = {
			File = "Directory",
			Module = "Include",
			Namespace = "TSNamespace",
			Package = "Include",
			Class = "Struct",
			Method = "Method",
			Property = "TSProperty",
			Field = "TSField",
			Constructor = "TSConstructor ",
			Enum = "TSField",
			Interface = "Type",
			Function = "Function",
			Variable = "TSVariable",
			Constant = "Constant",
			String = "String",
			Number = "Number",
			Boolean = "Boolean",
			Array = "TSField",
			Object = "Type",
			Key = "TSKeyword",
			Null = "Comment",
			EnumMember = "TSField",
			Struct = "Struct",
			Event = "Keyword",
			Operator = "Operator",
			TypeParameter = "Type",
		},
	},
	init = function(self)
		local data = require("nvim-navic").get_data() or {}
		local children = {}
		-- create a child for each level
		for i, d in ipairs(data) do
			local child = {
				{
					provider = d.icon,
					hl = self.type_hl[d.type],
				},
				{
					provider = d.name,
					-- highlight icon only or location name as well
					-- hl = self.type_hl[d.type],
				},
			}
			-- add a separator only if needed
			if #data > 1 and i < #data then
				table.insert(child, {
					provider = " > ",
					hl = { fg = "bright_fg" },
				})
			end
			table.insert(children, child)
		end
		-- instantiate the new child, overwriting the previous one
		self[1] = self:new(children, 1)
	end,
	hl = { fg = "gray" },
}

-- Diagnostics
local Diagnostics = {

	condition = conditions.has_diagnostics,

	static = {
		error_icon = vim.fn.sign_getdefined("DiagnosticSignError")[1].text,
		warn_icon = vim.fn.sign_getdefined("DiagnosticSignWarn")[1].text,
		info_icon = vim.fn.sign_getdefined("DiagnosticSignInfo")[1].text,
		hint_icon = vim.fn.sign_getdefined("DiagnosticSignHint")[1].text,
	},

	init = function(self)
		self.errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
		self.warnings = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
		self.hints = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })
		self.info = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO })
	end,

	update = { "DiagnosticChanged", "BufEnter" },

	{
		provider = function(self)
			-- 0 is just another output, we can decide to print it or not!
			return self.errors > 0 and (self.error_icon .. self.errors .. " ")
		end,
		hl = { fg = colors.diag.error, bg = colors.bg },
	},
	{
		provider = function(self)
			return self.warnings > 0 and (self.warn_icon .. self.warnings .. " ")
		end,
		hl = { fg = colors.diag.warn, bg = colors.bg },
	},
	{
		provider = function(self)
			return self.info > 0 and (self.info_icon .. self.info .. " ")
		end,
		hl = { fg = colors.diag.info, bg = colors.bg },
	},
	{
		provider = function(self)
			return self.hints > 0 and (self.hint_icon .. self.hints)
		end,
		hl = { fg = colors.diag.hint, bg = colors.bg },
	},
	--{
	--    provider = "]",
	--},
	on_click = {
		callback = function()
			require("trouble").toggle({ mode = "document_diagnostics" })
			-- or
			-- vim.diagnostic.setqflist()
		end,
		name = "heirline_diagnostics",
	},
}

-- Git
-- For the ones who're not (too) afraid of changes! Uses gitsigns.
local Git = {
	condition = conditions.is_git_repo,

	init = function(self)
		self.status_dict = vim.b.gitsigns_status_dict
		self.has_changes = self.status_dict.added ~= 0 or self.status_dict.removed ~= 0 or self.status_dict.changed ~= 0
	end,
	--hl = { fg = "orange" },
	hl = { fg = colors.orange, bg = colors.bg },
	{ -- git branch name
		provider = function(self)
			return " " .. self.status_dict.head
		end,
		--hl = { bold = true },
		hl = { bold = true, bg = colors.bg },
	},
	-- You could handle delimiters, icons and counts similar to Diagnostics
	{
		condition = function(self)
			return self.has_changes
		end,
		--provider = "("
		provider = " ",
	},
	{
		provider = function(self)
			local count = self.status_dict.added or 0
			--return count > 0 and ("+" .. count)
			return count > 0 and ("  " .. count)
		end,
		--hl = { fg = "git_add" },
		hl = { fg = colors.git.add, bg = colors.bg },
	},
	{
		provider = function(self)
			local count = self.status_dict.removed or 0
			--return count > 0 and ("-" .. count)
			return count > 0 and ("  " .. count)
		end,
		--hl = { fg = "git_del" },
		hl = { fg = colors.git.del, bg = colors.bg },
	},
	{
		provider = function(self)
			local count = self.status_dict.changed or 0
			--return count > 0 and ("~" .. count)
			return count > 0 and ("  " .. count)
		end,
		--hl = { fg = "git_change" },
		hl = { fg = colors.git.change, bg = colors.bg },
	},
	--{
	--    condition = function(self)
	--        return self.has_changes
	--    end,
	--    provider = ")",
	--},
	on_click = {
		callback = function()
			-- If you want to use Fugitive:
			-- vim.cmd("G")

			-- If you prefer Lazygit
			-- use vim.defer_fn() if the callback requires
			-- opening of a floating window
			-- (this also applies to telescope)
			vim.defer_fn(function()
				vim.cmd("Lazygit")
			end, 100)
		end,
		name = "heirline_git",
	},
}

-- Debugger
-- Display informations from nvim-dap!
local DAPMessages = {
	-- display the dap messages only on the debugged file
	condition = function()
		local session = require("dap").session()
		if session then
			local filename = vim.api.nvim_buf_get_name(0)
			if session.config then
				local progname = session.config.program
				return filename == progname
			end
		end
		return false
	end,
	provider = function()
		return " " .. require("dap").status()
	end,
	hl = { fg = utils.get_highlight("Debug").fg },
	-- Debugger on_click: step-over, step-into, next, previous, stop buttons
	--    coming soon!
}

-- Tests
-- This requires the great ultest.
--local UltTest = {
--    condition = function()
--        return vim .api.nvim_call_function("ultest#is_test_file", {}) ~= 0
--    end,
--    static = {
--        passed_icon = vim.fn.sign_getdefined("test_pass")[1].text,
--        failed_icon = vim.fn.sign_getdefined("test_fail")[1].text,
--        passed_hl = { fg = utils.get_highlight("UltestPass").fg },
--        failed_hl = { fg = utils.get_highlight("UltestFail").fg },
--    },
--    init = function(self)
--        self.status = vim.api.nvim_call_function("ultest#status", {})
--    end,
--
--    -- again, if you'd like icons and numbers to be colored differently,
--    -- just split the component in two
--    {
--        provider = function(self)
--            return self.passed_icon .. self.status.passed .. " "
--        end,
--        hl = function(self)
--            return self.passed_hl
--        end,
--    },
--    {
--        provider = function(self)
--            return self.failed_icon .. self.status.failed .. " "
--        end,
--        hl = function(self)
--            return self.failed_hl
--        end,
--    },
--    {
--        provider = function(self)
--            return "of " .. self.status.tests - 1
--        end,
--    },
--}

-- FileName and Friends

--local Align = { provider = "%=" }
local Align = { provider = "%=", hl = { bg = colors.bg } }
local Space = { provider = " ", hl = { bg = colors.bg } }
local fill = { provider = "%=", hl = { bg = colors.nobg } }
--local LeftSep = { provider = ""  hl = { fg = colors.bg } }
--local RightSep = { provider = "" hl = { fg = colors.bg }}

local FileNameBlock = {
	-- let's first set up some attributes needed by this component and it's children
	init = function(self)
		self.filename = vim.api.nvim_buf_get_name(0)
	end,
	--hl = { fg = utils.get_highlight("Statusline").fg, bold = true, bg = colors.bg },
	hl = { bg = colors.bg },
}
-- We can now define some children separately and add them later
--

local FileIcon = {
	init = function(self)
		local filename = self.filename
		local extension = vim.fn.fnamemodify(filename, ":e")
		self.icon, self.icon_color =
			require("nvim-web-devicons").get_icon_color(filename, extension, { default = true })
	end,
	provider = function(self)
		return self.icon and (self.icon .. " ")
	end,
	hl = function(self)
		--return { fg = self.icon_color }
		return { fg = self.icon_color, bg = colors.bg }
	end,
}

local FileName = {
	provider = function(self)
		-- first, trim the pattern relative to the current directory. For other
		-- options, see :h filename-modifers
		local filename = vim.fn.fnamemodify(self.filename, ":.")
		if filename == "" then
			return "[No Name]"
		end
		-- now, if the filename would occupy more than 1/4th of the available
		-- space, we trim the file path to its initials
		-- See Flexible Components section below for dynamic truncation
		if not conditions.width_percent_below(#filename, 0.25) then
			filename = vim.fn.pathshorten(filename)
		end
		return filename
	end,
	--hl = { fg = utils.get_highlight("Directory").fg, bg = colors.bg },
	hl = { fg = utils.get_highlight("Statusline").fg, bold = true, bg = colors.bg },
}

local FileFlags = {
	{
		provider = function()
			if vim.bo.modified then
				return " [+]"
			end
		end,
		hl = { fg = colors.green, bg = colors.bg },
	},
	{
		provider = function()
			if not vim.bo.modifiable or vim.bo.readonly then
				return ""
			end
		end,
		--hl = { fg = colors.orange },
		hl = { fg = colors.orange, bold = true, bg = colors.bg },
	},
}
-- Now, let's say that we want the filename color to change if the buffer is
-- modified. Of course, we could do that directly using the FileName.hl field,
-- but we'll see how easy it is to alter existing components using a "modifier"
-- component

local FileNameModifer = {
	hl = function()
		if vim.bo.modified then
			-- use `force` because we need to override the child's hl foreground
			--return { fg = "cyan", bold = true, force = true }
			return { fg = "blue", bold = true, force = true, bg = colors.bg }
		end
	end,
}

-- FileType, FileEncoding and FileFormat
local FileType = {
	provider = function()
		--	return string.upper(vim.bo.filetype)
		--end,
		----hl = { fg = utils.get_highlight("Type").fg, bold = true },
		--hl = { fg = utils.get_highlight("Type").fg, bold = true, bg = colors.bg },
		return vim.bo.filetype
	end,
	hl = { fg = utils.get_highlight("Statusline").fg, bold = true, bg = colors.bg },
}

--local FileEncoding = {
--	provider = function()
--		local enc = (vim.bo.fenc ~= "" and vim.bo.fenc) or vim.o.enc -- :h 'enc'
--		return enc ~= "utf-8" and enc:upper()
--	end,
--}
local FileEncoding = {
	Space,
	provider = function()
		local enc = (vim.bo.fenc ~= "" and vim.bo.fenc) or vim.o.enc -- :h 'enc'
		return enc:upper()
	end,
	--hl = { fg = utils.get_highlight("Statusline").fg, bold = true, bg = colors.bg },
	hl = { bg = colors.bg },
}

local FileFormat = {
	provider = function()
		local fmt = vim.bo.fileformat
		return fmt ~= "unix" and fmt:upper()
	end,
	hl = { fg = utils.get_highlight("Statusline").fg, bold = true, bg = colors.bg },
}

-- FileSize and FileLastModified
local FileSize = {
	provider = function()
		-- stackoverflow, compute human readable file size
		local suffix = { "b", "k", "M", "G", "T", "P", "E" }
		local fsize = vim.fn.getfsize(vim.api.nvim_buf_get_name(0))
		fsize = (fsize < 0 and 0) or fsize
		if fsize < 1024 then
			return fsize .. suffix[1]
		end
		local i = math.floor((math.log(fsize) / math.log(1024)))
		return string.format("%.2g%s", fsize / math.pow(1024, i), suffix[i + 1])
	end,
	hl = { fg = utils.get_highlight("Statusline").fg, bold = true, bg = colors.bg },
}

local FileLastModified = {
	-- did you know? Vim is full of functions!
	provider = function()
		local ftime = vim.fn.getftime(vim.api.nvim_buf_get_name(0))
		return (ftime > 0) and os.date("%c", ftime)
	end,
	hl = { fg = utils.get_highlight("Statusline").fg, bold = true, bg = colors.bg },
}

-- Spell
-- Add indicator when spell is set!
local Spell = {
	condition = function()
		return vim.wo.spell
	end,
	provider = "SPELL ",
	hl = { bold = true, fg = "orange" },
}

-- Cursor position: Ruler and ScrollBar
-- We're getting minimalists here!
local Ruler = {
	-- We're getting minimalists here!
	-- %l = current line number
	-- %L = number of lines in the buffer
	-- %c = column number
	-- %P = percentage through file of displayed window
	provider = "%3(%2l%):%c %P",
	--provider = "%7(%l/%3L%):%2c %P",
	--provider = "%3(%P%)",
	--provider = "%7(%l/%3L%):%2c %P",
	--provider = "%7 %p%% Ln %l, Col %c",
	hl = { fg = utils.get_highlight("Statusline").fg, bold = true, bg = colors.bg },
}
--local ScrollBar = {
--	static = {
--		--sbar = { "▁", "▂", "▃", "▄", "▅", "▆", "▇", "█" },
--		sbar = { "🭶", "🭷", "🭸", "🭹", "🭺", "🭻" },
--	},
--	provider = function(self)
--		local curr_line = vim.api.nvim_win_get_cursor(0)[1]
--		local lines = vim.api.nvim_buf_line_count(0)
--		local i = math.floor((curr_line - 1) / lines * #self.sbar) + 1
--		return string.rep(self.sbar[i], 2)
--	end,
--	--hl = { fg = "blue", bg = "bright_bg" },
--	hl = { fg = utils.get_highlight("Statusline").fg, bold = true, bg = colors.bg },
--}
local WordCount = {
	condition = function()
		return conditions.buffer_matches({
			filetype = {
				"markdown",
				"txt",
				"vimwiki",
			},
		})
	end,
	Space,
	{
		provider = function()
			return "W:" .. vim.fn.wordcount().words
		end,
	},
}

local Position = {
	Space,
	{ provider = "%l:%c" },
	hl = { bg = colors.bg },
}

local Percentage = {
	Space,
	{ provider = "%p%%" },
	hl = { bg = colors.bg },
}
-- Working Directory
local WorkDir = {
	provider = function(self)
		self.icon = (vim.fn.haslocaldir(0) == 1 and "l" or "g") .. " " .. " "
		local cwd = vim.fn.getcwd(0)
		self.cwd = vim.fn.fnamemodify(cwd, ":~")
	end,
	--hl = { fg = "blue", bold = true },
	hl = { fg = colors.blue, bold = true, bg = colors.bg },

	utils.make_flexible_component(1, {
		-- evaluates to the full-lenth path
		provider = function(self)
			local trail = self.cwd:sub(-1) == "/" and "" or "/"
			return self.icon .. self.cwd .. trail .. " "
		end,
	}, {
		-- evaluates to the shortened path
		provider = function(self)
			local cwd = vim.fn.pathshorten(self.cwd)
			local trail = self.cwd:sub(-1) == "/" and "" or "/"
			return self.icon .. cwd .. trail .. " "
		end,
	}, {
		-- evaluates to "", hiding the component
		provider = "",
	}),
}

-- Terminal Name
-- Special handling of the built-in terminal bufname. See conditional statuslines below to see an example of dedicated statusline for terminals!

local TerminalName = {
	-- we could add a condition to check that buftype == 'terminal'
	-- or we could do that later (see #conditional-statuslines below)
	provider = function()
		local tname, _ = vim.api.nvim_buf_get_name(0):gsub(".*:", "")
		return " " .. tname
	end,
	--hl = { fg = "blue", bold = true },
	hl = { bold = true, bg = colors.bg },
}

-- Snippets Indicator
-- This requires ultisnips
--local Snippets = {
--    -- check that we are in insert or select mode
--    condition = function()
--        return vim.tbl_contains({'s', 'i'}, vim.fn.mode())
--    end,
--    provider = function()
--        local forward = (vim.fn["UltiSnips#CanJumpForwards"]() == 1) and "" or ""
--        local backward = (vim.fn["UltiSnips#CanJumpBackwards"]() == 1) and " " or ""
--        return backward .. forward
--    end,
--    hl = { fg = "red", bold = true },
--}

-- let's add the children to our FileNameBlock component
--FileNameBlock = utils.insert(
--	FileNameBlock,
--FileEncoding,
--Space,
--FileIcon,
--FileType,
--FileLastModified,
--FileSize,
--FileFormat,
--FileNameModifer,
--	unpack(FileFlags),
--	{ provider = "%<" } -- this means that the statusline is cut here when there's not enough space
--)
-- let's add the children to our FileNameBlock component
FileNameBlock = utils.insert(
	FileNameBlock,
	FileIcon,
	utils.insert(FileNameModifer, FileName), -- a new table where FileName is a child of FileNameModifier
	unpack(FileFlags), -- A small optimisation, since their parent does nothing
	{ provider = "%<" } -- this means that the statusline is cut here when there's not enough space
)

local FileInfoBlock = {
	-- let's first set up some attributes needed by this component and it's children
	init = function(self)
		self.filename = vim.api.nvim_buf_get_name(0)
	end,
}

FileInfoBlock = utils.insert(
	FileInfoBlock,
	FileEncoding,
	Space,
	FileIcon,
	FileType,
	{ provider = "%<" } -- this means that the statusline is cut here when there's not enough space
)
--FileNameBlock = utils.insert(
--	FileNameBlock,
--	FileIcon,
--	utils.insert(FileNameModifer, FileName), -- a new table where FileName is a child of FileNameModifier
--	unpack(FileFlags), -- A small optimisation, since their parent does nothing
--	{ provider = "%<" } -- this means that the statusline is cut here when there's not enough space
--)

-- Statusline

local Surrr = {
	utils.surround({ "", "" }, "red", {
		utils.surround({ "", "" }, "green", utils.surround({ "", "" }, "blue", { provider = "heyya" })),
		{ provider = "Normal" },
	}),
}
--ViMode = utils.surround({ "", "" }, "bright_bg", { ViMode, Snippets })
ViMode = utils.surround({ "", "" }, function(self)
	return self:mode_color()
end, { ViMode, hl = { fg = utils.get_highlight("statusline").bg, force = true } })

--ViMode = utils.surround({ "◥", "" }, function(self) return self:mode_color() end, {
--  utils.surround({ "█", "" }, function(self) return self:mode_color() end, utils.surround({ "", "" }, function(self) return self:mode_color() end, { {provider = "normal" }, ViMode, hl = { fg = utils.get_highlight("statusline").bg, force = true } } )),
--  { provider = "heyya" },
--  })

--utils.surround({ "█", "█" }, function(self) return self:mode_color() end, { FileNameBlock, hl = { fg = colors.bg, force = true } } ),
local DefaultStatusline = {
	ViMode,
	Space,
	FileNameBlock,
	Space,
	Git,
	Space,
	Diagnostics,
	Align,
	Navic,
	DAPMessages,
	Align,
	Space,
	FileInfoBlock,
	Space,
	WordCount,
	Ruler,
	Space,
	--Position,
	--Percentage,
	--ScrollBar,
	--Space,
	--LSPActive, Space, LSPMessages, Space, UltTest, Space, FileType, Space, Ruler, Space, ScrollBar
}

--local InactiveStatusline = {
--	condition = conditions.is_not_active,
--	FileType,
--	Space,
--	FileName,
--	Align,
--}

local SpecialStatusline = {
	condition = function()
		return conditions.buffer_matches({
			buftype = { "nofile", "prompt", "help", "quickfix" },
			filetype = { "^git.*", "fugitive" },
		})
	end,

	FileType,
	Space,
	Align,
	--FileType, Space, HelpFileName, Align
}

local TerminalStatusline = {

	condition = function()
		return conditions.buffer_matches({ buftype = { "terminal" } })
	end,

	hl = { bg = "dark_red" },

	-- Quickly add a condition to the ViMode to only show it when buffer is active!
	{ condition = conditions.is_active, ViMode, Space },
	FileType,
	Space,
	TerminalName,
	Align,
}

--local StatusLines = {
--
--	hl = function()
--		if conditions.is_active() then
--			return "StatusLine"
--		else
--			return "StatusLineNC"
--		end
--	end,
--
--	-- the first statusline with no condition, or which condition returns true is used.
--	-- think of it as a switch case with breaks to stop fallthrough.
--	fallthrough = false,
--
--	SpecialStatusline,
--	TerminalStatusline,
--	--InactiveStatusline,
--	DefaultStatusline,
--}
local StatusLines = {

	hl = function()
		if conditions.is_active() then
			return "StatusLine"
		else
			return "StatusLineNC"
		end
	end,

	static = {
		mode_colors_map = {
			n = colors.blue,
			i = colors.green,
			v = colors.purple,
			V = colors.purple,
			[""] = colors.purple,
			c = colors.red,
			s = colors.purple,
			S = colors.purple,
			[""] = colors.purple,
			R = colors.orange,
			r = colors.orange,
			["!"] = colors.red,
			t = colors.red,
		},
		mode_color = function(self)
			local mode = conditions.is_active() and vim.fn.mode() or "n"
			return self.mode_colors_map[mode]
		end,
	},
	fallthrough = false,

	SpecialStatusline,
	TerminalStatusline,
	--InactiveStatusline,
	DefaultStatusline,
}
--hl = { fg = utils.get_highlight("Statusline").fg, bold = true, bg = colors.bg },
--	hl = { bg = colors.bg },
--require("heirline").setup(StatusLines)
-- we're done.

--local FelineStyle = {
--
--    -- stop at child where buftype/filetype/bufname matches
--    fallthrough = false,
--
--    {   -- Identify the buftype/filetype/bufname first
--        condtion = function()
--            return conditions.buffer_matches({...})
--        end,
--
--        -- Evaluate only the "active" or "inactive" child
--        fallthrough = false,
--
--        {   -- If it's the current window, display some components
--            condition = conditions.is_active
--            {...} --
--        },
--        {   -- Otherwise, display some other components
--            {...} --
--        }
--    },
--    {   -- this block can be exactly as the one above for a different kind of
--        -- buffer
--        ...
--    }
--}

-- WinBar

vim.api.nvim_create_autocmd("User", {
	pattern = "HeirlineInitWinbar",
	callback = function(args)
		local buf = args.buf
		local buftype = vim.tbl_contains({ "prompt", "nofile", "help", "quickfix" }, vim.bo[buf].buftype)
		local filetype = vim.tbl_contains({ "gitcommit", "fugitive" }, vim.bo[buf].filetype)
		if buftype or filetype then
			vim.opt_local.winbar = nil
		end
	end,
})
local active_middle_segment = { --{{{
	--	provider = "%999X  %X",

	--provider = function(self)
	--	--return " %999X  %999X "
	--	return " %2("..self.mode_names[self.mode].."%)"
	--	--
	--	--
	--	--
	--end,
	fallthrough = false,
	{ -- Hide the winbar for special buffers
		condition = function()
			return conditions.buffer_matches({
				buftype = { "nofile", "prompt", "help", "quickfix" },
				filetype = { "^git.*", "fugitive" },
			})
		end,
		init = function()
			vim.opt_local.winbar = nil
		end,
	},
	static = {
		mode_colors_map = {
			n = colors.blue,
			i = colors.green,
			v = colors.purple,
			V = colors.purple,
			[""] = colors.purple,
			c = colors.red,
			s = colors.purple,
			S = colors.purple,
			[""] = colors.purple,
			R = colors.orange,
			r = colors.orange,
			["!"] = colors.red,
			t = colors.red,
		},
		mode_color = function(self)
			local mode = conditions.is_active() and vim.fn.mode() or "n"
			return self.mode_colors_map[mode]
		end,
		provider = "%f",
		hl = function(self)
			local color = self:mode_color() -- here!
			return { fg = color }
		end,
		-- self.filename will be defined later, just keep looking at the example!
	},
	{ -- A special winbar for terminals
		condition = function()
			return conditions.buffer_matches({ buftype = { "terminal" } })
		end,
		utils.surround({ "", "" }, "dark_red", {
			FileType,
			Space,
			TerminalName,
		}),
	},
	{ -- An inactive winbar for regular files
		condition = function()
			return not conditions.is_active()
		end,
		--utils.surround({ "", "" }, "bright_bg", { hl = { fg = "gray", force = true }, FileNameBlock }),
		--utils.surround({ "", "" }, function(self) return self:mode_color() end, { FileNameBlock, hl = { fg = colors.bg, force = true } } ),
	},
	-- A winbar for regular files
	--utils.surround({ "", "" }, "bright_bg", FileNameBlock),
	--█🙼🙽🙼█⮘██⮚
	--utils.surround({ "", "" }, function(self) return self:mode_color() end, { FileNameBlock, hl = function(self)
	--    local color = self:mode_color() -- here!
	--    return { bg = color, bold = true, force = true }
	--end,
	--}),
	--utils.surround({ "", "" }, function(self) return self:mode_color() end, FileNameBlock),
}

--utils.surround({ "", "" }, function(self) return self:mode_color() end, { active_middle_segment, hl = { fg = colors.bg, force = true } })

local WinBars = {
	fill,
	active_middle_segment,
	fill,
}
--	--utils.surround({ " ", " " }, colors.nobg, { fill, active_middle_segment, fill })
--	--static = {
--	--    mode_colors_map = {
--	--	      n = colors.blue,
--	--	      i = colors.green,
--	--	      v = colors.purple,
--	--	      V = colors.purple,
--	--	      [""] = colors.purple,
--	--	      c = colors.red,
--	--	      s = colors.purple,
--	--	      S = colors.purple,
--	--	      [""] = colors.purple,
--	--	      R = colors.orange,
--	--	      r = colors.orange,
--	--	      ["!"] = colors.red,
--	--	      t = colors.red,
--	--    },
--	--    mode_color = function(self)
--	--        local mode = conditions.is_active() and vim.fn.mode() or "n"
--	--        return self.mode_colors_map[mode]
--	--    end,
--	--},
--	--utils.surround({ " ", " " }, colors.nobg, { active_middle_segment, hl = function(self)
--	--    local color = self:mode_color() -- here!
--	--    return { bg = color, bold = true, force = true }
--	--end,
--	--})
--}
on_click = {
	-- get the window id of the window in which the component was evaluated
	minwid = function()
		return vim.api.nvim_get_current_win()
	end,
	callback = function(_, minwid)
		-- winid is the window id of the window the component was clicked from
		local winid = minwid
		-- do something with the window id, e.g.:
		local buf = vim.api.nvim_win_get_buf(winid)
		-- ...
	end,
}

local CloseButton = {
	condition = function(self)
		return not vim.bo.modified
	end,
	-- a small performance improvement:
	-- re register the component callback only on layout/buffer changes.
	update = { "WinNew", "WinClosed", "BufEnter" },
	{ provider = " " },
	{
		provider = "",
		hl = { fg = "gray" },
		on_click = {
			minwid = function()
				return vim.api.nvim_get_current_win()
			end,
			callback = function(_, minwid)
				vim.api.nvim_win_close(minwid, true)
			end,
			name = "heirline_winbar_close_button",
		},
	},
}

-- Use it anywhere!
--local WinBarFileName = utils.surround({ "", "" }, "bright_bg", {
--	hl = function()
--		if not conditions.is_active() then
--			return { fg = "gray", force = true }
--		end
--	end,
--	FileNameBlock,
--	Space,
--	CloseButton,
--})

--local WinBars = {
--	-- init = utils.pick_child_on_condition,
--	fallthrough = false,
--	{
--		condition = function()
--			return conditions.buffer_matches({
--				buftype = { "nofile", "prompt", "help", "quickfix" },
--				filetype = { "^git.*", "fugitive" },
--			})
--		end,
--		init = function()
--			vim.opt_local.winbar = nil
--		end,
--	},
--	{
--		condition = function()
--			return conditions.buffer_matches({ buftype = { "terminal" } })
--		end,
--		utils.surround({ "", "" }, "dark_red", {
--			FileType,
--			Space,
--			TerminalName,
--			CloseButton,
--		}),
--	},
--	utils.surround({ "", "" }, "bright_bg", {
--		hl = function()
--			if conditions.is_not_active() then
--				return { fg = "gray", force = true }
--			end
--		end,
--
--		FileNameBlock,
--		CloseButton,
--	}),
--}

-- TabLine
--local TabLine ={
--    hl = { bg = colors.bg },
--}
local TablineBufnr = {
	provider = function(self)
		return tostring(self.bufnr) .. ". "
	end,
	--hl = "Comment",
	--hl = { fg = utils.get_highlight("Statusline").fg, bold = true, bg = colors.bg },
	hl = { fg = utils.get_highlight("Statusline").fg, bold = true },
}

-- we redefine the filename component, as we probably only want the tail and not the relative path
local TablineFileName = {
	provider = function(self)
		-- self.filename will be defined later, just keep looking at the example!
		local filename = self.filename
		filename = filename == "" and "[No Name]" or vim.fn.fnamemodify(filename, ":t")
		return filename
	end,
	hl = function(self)
		return { bold = self.is_active or self.is_visible, italic = true }
	end,
}

-- this looks exactly like the FileFlags component that we saw in
-- #crash-course-part-ii-filename-and-friends, but we are indexing the bufnr explicitly
-- also, we are adding a nice icon for terminal buffers.
--local TablineFileFlags = {
--	{
--		condition = function(self)
--			return vim.api.nvim_buf_get_option(self.bufnr, "modified")
--		end,
--		provider = "[+]",
--		--hl = { fg = colors.green },
--		hl = { fg = colors.green, bold = true, bg = colors.bg },
--	},
--	{
--		condition = function(self)
--			return not vim.api.nvim_buf_get_option(self.bufnr, "modifiable")
--				or vim.api.nvim_buf_get_option(self.bufnr, "readonly")
--		end,
--		provider = function(self)
--			if vim.api.nvim_buf_get_option(self.bufnr, "buftype") == "terminal" then
--				return "  "
--			else
--				return ""
--			end
--		end,
--		hl = { fg = "orange", bg = colors.bg },
--	},
--}

local TablineFileFlags = {
	{
		provider = function(self)
			if vim.bo[self.bufnr].modified then
				return " [+]"
			end
		end,
		hl = { fg = colors.green },
	},
	{
		provider = function(self)
			if not vim.bo[self.bufnr].modifiable or vim.bo[self.bufnr].readonly then
				return ""
			end
		end,
		hl = { fg = "orange" },
	},
}

local TablineFileIcon = {
	init = function(self)
		local filename = self.filename
		local extension = vim.fn.fnamemodify(filename, ":e")
		self.icon, self.icon_color =
			require("nvim-web-devicons").get_icon_color(filename, extension, { default = true })
	end,
	provider = function(self)
		return self.icon and (" " .. self.icon .. " ")
	end,
	hl = function(self)
		return { fg = self.icon_color }
	end,
}

-- Here the filename block finally comes together
local TablineFileNameBlock = {
	init = function(self)
		self.filename = vim.api.nvim_buf_get_name(self.bufnr)
	end,
	hl = function(self)
		if self.is_active then
			return "TabLineSel"
		-- why not?
		--elseif not vim.api.nvim_buf_is_loaded(self.bufnr) then
		--return { fg = "gray", bg = colors.bg }
		else
			return "TabLine"
		end
	end,
	on_click = {
		callback = function(_, minwid, _, button)
			if button == "m" then -- close on mouse middle click
				vim.api.nvim_buf_delete(minwid, { force = false })
			else
				vim.api.nvim_win_set_buf(0, minwid)
			end
		end,
		minwid = function(self)
			return self.bufnr
		end,
		name = "heirline_tabline_buffer_callback",
	},
	TablineBufnr,
	--FileIcon, -- turns out the version defined in #crash-course-part-ii-filename-and-friends can be reutilized as is here!
	TablineFileIcon,
	TablineFileName,
	TablineFileFlags,
}

-- a nice "x" button to close the buffer
local TablineCloseButton = {
	condition = function(self)
		return not vim.api.nvim_buf_get_option(self.bufnr, "modified")
	end,
	{ provider = " " },
	{
		provider = " ",
		--hl = { fg = "red", bg = colors.bg },
		hl = { fg = "red" },
		on_click = {
			callback = function(_, minwid)
				vim.api.nvim_buf_delete(minwid, { force = false })
			end,
			minwid = function(self)
				return self.bufnr
			end,
			name = "heirline_tabline_close_buffer_callback",
		},
	},
}

-- The final touch!
--local TablineBufferBlock = utils.surround({ "", "", hl = { bg =colors.bg } }, function(self)
--	if self.is_active then
--		return utils.get_highlight("TabLineSel").fg, utils.get_highlight("TabLineSel").bg
--	else
--		return utils.get_highlight("TabLine").fg, utils.get_highlight("TabLine").bg
--	end
----end, { TabLine, TablineFileNameBlock, TablineCloseButton })
--end, { TablineFileNameBlock, TablineCloseButton })

--local TablineBufferBlock = utils.surround({ "█", "█" }, "bg", {
--	hl = function()
--		if not conditions.is_active() then
--			return { fg = "gray", force = true, bg = colors.bg }
--		end
--	end,
--	TablineFileNameBlock,
--	TablineCloseButton,
--})
--local TablineBufferBlock = utils.surround({ "█", "█" },
--  { hl = function(self)
--		local mode = self.mode:sub(1, 1) -- get only the first mode character
--		--return { fg = self.mode_colors[mode], bold = true, }
--		return { bg = self.mode_colors[mode], fg = colors.bg, bold = true }
--	end, },
--{ TablineFileNameBlock, TablineCloseButton, { hl = ViMode }, })

--local TablineBufferBlock = {
--	init = function(self)
--
--		self.mode = vim.fn.mode(1) -- :h mode()
--
--			vim.api.nvim_create_autocmd("ModeChanged", {
--				pattern = "*:*o",
--				command = "redrawstatus",
--			})
--			self.once = true
--		end,
--	static = {
--		mode_colors = {
--			n = colors.blue,
--			i = colors.green,
--			v = colors.purple,
--			V = colors.purple,
--			[""] = colors.purple,
--			c = colors.red,
--			s = colors.purple,
--			S = colors.purple,
--			[""] = colors.purple,
--			R = colors.orange,
--			r = colors.orange,
--			["!"] = colors.red,
--			t = colors.red,
--		},
--  },
--	hl = function(self)
--  if self.is_active then
--		local mode = self.mode:sub(1, 1) -- get only the first mode character
--		--return { fg = self.mode_colors[mode], bold = true, }
--		return { bg = self.mode_colors[mode], fg = colors.bg, bold = true }
--  else
--		return utils.get_highlight("TabLine").bg
--	end
--  end,
--	update = {
--		"ModeChanged",
--	}, --optional
--  { TablineFileNameBlock, TablineCloseButton }
--}

--local TabLineSel = {
--  hl = { bg = self.mode_colors[mode], fg = colors.bg, bold = true }
--}
--local ViMode2 = {
--	init = function(self)
--        self.mode = vim.fn.mode()
--    end,
--    static = {
--        mode_colors = {
--            n = "red",
--            i = "green",
--            v = "blue",
--            c = "orange"
--
--        }
--    },
--    provider = function(self)
--        return string.upper(self.mode)
--    end,
--    hl = function(self)
--        return { fg = self.mode_colors[self.mode], bold = true, }
--    end
--}
--local surrr = {
--    utils.surround({ "", "" }, "red", {
--        utils.surround({ "", "" }, "green", utils.surround({ "", "" }, "blue", { provider = "heyya" })),
--        { provider = "Normal" },
--    }),
--}
--local statusline = ViMode

--local TablineBufferBlock = utils.surround({ "", "" }, function(self)
--	if self.is_active then
--		--self.mode = vim.fn.mode(1) -- :h mode()
--
--    --return utils.get_highlight(vim.api.nvim_get_mode().mode).bg
--		return utils.get_highlight("TabLineSel").bg
--		--return utils.get_highlight("Normal").bg
--		--local mode = self.mode:sub(1, 1) -- get only the first mode character
--    --return { bg = TabLineSel, fg = colors.bg, bold = true }
--	else
--		return utils.get_highlight("TabLine").bg
--	end
--end, { TablineFileNameBlock, TablineCloseButton })

local TablineBufferBlock = utils.surround({ "█", "▎" }, function(self)
	--local TablineBufferBlock = utils.surround({ "█", "█" }, function(self)
	if self.is_active then
		return utils.get_highlight("TabLineSel").bg
	else
		return utils.get_highlight("TabLine").bg
	end
end, { TablineFileNameBlock, TablineCloseButton })
--█
--local TablineBufferBlock = {
--	init = function(self)
--		self.mode = vim.fn.mode()
--	end,
--	static = {
--		mode_colors = {
--			n = colors.blue,
--			i = colors.green,
--			v = colors.purple,
--			V = colors.purple,
--			[""] = colors.purple,
--			c = colors.red,
--			s = colors.purple,
--			S = colors.purple,
--			[""] = colors.purple,
--			R = colors.orange,
--			r = colors.orange,
--			["!"] = colors.red,
--			t = colors.red,
--		},
--	},
--	hl = function(self)
--		if conditions.is_active() then
--			return { bg = self.mode_colors[self.mode], fg = colors.bg, bold = true }
--		else
--			return utils.get_highlight("Tabline").bg
--		end
--	end,
--	update = {
--		"ModeChanged",
--	}, --optional
--	{ TablineFileNameBlock, TablineCloseButton },
--}

--local TablineBufferBlock = {
--    static = {
--        mode_colors_map = {
--			      n = colors.blue,
--			      i = colors.green,
--			      v = colors.purple,
--			      V = colors.purple,
--			      [""] = colors.purple,
--			      c = colors.red,
--			      s = colors.purple,
--			      S = colors.purple,
--			      [""] = colors.purple,
--			      R = colors.orange,
--			      r = colors.orange,
--			      ["!"] = colors.red,
--			      t = colors.red,
--        },
--        mode_color = function(self)
--            local mode = conditions.is_active() and vim.fn.mode() or "n"
--            return self.mode_colors_map[mode]
--        end,
--    },
--	{ -- A special winbar for terminals
--		condition = function()
--			return conditions.buffer_matches({ buftype = { "terminal" } })
--		end,
--		utils.surround({ "", "" }, "dark_red", {
--			FileType,
--			Space,
--			TerminalName,
--		}),
--	},
--	{ -- An inactive winbar for regular files
--		condition = function()
--			return conditions.is_not_active()
--    end,
--  utils.surround({ "█", "█" }, function() return utils.get_highlight("TabLine").bg end, { TablineFileNameBlock, TablineCloseButton } )
--  },
--  {
--		condition = function()
--			return conditions.is_active()
--    end,
--  utils.surround({ "█", "█" }, function(self) return self:mode_color() end, { TablineFileNameBlock, TablineCloseButton, hl = { fg = colors.bg, force = true } } )
--  },
--function()
--if self.is_active then
--utils.surround({ "", "" }, "bright_bg", { hl = { fg = "gray", force = true }, FileNameBlock }),
--utils.surround({ "", "" }, function(self) return self:mode_color() end, { FileNameBlock, hl = { fg = colors.bg, force = true } } ),
--utils.surround({ "█", "█" }, function() return utils.get_highlight("TabLine").bg end, { TablineFileNameBlock, TablineCloseButton, hl = { fg = colors.bg, force = true } } ),
--}
--ViMode = utils.surround({ "", "" }, function(self)
--    if self.is_active then
--      return self:mode_color()
--    else
--      return utils.get_highlight("TabLine").bg
--    end
--    end, { ViMode, hl = { fg = utils.get_highlight("statusline").bg, force = true } } )
--
----}
--local TablineBufferBlock = {
--  ViMode,
--  TablineFileName,
--  TablineCloseButton,
--}
-- A winbar for regular files
--utils.surround({ "", "" }, "bright_bg", FileNameBlock),
--utils.surround({ "", "" }, function(self) return self:mode_color() end, FileNameBlock),
local BufferLine = utils.make_buflist(
	TablineBufferBlock,
	{ provider = "", hl = { fg = "gray" } }, -- left truncation, optional (defaults to "<")
	{ provider = "", hl = { fg = "gray" } } -- right trunctation, also optional (defaults to ...... yep, ">")
	--{ provider = "", hl = { fg = "gray" } }, -- left truncation, optional (defaults to "<")
	--{ provider = "", hl = { fg = "gray" } } -- right trunctation, also optional (defaults to ...... yep, ">")
	-- by the way, open a lot of buffers and try clicking them ;)
)

--	if self.is_active then
--		return utils.get_highlight("TabLineSel").bg
--	else
--		return utils.get_highlight("TabLine").bg
--	end
--end, { TablineFileNameBlock, TablineCloseButton, } )
-- TabList
local Tabpage = {
	provider = function(self)
		return "%" .. self.tabnr .. "T " .. self.tabnr .. " %T"
	end,
	hl = function(self)
		if not self.is_active then
			return "TabLine"
		else
			return "TabLineSel"
		end
	end,
}

local TabpageClose = {
	provider = "%999X  %X",
	--hl = "TabLine",
	hl = { fg = colors.red, bg = colors.bg },
}

local TabPages = {
	-- only show this component if there's 2 or more tabpages
	condition = function()
		return #vim.api.nvim_list_tabpages() >= 2
	end,
	{ provider = "%=" },
	utils.make_tablist(Tabpage),
	TabpageClose,
}

-- TabLineOffset
local TabLineOffset = {
	condition = function(self)
		local win = vim.api.nvim_tabpage_list_wins(0)[1]
		local bufnr = vim.api.nvim_win_get_buf(win)
		self.winid = win

		if vim.bo[bufnr].filetype == "NvimTree" then
			self.title = "NvimTree"
			return true
			-- elseif vim.bo[bufnr].filetype == "TagBar" then
			--     ...
		end
	end,

	provider = function(self)
		local title = self.title
		local width = vim.api.nvim_win_get_width(self.winid)
		local pad = math.ceil((width - #title) / 2)
		return string.rep(" ", pad) .. title .. string.rep(" ", pad)
	end,

	hl = function(self)
		if vim.api.nvim_get_current_win() == self.winid then
			return "TablineSel"
		else
			return "Tabline"
		end
	end,
}

local TabLine = {
	--hl = { bg = colors.bg },
	fallthrough = false,
	TabLineOffset,
	BufferLine,
	TabPages,
}

vim.cmd([[au FileType * if index(['wipe', 'delete', 'unload'], &bufhidden) >= 0 | set nobuflisted | endif]])
--local StatusLines = {
--
--	hl = function()
--		if conditions.is_active() then
--			return "StatusLine"
--		else
--			return "StatusLineNC"
--		end
--	end,
--
--	-- the first statusline with no condition, or which condition returns true is used.
--	-- think of it as a switch case with breaks to stop fallthrough.
--	fallthrough = false,
--
--	SpecialStatusline,
--	TerminalStatusline,
--	--InactiveStatusline,
--	DefaultStatusline,
--}
--
--	--hl = { fg = utils.get_highlight("Statusline").fg, bold = true, bg = colors.bg },
--	hl = { bg = colors.bg },
--local TabLine ={
--    hl = { bg = colors.bg },
--}
-- Window Close button: Let the callback know from which window it was clicked from!
-- The following is the recommended way of achieving that:
require("heirline").setup(StatusLines, WinBars, TabLine)

-- Yep, with heirline we're driving manual!
vim.cmd([[au FileType * if index(['wipe', 'delete', 'unload'], &bufhidden) >= 0 | set nobuflisted | endif]])

vim.api.nvim_create_augroup("Heirline", { clear = true })
vim.api.nvim_create_autocmd("ColorScheme", {
	callback = function()
		local colors = setup_colors()
		utils.on_colorscheme(colors)
	end,
	group = "Heirline",
})

local function get_bufs()
	return vim.tbl_filter(function(bufnr)
		return vim.api.nvim_buf_is_loaded(bufnr) and vim.bo[bufnr].buflisted
	end, vim.api.nvim_list_bufs())
end

local function goto_buf(index)
	local bufs = get_bufs()
	if index > #bufs then
		index = #bufs
	end
	vim.api.nvim_win_set_buf(0, bufs[index])
end

local function addKey(key, index)
	vim.keymap.set("", "<A-" .. key .. ">", function()
		goto_buf(index)
	end, { noremap = true, silent = true })
end

for i = 1, 9 do
	addKey(i, i)
end
addKey("0", 10)
-- Theming
--local function setup_colors()
--    return {
--        bright_bg = utils.get_highlight("Folded").bg,
--        bright_fg = utils.get_highlight("Folded").fg,
--        red = utils.get_highlight("DiagnosticError").fg,
--        dark_red = utils.get_highlight("DiffDelete").bg,
--        green = utils.get_highlight("String").fg,
--        blue = utils.get_highlight("Function").fg,
--        gray = utils.get_highlight("NonText").fg,
--        orange = utils.get_highlight("Constant").fg,
--        purple = utils.get_highlight("Statement").fg,
--        cyan = utils.get_highlight("Special").fg,
--        diag_warn = utils.get_highlight("DiagnosticWarn").fg,
--        diag_error = utils.get_highlight("DiagnosticError").fg,
--        diag_hint = utils.get_highlight("DiagnosticHint").fg,
--        diag_info = utils.get_highlight("DiagnosticInfo").fg,
--        git_del = utils.get_highlight("diffDeleted").fg,
--        git_add = utils.get_highlight("diffAdded").fg,
--        git_change = utils.get_highlight("diffChanged").fg,
--    }
--end
--require('heirline').load_colors(setup_colors())
--
--vim.api.nvim_create_augroup("Heirline", { clear = true })
--vim.api.nvim_create_autocmd("ColorScheme", {
--    callback = function()
--        local colors = setup_colors()
--        utils.on_colorscheme(colors)
--    end,
--    group = "Heirline",
--})
