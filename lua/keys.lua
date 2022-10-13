--[[ key.lua ]]

-- Shorten function name
local map = vim.api.nvim_set_keymap

local function new_desc(d)
  return { desc = d }
end

local d = new_desc

local opts = { noremap = true, silent = true }

local term_opts = { silent = true }

--------------- Standard Operations ---------------
-- Semi-colon as leader key
vim.g.mapleader = ";"
--vim.g.maplocalleader = ";"

-- "jj" to exit insert-mode
map("i", "jj", "<esc>", opts)

-- save quickly
--map("n", ";w", ":w<CR>", d("Save buffer"))

--Easier split navigations, just ctrl-j instead of ctrl-w then j
map("n", "<C-J>", "<C-W><C-J>", opts)
map("n", "<C-K>", "<C-W><C-K>", opts)
map("n", "<C-L>", "<C-W><C-L>", opts)
map("n", "<C-H>", "<C-W><C-H>", opts)

-- Combine buffers list with buffer name
map("n", "<Leader>b", ":buffers<CR>:buffer<Space>", opts)

-- Map buffer next, prev and delete to <leader+(n/p/d)>
map("n", "<leader>n", ":bn<cr>", opts)
map("n", "<leader>p", ":bp<cr>", opts)
map("n", "<leader>d", ":bd<cr>", opts)

-- Set alt + j/k to switch lines of texts or simply move them
map("n", "<A-k>", ':let save_a=@a<Cr><Up>"add"ap<Up>:let @a=save_a<Cr>', opts)
map("n", "<A-j>", ':let save_a=@a<Cr>"add"ap:let @a=save_a<Cr>', opts)

map("n", "<leader><C-l>", "<Cmd>!clear<CR>", opts)
vim.cmd([[
  inoremap <A-h> <left>
  inoremap <A-j> <down>
  inoremap <A-k> <up>
  inoremap <A-l> <right>
]])

vim.cmd([[
  cnoremap <A-h> <left>
  cnoremap <A-j> <down>
  cnoremap <A-k> <up>
  cnoremap <A-l> <right>
]])

--vim.cmd([[
--  cnoremap <C-A> <Home>
--  cnoremap <C-F> <Right>
--  cnoremap <C-B> <Left>
--  cnoremap <C-E> <End>
--]])

vim.cmd([[
  snoremap <A-h> <left>
  snoremap <A-j> <down>
  snoremap <A-k> <up>
  snoremap <A-l> <right>
]])

-- move block easily
map("n", "<", "<<", d("Decrease indent"))
map("n", ">", ">>", d("Increase indent"))
map("x", "<", "<gv", d("Increase indent"))
map("x", ">", ">gv", d("Decrease indent"))

-- Resize Panes
map("n", "<Leader>+", ":resize +5<CR>", opts)
map("n", "<Leader>-", ":resize -5<CR>", opts)
map("n", "<Leader><", ":vertical resize +5<CR>", opts)
map("n", "<Leader>>", ":vertical resize -5<CR>", opts)
map("n", "<Leader>=", "<C-w>=", opts)

-- New tab
map("n", "<C-T>e", ":tabedit", opts)

-- create tab like window
map("n", "<C-T>h", ":tabprevious<CR>", d("Goto previous tab"))
map("n", "<C-T>l", ":tabnext<CR>", d("Goto next tab"))
map("n", "<C-T>n", ":tabnew<CR>", d("Create a new tab"))

-- Vim TABs
map("n", "<leader>1", "1gt<CR>", opts)
map("n", "<leader>2", "2gt<CR>", opts)
map("n", "<leader>3", "3gt<CR>", opts)
map("n", "<leader>4", "4gt<CR>", opts)
map("n", "<leader>5", "5gt<CR>", opts)
map("n", "<leader>6", "6gt<CR>", opts)
map("n", "<leader>7", "7gt<CR>", opts)
map("n", "<leader>8", "8gt<CR>", opts)
map("n", "<leader>9", "9gt<CR>", opts)
map("n", "<leader>0", "10gt<CR>", opts)

