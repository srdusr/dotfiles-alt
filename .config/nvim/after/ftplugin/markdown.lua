vim.wo.spell = true
vim.bo.spelllang = "en"
vim.wo.wrap = true
vim.wo.linebreak = true
vim.wo.breakindent = true
vim.wo.colorcolumn = "0"
vim.wo.conceallevel = 3
vim.opt.softtabstop = 2 -- Tab key indents by 2 spaces.
vim.opt.shiftwidth = 2  -- >> indents by 2 spaces.

vim.b[0].undo_ftplugin = "setlocal nospell nowrap nolinebreak nobreakindent conceallevel=0"

vim.cmd([[
  autocmd FileType markdown iabbrev <buffer> `` ``
]])

