require "lspsaga".init_lsp_saga {
    -- "single" | "double" | "rounded" | "bold" | "plus"
    border_style = "rounded",
    --border_style = "single",
    saga_winblend = 30,
    move_in_saga = { next = '<C-n>', prev = '<C-p>' },
    --move_in_saga = { prev = "k", next = "j" },
    scroll_in_preview = {
    scroll_down = "<C-d>",
    scroll_up = "<C-u>",
  },
    diagnostic_header = { " ", " ", " ", " " },
    -- add bracket or something with diagnostic source, just have 2 elements
    -- use emoji lightbulb in default
    code_action_icon = "",
    --code_action_icon = "ﯦ ",
    -- if true can press number to execute the codeaction in codeaction window
    code_action_num_shortcut = true,
    -- same as nvim-lightbulb but async
    code_action_lightbulb = {
        enable = false,
        sign = false,
        sign_priority = 20, --
        virtual_text = false,
    },
    finder_icons = {
        def = "  ",
        ref = "  ",
        link = "  ",
    },
    -- preview lines of lsp_finder and definition preview
    max_preview_lines = 5,
    definition_action_keys = {
        edit = '<CR>',
        vsplit = '<C-y>',
        split = '<C-x>',
        tabe = '<C-t>',
        quit = '<ESC>',
    },
    -- definition_preview_quit = '<ESC>',
    -- finder_preview_hl_ns = 8,
    finder_action_keys = {
        open =  { 'o', '<CR>' },
        vsplit = "v",
        split = "s",
        tabe = "t",
        quit = "<ESC>",
        scroll_down = "<C-j>",
        scroll_up = "<C-k>", -- quit can be a table
    },
    code_action_keys = {
        quit = "<ESC>",
        exec = "<CR>",
    },
    rename_action_quit = "<ESC>",
    rename_in_select = true,
    symbol_in_winbar = {
        enable = true,
        --in_custom = false,
        in_custom = true,
        separator = '  ',
        --show_file = false,
        show_file = true,
        click_support = false,
        --click_support = false,
    },
    --show_outline = {
    --    win_position = 'right',
    --    --set special filetype win that outline window split.like NvimTree neotree
    --    -- defx, db_ui
    --    min_with = '',
    --    win_width = 40,
    --    auto_enter = false,
    --    auto_preview = true,
    --    virt_text = 'x',
    --    jump_key = 'l',
    --    -- auto refresh when change buffer
    --    auto_refresh = true,
    --},
    custom_kind = {
        File          =  { " " },
        Module        =  { " " },
        Namespace     =  { "ﱕ " },
        Package       =  { " " },
        Class         =  { "ﴯ " },
        Method        =  { "" },
        Property      =  { "ﰠ " },
        Field         =  { "ﰠ " },
        Constructor   =  { " " },
        Enum          =  { " " },
        Interface     =  { " " },
        Function      =  { " " },
        Variable      =  { " " },
        Constant      =  { " " },
        String        =  { " " },
        Number        =  { " " },
        Boolean       =  { " " },
        Array         =  { " " },
        Object        =  { " " },
        Key           =  { "- " },
        Null          =  { " " },
        EnumMember    =  { " " },
        Struct        =  { " " },
        Event         =  { " " },
        Operator      =  { " " },
        TypeParameter =  { " " },
        TypeAlias     =  { " " },
        Parameter     =  { " " },
        StaticMethod  =  { " " },
        Macro         =  { "廓" },
    },
}

 -- Mappings.
local map = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

map("n", "gd", "<CMD>Lspsaga peek_definition<CR>", opts)
--map("n", "gp", "<Cmd>Lspsaga peek_definition<CR>", opts)
map("n", "gi", "<CMD>Lspsaga lsp_finder<CR>", opts)
map("n", "gh", "<CMD>Lspsaga hover_doc<CR>", opts)
map("n", "gs", "<CMD>Lspsaga signature_help<CR>", opts)
map("n", "ga", "<CMD>Lspsaga code_action<CR>",             opts)
map("v", "ga", "<CMD><C-u>Lspsaga range_code_action<CR>",  opts)
map("n", "gl", "<CMD>Lspsaga show_line_diagnostics<CR>",   opts)
--map("n", "go", "<CMD>Lspsaga open_floaterm zsh<CR>", opts)
map("n", ";D", "<CMD>Lspsaga show_cursor_diagnostics<CR>", opts)
map("n", "<gr>", "<CMD>Lspsaga rename<CR>",               opts)
map("n", "gk", "<CMD>Lspsaga diagnostic_jump_prev<CR>", opts)
map("n", "gj", "<CMD>Lspsaga diagnostic_jump_next<CR>", opts)
map("n", "[d", "<Cmd>lua vim.lsp.diagnostic.goto_prev()<CR>", opts)
map("n", "]d", "<Cmd>lua vim.lsp.diagnostic.goto_next()<CR>", opts)
map("t", "<ESC>", "<CMD>Lspsaga close_floaterm<CR>", opts)

--vim.api.nvim_command("highlight LspFloatWinNormal guibg=none ")
--hi LspFloatWinNormal guibg=none


-- vim.api.nvim_create_autocmd("BufEnter", {
-- callback = function ()
--     if #vim.api.nvim_list_wins() == 1 and vim.bo.filetype == "lspsagaoutline" then
--     vim.cmd "quit"
--     end
-- end
-- })
