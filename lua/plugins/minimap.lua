vim.cmd([[
  let g:minimap_width = 30
  "let g:minimap_auto_start = 1
  "let g:minimap_auto_start_win_enter = 1
]])
vim.api.nvim_create_autocmd('QuitPre', {
	pattern = '*',
	desc = 'Close minimap on exit',
	-- group = group,
	command = 'MinimapClose',
})