-- Split window
map("n", "<leader>h", ":split<CR>", opts)
map("n", "<leader>v", ":vsplit<CR>", opts)
map("n", "<leader>c", "<C-w>c", opts)

-- Toggle set number
map("n", "<leader>$", ":NumbersToggle<CR>", opts)
map("n", "<leader>%", ":NumbersOnOff<CR>", opts)

-- Change mode to executable
map("n", "<leader>x", ":!chmod +x %<CR>", opts)

-- Paste without replace clipboard
map("v", "p", '"_dP', opts)

-- Paste end of line
--map("n", ",", "$p", opts)
vim.cmd([[
  nmap , $p
]])

-- Select entire buffer
map("v", "<aa>", "gg<S-v>G", opts)

-- Delete without changing the registers
--map('n', 'x', '"_x', opts)

-- Select all text in current buffer
--map('n', '<leader>a', ':keepjumps normal! ggVG<cr>')

-- Swap two pieces of text, use x to cut in visual mode, then use Ctrl-x in
-- visual mode to select text to swap with
map("v", "<C-X>", "<Esc>`.``gvP``P", opts)

-- Search and replace
map("v", "<leader>sr", 'y:%s/<C-r><C-r>"//g<Left><Left>c', opts)
--vnoremap ; :call Get_visual_selection()<cr>
--
--function! Get_visual_selection()
--  " Why is this not a built-in Vim script function?!
--  let [lnum1, col1] = getpos("'<")[1:2]
--  let [lnum2, col2] = getpos("'>")[1:2]
--  let lines = getline(lnum1, lnum2)
--  let lines[-1] = lines[-1][: col2 - (&selection == 'inclusive' ? 1 : 2)]
--  let lines[0] = lines[0][col1 - 1:]
--  let selection = join(lines,'\n')
--  let change = input('Change the selection with: ')
--  execute ":%s/".selection."/".change."/g"
--endfunction
vim.cmd([[
let s:hidden_all = 0
function! ToggleHiddenAll()
    if s:hidden_all  == 0
        let s:hidden_all = 1
        set noshowmode
        set noruler
        set laststatus=0
        set noshowcmd
    else
        let s:hidden_all = 0
        set showmode
        set ruler
        set laststatus=2
        set showcmd
    endif
endfunction
nnoremap <S-h> :call ToggleHiddenAll()<CR>
]])

vim.cmd([[
  map <leader>s :up \| saveas! %:p:r-<C-R>=strftime("%y.%m.%d-%H:%M")<CR>-bak.<C-R>=expand("%:e")<CR> \| 3sleep \| e #<CR>
]])

-------------- Telescope --------------
--Telescope find_files cwd=..
map("n", "<leader>fc", "<cmd>lua require('telescope.builtin').commands()<cr>", opts)
map(
	"n",
	"<leader>ft",
	"<cmd>lua require('telescope.builtin').builtin(require('telescope.themes').get_dropdown({}))<cr>",
	opts
)

map("n", "<leader>fg", "<cmd>lua require('telescope.builtin').live_grep()<cr>", opts)
map("n", "<leader>fb", "<cmd>lua require('telescope.builtin').current_buffer_fuzzy_find()<cr>", opts)

--map("n", "<leader>fz", ":FZF<CR>", opts)
--map("t", [[<Esc><Esc>]], [[<C-\><C-N>]], opts)
--map("n", "ff", ":NvimTreeToggle<CR>", {})
map("n", "<leader>ff", ":NvimTreeToggle<CR>", {})
--  This <Esc><Esc> avoids crashing fzf menu running in TERMINAL MODE (:q if you do)
-- Find files in config dirs
--key_map("n", "<leader>e", ":lua require('plugins.telescope').find_configs()<CR>",  opts)
map("n", "<leader>f.", "<cmd>lua require('plugins.telescope').find_configs({})<cr>", opts)
map("n", "<leader>ft", "<cmd>lua require('plugins.telescope').file_explorer({})<cr>", opts)
map("n", "<leader>fd", "<cmd>lua require('plugins.telescope').find_notes({})<cr>", opts)
map("n", "<leader>fm", "<cmd>lua require('telescope').extensions.media_files.media_files({})<cr>", opts)
-- registers picker
map("n", "<leader>r", "<cmd>lua require('telescope.builtin').registers({})<CR>", opts)
-- find files including gitignored
--keymap(
--  "n",
--  "<leader>fg",
--  "<cmd>lua require('telescope.builtin').find_files({find_command={'fd','--no-ignore-vcs'}})<CR>", opts)
-- open available commands & run it
map("n", "<leader>fc", "<cmd>lua require('telescope.builtin').commands({results_title='Commands Results'})<CR>", opts)

