--local M = {}
--M.theme = function()
--  -- I know I could just set bg = nil but I'm leaving this here in case I want custom colors in the future
--  local colors = {
--    nobg = nil,
--    blue = "#87b0f9",
--    mauve = "#cba6f7",
--    red = "#f38ba8",
--    green = "#a6e3a1",
--    peach = "#fab387",
--    white = "#c6d0f5",
--    gray = "#a1a8c9",
--    black = "#1e1e2e",
--  }
--  return {
--    inactive = {
--      a = { fg = colors.blue, bg = colors.nobg, gui = "bold" },
--      b = { fg = colors.white, bg = colors.black },
--      c = { fg = colors.gray, bg = colors.nobg },
--    },
--    visual = {
--      a = { fg = colors.black, bg = colors.mauve, gui = "bold" },
--      b = { fg = colors.mauve, bg = colors.nobg },
--      c = { fg = colors.white, bg = colors.nobg },
--    },
--    replace = {
--      a = { fg = colors.black, bg = colors.red, gui = "bold" },
--      b = { fg = colors.red, bg = colors.nobg },
--      c = { fg = colors.white, bg = colors.nobg },
--    },
--    normal = {
--      a = { fg = colors.black, bg = colors.blue, gui = "bold" },
--      b = { fg = colors.black, bg = colors.green },
--      c = { fg = colors.white, bg = colors.black },
--    },
--    insert = {
--      a = { fg = colors.black, bg = colors.green, gui = "bold" },
--      b = { fg = colors.teal, bg = colors.nobg },
--      c = { fg = colors.white, bg = colors.nobg },
--    },
--    command = {
--      a = { fg = colors.black, bg = colors.peach, gui = "bold" },
--      b = { fg = colors.peach, bg = colors.nobg },
--      c = { fg = colors.white, bg = colors.nobg },
--    },
--    modified = {
--      a = { fg = colors.black, bg = colors.peach, gui = "bold" },
--      b = { fg = colors.peach, bg = colors.peach },
--      c = { fg = colors.white, bg = colors.peach },
--    },
--  }
--end
--return M
local M = {}
M.theme = function()
	--local colors = {
	--	darkgray = "#16161d",
	--	gray = "#727169",
	--	innerbg = nil,
	--	outerbg = "#16161D",
	--	normal = "#7e9cd8",
	--	insert = "#98bb6c",
	--	visual = "#ffa066",
	--	replace = "#e46876",
	--	command = "#e6c384",
	--}
	local colors = {
		darkgray = "#16161d",
		gray = "#727169",
		innerbg = nil,
		outerbg = "#16161D",
		normal = "#39BAE6",
		insert = "#AAD94C",
		visual = "#FA8D3F",
		replace = "#F07171",
		command = "#F2AE49",
	}
	return {
		inactive = {
			a = { fg = colors.gray, bg = colors.outerbg, gui = "bold" },
			b = { fg = colors.gray, bg = colors.outerbg },
			c = { fg = colors.gray, bg = colors.innerbg },
		},
		visual = {
			a = { fg = colors.darkgray, bg = colors.visual, gui = "bold" },
			b = { fg = colors.gray, bg = colors.outerbg },
			c = { fg = colors.gray, bg = colors.innerbg },
		},
		replace = {
			a = { fg = colors.darkgray, bg = colors.replace, gui = "bold" },
			b = { fg = colors.gray, bg = colors.outerbg },
			c = { fg = colors.gray, bg = colors.innerbg },
		},
		normal = {
			a = { fg = colors.darkgray, bg = colors.normal, gui = "bold" },
			b = { fg = colors.gray, bg = colors.outerbg },
			c = { fg = colors.gray, bg = colors.innerbg },
			y = { fg = colors.gray, bg = colors.outerbg },
		},
		insert = {
			a = { fg = colors.darkgray, bg = colors.insert, gui = "bold" },
			b = { fg = colors.gray, bg = colors.outerbg },
			c = { fg = colors.gray, bg = colors.innerbg },
		},
		command = {
			a = { fg = colors.darkgray, bg = colors.command, gui = "bold" },
			b = { fg = colors.gray, bg = colors.outerbg },
			c = { fg = colors.gray, bg = colors.innerbg },
		},
	}
end
return M
