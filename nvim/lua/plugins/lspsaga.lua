local status, saga = pcall(require, "lspsaga")
if not status then
  return
end

saga.init_lsp_saga({
  -- when cursor in saga window you config these to move
  move_in_saga = { prev = "k", next = "j" },
  diagnostic_header = { " ", " ", " ", " " },
  scroll_in_preview = {
    scroll_down = "<C-d>",
    scroll_up = "<C-u>",
  },
  code_action_icon = "ﯦ ",
  -- Same as nvim-lightbulb but async
  code_action_lightbulb = {
    sign = false,
    virtual_text = true,
  },
  finder_icons = {
    def = "  ",
    ref = "  ",
    link = "  ",
  },
  finder_action_keys = {
    open = "<CR>",
    "o",
    vsplit = "gv",
    split = "gs",
    tabe = "t",
    quit = "gq",
    scroll_down = "<C-f>",
    scroll_up = "<C-b>",
  },

  -- Show symbols in winbar must be neovim 0.8.0,
  -- Close it until neovim 0.8.0 become stable
  symbol_in_winbar = {
    in_custom = false,
    --enable = enable_winbar,
    separator = "  ",
    show_file = true,
    click_support = false,
  },
})

 -- Mappings.
local map = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

map("n", "gd", "<Cmd>Lspsaga lsp_finder<CR>", opts) -- Press "o" to open the reference location
map("n", "gp", "<Cmd>Lspsaga peek_definition<CR>", opts)
map("n", "K", "<Cmd>Lspsaga hover_doc<CR>", opts)
map("n", "gk", "<Cmd>Lspsaga diagnostic_jump_prev<CR>", opts)
map("n", "gj", "<Cmd>Lspsaga diagnostic_jump_next<CR>", opts)
map("n", "gs", "<Cmd>Lspsaga signature_help<CR>", opts) -- Default is <C-k>
map("n", "go", "<Cmd>Lspsaga show_line_diagnostics<CR>", opts)
map("n", "gr", "<Cmd>Lspsaga rename<CR>", opts)
map("n", "ga", "<Cmd>Lspsaga code_action<CR>", opts)
map("n", "[d", "<Cmd>lua vim.lsp.diagnostic.goto_prev()<CR>", opts)
map("n", "]d", "<Cmd>lua vim.lsp.diagnostic.goto_next()<CR>", opts)