-------------- Autopairs --------------
Toggle_autopairs = function()
	local ok, autopairs = pcall(require, "nvim-autopairs")
	if ok then
		if autopairs.state.disabled then
			autopairs.enable()
			print("autopairs on")
		else
			autopairs.disable()
			print("autopairs off")
		end
	else
		print("autopairs not available")
	end
end
map("n", "<leader>ww", ":lua Toggle_autopairs()<CR>", term_opts)

-------------- Functions --------------
-- Toggle transparency
vim.cmd([[
  let t:is_transparent = 0
  function! Toggle_transparent_background()
    if t:is_transparent == 0
      hi Normal guibg=#111111 ctermbg=black
      let t:is_transparent = 1
    else
      hi Normal guibg=NONE ctermbg=NONE
      let t:is_transparent = 0
    endif
  endfunction
  nnoremap <leader>tb :call Toggle_transparent_background()<CR>
]])
--keymap('n', '<leader>tb', ':Toggle_transparent_background<CR>', opts)

-- Toggle zoom
vim.cmd([[
  function! s:ZoomToggle() abort
      if exists('t:zoomed') && t:zoomed
          execute t:zoom_winrestcmd
          let t:zoomed = 0
      else
          let t:zoom_winrestcmd = winrestcmd()
          resize
          vertical resize
          let t:zoomed = 1
      endif
  endfunction
  command! ZoomToggle call s:ZoomToggle()
 ]])
map("n", "<leader>z", ":ZoomToggle<CR>", opts)
-- "Zoom" a split window into a tab and/or close it
--keymap('n', '<Leader>,', ':tabnew %<CR>', opts)
--keymap('n', '<Leader>.', ':tabclose<CR>', opts)

