if vim.g.snippets ~= "luasnip" or not pcall(require, "luasnip") then
  return
end
--local luasnip = require("luasnip")
local ls = require "luasnip" --
local types = require "luasnip.util.types" --
--local options = {
ls.config.set_config {
  history = true,
  updateevents = "TextChanged,TextChangedI",
  -- Autosnippets:
  enable_autosnippets = true, --
  ext_opts = { --
    [types.choiceNode] = { --
      active = { --
        virt_text = { { " « ", "NonTest" } }, --
      }, --
    }, --
  }, --
}

--local keymap = vim.keymap
local keymap = vim.api.nvim_set_keymap
--local keymap = vim.keymap.set
-- <c-j> is my jump backwards key.
-- this always moves to the previous item within the snippet

--keymap({ "i", "s" }, "<C-j>", function()
-- if ls.jumpable(-1) then
--   ls.jump(-1)
-- end
--end, { silent = true })

-- <c-l> is selecting within a list of options.
-- This is useful for choice nodes (introduced in the forthcoming episode 2)
--keymap({"i"}, "<c-l>", function()
--  if ls.choice_active() then
--    ls.change_choice(1)
--  end
--end, { silent = true })


--keymap("i", "<c-z>", require "luasnip.extras.select_choice")

-- shorcut to source my luasnips file again, which will reload my snippets
--keymap("n", "<leader><leader>s", "<cmd>source ~/.config/nvim/lua/user/plugins/luasnip.lua<CR>")

-- ls.parser.parse_snippet(<text>, <VS**** style snippet>)
--ls.snippets = {
-- all = {
--   -- Available in any filetype
--   ls.parser.parse_snippet("expand", "-- this is what was expanded!"),
--s.snippets = {
-- all = {
--   -- Available in any filetype
--   ls.parser.parse_snippet("expand", "-- this is what was expanded!"),
-- },
-- lua = {
--   -- Lua specific snippets go here.
--   ls.parser.parse_snippet("lf", "local $1 = function($2)\n $0\nend")
-- },
--
--})
local snip = ls.snippet
local node = ls.snippet_node
local text = ls.text_node
local insert = ls.insert_node
local func = ls.function_node
local choice = ls.choice_node
local dynamicn = ls.dynamic_node

local date = function() return {os.date('%Y-%m-%d')} end

ls.add_snippets(nil, {
    all = {
        --snip({
        --    trig = "date",
        --    namr = "Date",
        --    dscr = "Date in the form of YYYY-MM-DD",
        --}, {
        --    func(date, {}),
        --}),
      snip({
    trig = "meta",
    namr = "Metadata",
    dscr = "Yaml metadata format for markdown"
},
{
    text({"---",
    "title: "}), insert(1, "note_title"), text({"", 
    "author: "}), insert(2, "author"), text({"", 
    "date: "}), func(date, {}), text({"",
    "categories: ["}), insert(3, ""), text({"]",
    "lastmod: "}), func(date, {}), text({"",
    "tags: ["}), insert(4), text({"]",
    "comments: true",
    "---", ""}),
    insert(0)
  }),
  }})
--keymap("i", "<C-j>", "<cmd>lua require'luasnip'.jump(1)<CR>", opts)
--keymap("s", "<C-j>", "<cmd>lua require'luasnip'.jump(1)<CR>", opts)
--keymap("i", "<C-k>", "<cmd>lua require'luasnip'.jump(-1)<CR>", opts)
--local opts = { noremap = true, silent = true }
--local keymap = vim.api.nvim_set_keymap
--local keymap = vim.keymap
--local term_opts = { noremap = true, silent = false }
--	local map = function(mode, l, r, opts)
--		opts = opts or {}
--		opts.silent = true
--    opts.noremap = true
--		keymap.set(mode, l, r, opts)
--	end



--keymap("i", "<C-j>", "<Plug>luasnip-expand-or-jump * <Cmd>lua require'luasnip'.expand_or_jump()<CR>", opts)
--keymap("i", "<C-k>", "<Plug>luasnip-jump-prev * <Cmd>lua require'luasnip'.jump(-1)<CR>", opts)
--keymap("s", "<C-j>", "<Plug>luasnip-expand-or-jump * <Cmd>lua require'luasnip'.expand_or_jump()<CR>", opts)
--keymap("s", "<C-k>", "<Plug>luasnip-jump-prev * <Cmd>lua require'luasnip'.jump(-1)<CR>", opts)
--keymap("i", "<C-c>", "<Plug>luasnip-next-choice * <Cmd>lua require'luasnip'.change_choice(1)<CR>", opts)
--keymap("s", "<C-k>", "<cmd>lua require'luasnip'.jump(-1)<CR>", opts)
--map("i", "<C-j>", "<Plug>luasnip-expand-or-jump<CR>")

--!  <Plug>luasnip-expand-repeat * <Cmd>lua require'luasnip'.expand_repeat()<CR>
--!  <Plug>luasnip-delete-check * <Cmd>lua require'luasnip'.unlink_current_if_deleted()<CR>
--i  <Plug>luasnip-jump-prev * <Cmd>lua require'luasnip'.jump(-1)<CR>
--i  <Plug>luasnip-jump-next * <Cmd>lua require'luasnip'.jump(1)<CR>
--i  <Plug>luasnip-prev-choice * <Cmd>lua require'luasnip'.change_choice(-1)<CR>
--i  <Plug>luasnip-next-choice * <Cmd>lua require'luasnip'.change_choice(1)<CR>
--i  <Plug>luasnip-expand-snippet * <Cmd>lua require'luasnip'.expand()<CR>
--i  <Plug>luasnip-expand-or-jump * <Cmd>lua require'luasnip'.expand_or_jump()<CR>

---









--luasnip.config.set_config(options)
--require("luasnip.loaders.from_vscode").lazy_load()
--require("luasnip.loaders.from_vscode").lazy_load { paths = vim.g.luasnippets_path or "" }
--
--vim.api.nvim_create_autocmd("InsertLeave", {
--  callback = function()
--    if
--      require("luasnip").session.current_nodes[vim.api.nvim_get_current_buf()]
--      and not require("luasnip").session.jump_active
--    then
--      require("luasnip").unlink_current()
--    end
--  end,
--})




