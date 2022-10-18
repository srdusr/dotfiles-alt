
-- Setup nvim-cmp.
--vim.opt.completeopt = "menu,menuone,noselect"
vim.g.completeopt = "menu,menuone,noselect,noinsert"
local cmp_status_ok, cmp = pcall(require, "cmp")
if not cmp_status_ok then
	return
end
local WIDE_HEIGHT = 40

local opts = {
	-- whether to highlight the currently hovered symbol
	-- disable if your cpu usage is higher than you want it
	-- or you just hate the highlight
	-- default: true
	highlight_hovered_item = true,
	show_guides = true,
}
require("symbols-outline").setup(opts)


--local snippets_paths = function()
--	local plugins = { "friendly-snippets" }
--	local paths = {}
--	local path
--	local root_path = vim.env.HOME .. "/.vim/plugged/"
--	for _, plug in ipairs(plugins) do
--		path = root_path .. plug
--		if vim.fn.isdirectory(path) ~= 0 then
--			table.insert(paths, path)
--		end
--	end
--	return paths
--end
--
--require("luasnip.loaders.from_vscode").lazy_load({
--	paths = snippets_paths(),
--	include = nil, -- Load all languages
--	exclude = {},
--})

require("luasnip.loaders.from_vscode").lazy_load()
local lspkind = require("lspkind")
local kind_icons = {
  Text = "",
  Method = "m", --"",
  Function = "",
  Constructor = "", --"⚙️",
  Field = "",
  Variable = "",
  Class = "",
  Interface = "",
  Module = "",
  Property = "",
  Unit = "",
  Value = "",
  Enum = "",
  Keyword = "",
  Snippet = "",
  Color = "",
  File = "",
  Reference = "",
  Folder = "",
  EnumMember = "",
  Constant = "",
  Struct = "",
  Event = "",
  Operator = "",
  TypeParameter = "",
}
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
    --['<CR>'] = cmp.config.disable,
		["<C-u>"] = cmp.mapping.scroll_docs(-4),
		["<C-d>"] = cmp.mapping.scroll_docs(4),
		["<C-Space>"] = cmp.mapping.complete(),
    ['<C-o>'] = function(fallback)
      if cmp.visible() then
        cmp.mapping.confirm({ select = true })(fallback)
      else
        cmp.mapping.complete()(fallback)
      end
    end
	}),

  sources = cmp.config.sources({
		{ name = "path" },
		{ name = "nvim_lsp", keyword_length = 3 },
		{ name = "luasnip", keyword_length = 4 },
		--{ name = "buffer", keyword_length = 3 },
    { name = "buffer", option = { get_bufnrs = function()
      return vim.api.nvim_list_bufs()
    end
    }},
    --{ name = 'treesitter' },
		{ name = "cmdline", keyword_pattern = [=[[^[:blank:]\!]*]=], keyword_length = 3 },
		--{ name = "cmdline", keyword_pattern = [=[[^[:blank:]\!]*]=] }, --exclamation mark hangs a bit without this
    { name = "cmp_git"},
		--{name = 'luasnip', keyword_length = 2},
	}),
	formatting = {
      --formatting = {
		format = function(entry, vim_item)
    --format = function(entry, vim_item,)
      --local icons = kind_icons
			--vim_item.kind = string.format("%s", kind_icons[vim_item.kind])
    --  vim_item.kind = lspkind.presets.default[vim_item.kind]
			 vim_item.kind = string.format('%s %s', kind_icons[vim_item.kind], vim_item.kind) -- This concatonates the icons with the name of the item kind
      --vim_item.kind = string.format("%s %s", icons[vim_item.kind], vim_item.kind)
			vim_item.menu = ({
				nvim_lsp = "Lsp",
				luasnip = "Snip",
				buffer = "Buf",
				path = "Path",
        cmdline = "Cmd",
			})[entry.source.name]
			return vim_item
		end,
  --},

    --
    --
		--fields = { "abbr", "kind", "menu" },
   --    format = lspkind.cmp_format({
   --   mode = 'symbol_text', -- show only symbol annotations
   --   maxwidth = 50, -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
   -- })
    --format = require('lspkind').cmp_format {
    --  with_text = true,
    --  menu = {
    --    luasnip = "Snip",
    --    buffer = "Buf",
    --    nvim_lsp = "LSP",
    --    path = "Path",
    --    cmdline = "Cmd",
    --    cmp_git = "Git",
    --  },
    --},
  },
		--format = function(entry, vim_item)
		--	-- Kind icons
		--	--vim_item.kind = string.format("%s", kind_icons[vim_item.kind])
    --  vim_item.kind = lspkind.presets.default[vim_item.kind]
		--	-- vim_item.kind = string.format('%s %s', kind_icons[vim_item.kind], vim_item.kind) -- This concatonates the icons with the name of the item kind
		--	vim_item.menu = ({
		--		nvim_lsp = "LSP",
		--		luasnip = "Snip",
		--		buffer = "Buf",
		--		path = "Path",
    --    cmdline = "Cmd",
		--	})[entry.source.name]
		--	return vim_item
		--end,
  confirm_opts = {
		behavior = cmp.ConfirmBehavior.Replace,
		select = false,
	},


  event = {},

    experimental = {
      ghost_text = true,
      hl_group = 'Nontext',
    },

    view = {
      entries = { name = 'custom', selection_order = 'top_down' },
    },

    window = {
      --completion = cmp.config.window.bordered(),
      completion = {
        border = { '', '', '', ' ', '', '', '', ' ' },
        --border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
        --border = { '', '', '', '', '', '', '', '' },
        --border = "CmpBorder",
        --winhighlight = 'Normal:Pmenu,FloatBorder:Pmenu,CursorLine:PmenuSel,Search:None',
      winhighlight = "Normal:CmpPmenu,CursorLine:PmenuSel,Search:None",
      },
      --documentation = cmp.config.window.bordered(),
      documentation = {
        max_height = math.floor(WIDE_HEIGHT * (WIDE_HEIGHT / vim.o.lines)),
        max_width = math.floor((WIDE_HEIGHT * 2) * (vim.o.columns / (WIDE_HEIGHT * 2 * 16 / 9))),
        border = { '', '', '', ' ', '', '', '', ' ' },
        --border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
        winhighlight = 'FloatBorder:NormalFloat',
      },
    },
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