-- Open last closed buffer
vim.cmd([[
  function! OpenLastClosed()
      let last_buf = bufname('#')
      if empty(last_buf)
          echo "No recently closed buffer found"
          return
      endif
      let result = input("Open ". last_buf . " in (n)ormal (v)split, (t)ab or (s)plit ? (n/v/t/s) : ")
      if empty(result) || (result !=# 'v' && result !=# 't' && result !=# 's' && result !=# 'n')
          return
      endif
      if result ==# 't'
          execute 'tabnew'
      elseif result ==# 'v'
          execute "vsplit"
      elseif result ==# 's'
          execute "split"
      endif
      execute 'b ' . last_buf
  endfunction
 ]])
map("n", "<C-t>", ":call OpenLastClosed() <CR>", opts)

-- Tabularize
vim.cmd([[
  vnoremap <expr> <Leader>mm ':Tabularize /^\s*\S.*\zs' . split(&commentstring, '%s')[0] . "<CR>"
  nnoremap <expr> <Leader>mm ':Tabularize /^\s*\S.*\zs' . split(&commentstring, '%s')[0] . "<CR>"
  "nnoremap <leader>i mc40A <esc>080lDgelD`cP
  "vnoremap <leader>ii mc0f-20i<Space><Esc>`cdt=j
]])

vim.cmd([[
  " Start interactive EasyAlign in visual mode (e.g. vipga)
  xmap ga <Plug>(EasyAlign)
  " Start interactive EasyAlign for a motion/text object (e.g. gaip)
  nmap ga <Plug>(EasyAlign)
  if !exists('g:easy_align_delimiters')
    let g:easy_align_delimiters = {}
  endif
  let g:easy_align_delimiters['--'] = { 'pattern': '--', 'ignore_groups': ['String'] }
  nnoremap <F1> 21A <Esc>d21\|
  imap <F1> <Esc><F1>a
]])
--:'<,'>EasyAlign /--/
--EasyAlign /--/
--:'<,'>Tabularize /--

map("n", "<leader>,", ":hide<CR>", opts)
map("n", "<leader>.", ":unhide<CR>", opts)

--" Clean trailing whitespace
--nnoremap <leader>ww mz:%s/\s\+$//<cr>:let @/=''<cr>`z

-- Save with root permission (not working for now)
--vim.api.nvim_create_user_command('W', 'w !sudo tee > /dev/null %', {})

-- Copy and Paste with <C-c> and <C-v>
--keymap('n', '<expr> p', (v:register =--= '"' && &clipboard =~ 'unnamed' ? '"*p' : '"' . v:register . 'p')'', opts)
-- Use command :Vb for Visual Block or <C-q> since <C-v> is used for Copy
--command! Vb normal! <C-v>
-- Map <w!!> to save/edit a root permission/read-only file, only works in
-- traditional vim and not neovim
--keymap('c', 'w!! %!sudo tee > /dev/null', opts)
--" Copying text to the system clipboard.
--"
--" For some reason Vim no longer wants to talk to the OS X pasteboard through "*.
--" Computers are bullshit.
--function! g:FuckingCopyTheTextPlease()
--    let old_z = @z
--    normal! gv"zy
--    call system('pbcopy', @z)
--    let @z = old_z
--endfunction
--noremap <leader>p :silent! set paste<CR>"*p:set nopaste<CR>
--" noremap <leader>p mz:r!pbpaste<cr>`z
--vnoremap <leader>y :<c-u>call g:FuckingCopyTheTextPlease()<cr>

--" Indent/dedent/autoindent what you just pasted.
--nnoremap <lt>> V`]<
--nnoremap ><lt> V`]>
--nnoremap =- V`]=

--" Keep the cursor in place while joining lines
--nnoremap J mzJ`z

--" Toggle [i]nvisible characters
--nnoremap <leader>i :set list!<cr>
--
--" Unfuck my screen
--nnoremap U :syntax sync fromstart<cr>:redraw!<cr>

--" Ranger
--nnoremap <leader>r :silent !ranger %:h<cr>:redraw!<cr>
--nnoremap <leader>R :silent !ranger<cr>:redraw!<cr>
--
--" Insert Mode Completion {{{
--
--inoremap <c-f> <c-x><c-f>
--inoremap <c-]> <c-x><c-]>
--inoremap <c-l> <c-x><c-l>
---- Open the current file in the default program (on Mac this should just be just `open`)
--keymap('n', '<leader>x', ':!xdg-open %<cr><cr>')

--keymap("n", "<leader>ff", "<cmd>lua require('telescope.builtin').find_files()<cr>", opts)
--keymap("n", "<leader>ff", "<cmd>lua require('telescope.builtin').find_files cwd=..()<cr>", opts)
--keymap('n', '<leader>k', ':nohlsearch<CR>')
--
--"This unsets the "last search pattern" register by hitting return
vim.cmd([[
  nnoremap <silent> <CR> :noh<CR><CR>
]])

--keymap('n', '<leader>Q', ':bufdo bdelete<CR>')
--
---- Allow gf to open non-existent files
--keymap('', 'gf', ':edit <cfile><CR>')
--
---- Reselect visual selection after indenting
--keymap('v', '<', '<gv')
--keymap('v', '>', '>gv')
--
---- Maintain the cursor position when yanking a visual selection
---- http://ddrscott.github.io/blog/2016/yank-without-jank/
--keymap('v', 'y', 'myy`y')
--keymap('v', 'Y', 'myY`y')
--keymap("n", "<C-q>", ":q<cr>", opts)
--keymap("n", "<C-M-q>", ":qa!<cr>", opts)

