
-- Setup nvim-cmp.
vim.opt.completeopt = "menu,menuone,noselect"

local cmp_status_ok, cmp = pcall(require, "cmp")
if not cmp_status_ok then
	return
end


local opts = {
	-- whether to highlight the currently hovered symbol
	-- disable if your cpu usage is higher than you want it
	-- or you just hate the highlight
	-- default: true
	highlight_hovered_item = true,

	-- whether to show outline guides
	-- default: true
	show_guides = true,
}
require("symbols-outline").setup(opts)

local snippets_paths = function()
	local plugins = { "friendly-snippets" }
	local paths = {}
	local path
	local root_path = vim.env.HOME .. "/.vim/plugged/"
	for _, plug in ipairs(plugins) do
		path = root_path .. plug
		if vim.fn.isdirectory(path) ~= 0 then
			table.insert(paths, path)
		end
	end
	return paths
end

require("luasnip.loaders.from_vscode").lazy_load({
	paths = snippets_paths(),
	include = nil, -- Load all languages
	exclude = {},
})

local lspkind = require("lspkind")

--local kind_icons = {
--	Text = "",
--	Method = "",
--	Function = "",
--	Constructor = "⚙️",
--	Field = "",
--	Variable = "",
--	Class = "ﴯ",
--	Interface = "",
--	Module = "",
--	Property = "ﰠ",
--	Unit = "",
--	Value = "",
--	Enum = "",
--	Keyword = "",
--	Snippet = "",
--	Color = "",
--	File = "",
--	Reference = "",
--	Folder = "",
--	EnumMember = "",
--	Constant = "",
--	Struct = "",
--	Event = "",
--	Operator = "",
--	TypeParameter = "",
--}

cmp.setup({
	snippet = {
		expand = function(args)
			require("luasnip").lsp_expand(args.body)
		end,
	},
	mapping = cmp.mapping.preset.insert({
--		["<CR>"] = cmp.mapping.confirm({
--			behavior = cmp.ConfirmBehavior.Replace,
--			select = true,
--		}),
    ['<C-y>'] = cmp.mapping.confirm({ select = true }),
		["<C-e>"] = cmp.mapping.close(),
		["<C-u>"] = cmp.mapping.scroll_docs(-4),
		["<C-d>"] = cmp.mapping.scroll_docs(4),
		["<C-Space>"] = cmp.mapping.complete(),
	}),

	formatting = {
		fields = { "abbr", "kind", "menu" },
		format = function(entry, vim_item)
			-- Kind icons
			--vim_item.kind = string.format("%s", kind_icons[vim_item.kind])
      vim_item.kind = lspkind.presets.default[vim_item.kind]
			-- vim_item.kind = string.format('%s %s', kind_icons[vim_item.kind], vim_item.kind) -- This concatonates the icons with the name of the item kind
			vim_item.menu = ({
				nvim_lsp = "LSP",
				luasnip = "Snip",
				buffer = "Buf",
				path = "Path",
        cmdline = "Cmd",
			})[entry.source.name]
			return vim_item
		end,
	},
  sources = cmp.config.sources({
		{ name = "path" },
		{ name = "nvim_lsp", keyword_length = 3 },
		{ name = "luasnip", keyword_length = 4 },
		{ name = "buffer", keyword_length = 3 },
    --{ name = 'treesitter' },
		{ name = "cmdline", keyword_pattern = [=[[^[:blank:]\!]*]=], keyword_length = 3 },
		--{ name = "cmdline", keyword_pattern = [=[[^[:blank:]\!]*]=] }, --exclamation mark hangs a bit without this
		--{name = 'luasnip', keyword_length = 2},
	}),
  confirm_opts = {
		behavior = cmp.ConfirmBehavior.Replace,
		select = false,
	},
	window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
		--documentation = {
		--	border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
		--},
	},
--	experimental = {
--		ghost_text = true,
--		native_menu = true,
--		--native_menu = false,
--		--view = {
--		--  entries = "native"
--		--},
--	},
})

cmp.setup.cmdline("/", {
	mapping = cmp.mapping.preset.cmdline(),
	sources = {
		{ name = "buffer" },
	},
})

cmp.setup.cmdline(":", {
	mapping = cmp.mapping.preset.cmdline(),
	sources = cmp.config.sources({
		{ name = "path" },
	}, {
		{ name = "cmdline" },
	}),
})


