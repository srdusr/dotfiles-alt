-- Colorscheme
-- Available colorschemes:
-- [[ nightfly ayu onedark doom-one ]]
local colorscheme = "doom-one"
local status_ok, _ = pcall(vim.cmd, "colorscheme " .. colorscheme)
if not status_ok then
	vim.notify("colorscheme " .. colorscheme .. " not found!")
	return
end

vim.api.nvim_command("syntax on")
vim.api.nvim_command("highlight Normal guibg=none")
vim.api.nvim_command("highlight SignColumn guibg=none")
vim.api.nvim_command("highlight TabLine guibg=#333842 gui=bold")
vim.api.nvim_command("highlight Title guibg=none gui=bold")
vim.api.nvim_command("highlight TabLineSel guibg=#333842 gui=bold")
vim.api.nvim_command("highlight TabLineFill guibg=none gui=bold")
vim.api.nvim_command("highlight WinBar guibg=none gui=bold")
vim.api.nvim_command("highlight NormalFloat guibg=none")
--vim.api.nvim_command("highlight TabLineSel guibg=none guifg=none gui=bold")
--vim.api.nvim_command("highlight TabLineNC guibg=none gui=bold")
--vim.api.nvim_command("highlight StatusLine guibg=#333842 gui=bold")
--vim.api.nvim_command("highlight StatusLineNC guibg=none ctermfg=Cyan guifg=#80a0ff gui=bold")
--vim.api.nvim_command("highlight WinSeparator guibg=none gui=bold")
--vim.api.nvim_command("highlight MsgSeparator guibg=none")
--vim.api.nvim_command("highlight PmenuSel guibg=none")
--vim.api.nvim_command("highlight winblend guibg=none")

-- Set different window separator colorscheme
vim.cmd[[
au WinEnter * setl winhl=WinSeparator:WinSeparatorA
au WinLeave * setl winhl=WinSeparator:WinSeparator
]]

require("notify").setup({
	background_colour = "#000000",
})

-- Custom colorscheme
--vim.cmd([[
-- let g:terminal_color_0  = '#2e3436'
-- let g:terminal_color_1  = '#cc0000'
-- let g:terminal_color_2  = '#4e9a06'
-- let g:terminal_color_3  = '#c4a000'
-- let g:terminal_color_4  = '#3465a4'
-- let g:terminal_color_5  = '#75507b'
-- let g:terminal_color_6  = '#0b939b'
-- let g:terminal_color_7  = '#d3d7cf'
-- let g:terminal_color_8  = '#555753'
-- let g:terminal_color_9  = '#ef2929'
-- let g:terminal_color_10 = '#8ae234'
-- let g:terminal_color_11 = '#fce94f'
-- let g:terminal_color_12 = '#729fcf'
-- let g:terminal_color_13 = '#ad7fa8'
-- let g:terminal_color_14 = '#00f5e9'
-- let g:terminal_color_15 = '#eeeeec'
--
-- set background=dark
-- execute "silent! colorscheme base16-eighties"
-- highlight Comment guifg=#585858
-- highlight Normal guifg=#999999
-- "highlight TabLine guifg=#333333 guibg=#777777
-- "highlight TabLineSel guifg=#FA7F7F
-- highlight MatchParen gui=bold guibg=black guifg=limegreen
--]])