--" Sort lines
--nnoremap <leader>s vip:!sort<cr>
--vnoremap <leader>s :!sort<cr>
--
--" Tabs
--nnoremap <leader>( :tabprev<cr>
--nnoremap <leader>) :tabnext<cr>
--
--" Wrap
--nnoremap <leader>W :set wrap!<cr>

--set foldlevelstart=0
--
--" Space to toggle folds.
--nnoremap <Space> za
--vnoremap <Space> za
--" Make zO recursively open whatever fold we're in, even if it's partially open.
--nnoremap zO zczO

-- Packer
--maps.n["<leader>pc"] = { "<cmd>PackerCompile<cr>", desc = "Packer Compile" }
--maps.n["<leader>pi"] = { "<cmd>PackerInstall<cr>", desc = "Packer Install" }
--maps.n["<leader>ps"] = { "<cmd>PackerSync<cr>", desc = "Packer Sync" }
--maps.n["<leader>pS"] = { "<cmd>PackerStatus<cr>", desc = "Packer Status" }
--maps.n["<leader>pu"] = { "<cmd>PackerUpdate<cr>", desc = "Packer Update" }
-- NeoTree
--if is_available "neo-tree.nvim" then
--  keymaps.n["<leader>e"] = { "<cmd>Neotree toggle<cr>", desc = "Toggle Explorer" }
--  keymaps.n["<leader>o"] = { "<cmd>Neotree focus<cr>", desc = "Focus Explorer" }
--end
-- Alpha
--if is_available "alpha-nvim" then maps.n["<leader>d"] = { "<cmd>Alpha<cr>", desc = "Alpha Dashboard" } end

-- Package Manager
-- TODO: v2 rework these key bindings to be more general
--if is_available "mason.nvim" then maps.n["<leader>lI"] = { "<cmd>Mason<cr>", desc = "LSP installer" } end
-- Telescope
--if is_available "telescope.nvim" then
--  maps.n["<leader>fw"] = { function() require("telescope.builtin").live_grep() end, desc = "Search words" }
--  maps.n["<leader>fW"] = {
--    function()
--      require("telescope.builtin").live_grep {
--        additional_args = function(args) return vim.list_extend(args, { "--hidden", "--no-ignore" }) end,
--      }
--    end,
--    desc = "Search words in all files",
--  }
--  maps.n["<leader>gt"] = { function() require("telescope.builtin").git_status() end, desc = "Git status" }
--  maps.n["<leader>gb"] = { function() require("telescope.builtin").git_branches() end, desc = "Git branches" }
--  maps.n["<leader>gc"] = { function() require("telescope.builtin").git_commits() end, desc = "Git commits" }
--  maps.n["<leader>ff"] = { function() require("telescope.builtin").find_files() end, desc = "Search files" }
--  maps.n["<leader>fF"] = {
--    function() require("telescope.builtin").find_files { hidden = true, no_ignore = true } end,
--    desc = "Search all files",
--  }
--  maps.n["<leader>fb"] = { function() require("telescope.builtin").buffers() end, desc = "Search buffers" }
--  maps.n["<leader>fh"] = { function() require("telescope.builtin").help_tags() end, desc = "Search help" }
--  maps.n["<leader>fm"] = { function() require("telescope.builtin").marks() end, desc = "Search marks" }
--  maps.n["<leader>fo"] = { function() require("telescope.builtin").oldfiles() end, desc = "Search history" }
--  maps.n["<leader>fc"] =
--    { function() require("telescope.builtin").grep_string() end, desc = "Search for word under cursor" }
--  maps.n["<leader>sb"] = { function() require("telescope.builtin").git_branches() end, desc = "Git branches" }
--  maps.n["<leader>sh"] = { function() require("telescope.builtin").help_tags() end, desc = "Search help" }
--  maps.n["<leader>sm"] = { function() require("telescope.builtin").man_pages() end, desc = "Search man" }
--  maps.n["<leader>sn"] =
--    { function() require("telescope").extensions.notify.notify() end, desc = "Search notifications" }
--  maps.n["<leader>sr"] = { function() require("telescope.builtin").registers() end, desc = "Search registers" }
--  maps.n["<leader>sk"] = { function() require("telescope.builtin").keymaps() end, desc = "Search keymaps" }
--  maps.n["<leader>sc"] = { function() require("telescope.builtin").commands() end, desc = "Search commands" }
--  maps.n["<leader>ls"] = {
--    function()
--      local aerial_avail, _ = pcall(require, "aerial")
--      if aerial_avail then
--        require("telescope").extensions.aerial.aerial()
--      else
--        require("telescope.builtin").lsp_document_symbols()
--      end
--    end,
--    desc = "Search symbols",
--  }
--  maps.n["<leader>lR"] = { function() require("telescope.builtin").lsp_references() end, desc = "Search references" }
--  maps.n["<leader>lD"] = { function() require("telescope.builtin").diagnostics() end, desc = "Search diagnostics" }
--end
--
---- Terminal
--if is_available "toggleterm.nvim" then
--  local toggle_term_cmd = astronvim.toggle_term_cmd
--  maps.n["<C-\\>"] = { "<cmd>ToggleTerm<cr>", desc = "Toggle terminal" }
--  maps.n["<leader>gg"] = { function() toggle_term_cmd "lazygit" end, desc = "ToggleTerm lazygit" }
--  maps.n["<leader>tn"] = { function() toggle_term_cmd "node" end, desc = "ToggleTerm node" }
--  maps.n["<leader>tu"] = { function() toggle_term_cmd "ncdu" end, desc = "ToggleTerm NCDU" }
--  maps.n["<leader>tt"] = { function() toggle_term_cmd "htop" end, desc = "ToggleTerm htop" }
--  maps.n["<leader>tp"] = { function() toggle_term_cmd "python" end, desc = "ToggleTerm python" }
--  maps.n["<leader>tl"] = { function() toggle_term_cmd "lazygit" end, desc = "ToggleTerm lazygit" }
--  maps.n["<leader>tf"] = { "<cmd>ToggleTerm direction=float<cr>", desc = "ToggleTerm float" }
--  maps.n["<leader>th"] = { "<cmd>ToggleTerm size=10 direction=horizontal<cr>", desc = "ToggleTerm horizontal split" }
--  maps.n["<leader>tv"] = { "<cmd>ToggleTerm size=80 direction=vertical<cr>", desc = "ToggleTerm vertical split" }
--end
--
---- Stay in indent mode
--maps.v["<"] = { "<gv", desc = "unindent line" }
--maps.v[">"] = { ">gv", desc = "indent line" }
--
---- Improved Terminal Mappings
--maps.t["<esc>"] = { "<C-\\><C-n>", desc = "Terminal normal mode" }
--maps.t["jk"] = { "<C-\\><C-n>", desc = "Terminal normal mode" }
--maps.t["<C-h>"] = { "<c-\\><c-n><c-w>h", desc = "Terminal left window navigation" }
--maps.t["<C-j>"] = { "<c-\\><c-n><c-w>j", desc = "Terminal down window navigation" }
--maps.t["<C-k>"] = { "<c-\\><c-n><c-w>k", desc = "Terminal up window navigation" }
--maps.t["<C-l>"] = { "<c-\\><c-n><c-w>l", desc = "Terminal right window naviation" }
-- LSP Installer
--if is_available "mason-lspconfig.nvim" then maps.n["<leader>li"] = { "<cmd>LspInfo<cr>", desc = "LSP information" } end

--  ALE: toggle _ALE activity
--keymap('n', '<leader>a',[[:ALEToggle<CR>]])

--keymap('n', '<Leader>cd', ':call fzf#run({'source': 'fd -t d -H . ~', 'sink': 'cd'})<CR>', opts)
-- ":lua require('neogen').generate()<CR>", opts)
--keymap("n", "<leader>ww", ":set wrap!<CR>", opts)
--
