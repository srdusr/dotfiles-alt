--vim.lsp.set_log_level("debug")

local status, nvim_lsp = pcall(require, "lspconfig")
if not status then
	return
end

local protocol = require("vim.lsp.protocol")

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
	local function buf_set_keymap(...)
		vim.api.nvim_buf_set_keymap(bufnr, ...)
	end

	local function buf_set_option(...)
		vim.api.nvim_buf_set_option(bufnr, ...)
	end

	--Enable completion triggered by <c-x><c-o>
	buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")

	-- Mappings.
	local opts = { noremap = true, silent = true }

	-- See `:help vim.lsp.*` for documentation on any of the below functions
	buf_set_keymap("n", "gD", "<Cmd>lua vim.lsp.buf.declaration()<CR>", opts) -- most of the lsp server don't implement textDocument/Declaration, so gD is useless for now.
	--buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
	buf_set_keymap("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
	--buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)

	-- add rust specific keymappings
	if client.name == "rust_analyzer" then
		buf_set_keymap("n", "<leader>rr", "<cmd>RustRunnables<CR>", opts)
		buf_set_keymap("n", "<leader>ra", "<cmd>RustHoverAction<CR>", opts)
	end

	-- formatting
	if client.server_capabilities.documentFormattingProvider then
		vim.api.nvim_create_autocmd("BufWritePre", {
			group = vim.api.nvim_create_augroup("Format", { clear = true }),
			buffer = bufnr,
			callback = function()
				vim.lsp.buf.format()
			end,
		})
	end
end

protocol.CompletionItemKind = {
	--	"", -- Text
	--	"", -- Method
	--	"", -- Function
	--	"", -- Constructor
	--	"", -- Field
	--	"", -- Variable
	--	"", -- Class
	--	"ﰮ", -- Interface
	--	"", -- Module
	--	"", -- Property
	--	"", -- Unit
	--	"", -- Value
	--	"", -- Enum
	--	"", -- Keyword
	--	"", -- Snippet
	--	"", -- Color
	--	"", -- File
	--	"", -- Reference
	--	"", -- Folder
	--	"", -- EnumMember
	--	"", -- Constant
	--	"", -- Struct
	--	"", -- Event
	--	"ﬦ", -- Operator
	--	"", -- TypeParameter
	File = { icon = "", hl = "TSURI" },
	Module = { icon = "", hl = "TSNamespace" },
	Namespace = { icon = "", hl = "TSNamespace" },
	Package = { icon = "", hl = "TSNamespace" },
	Class = { icon = "ﴯ", hl = "TSType" },
	Method = { icon = "", hl = "TSMethod" },
	Property = { icon = "", hl = "TSMethod" },
	Field = { icon = "", hl = "TSField" },
	Constructor = { icon = "", hl = "TSConstructor" },
	Enum = { icon = "", hl = "TSType" },
	Interface = { icon = "", hl = "TSType" },
	Function = { icon = "", hl = "TSFunction" },
	Variable = { icon = "", hl = "TSConstant" },
	Constant = { icon = "", hl = "TSConstant" },
	String = { icon = "ﮜ", hl = "TSString" },
	Number = { icon = "", hl = "TSNumber" },
	Boolean = { icon = "ﮒ", hl = "TSBoolean" },
	Array = { icon = "", hl = "TSConstant" },
	Object = { icon = "⦿", hl = "TSType" },
	Key = { icon = "", hl = "TSType" },
	Null = { icon = "ﳠ", hl = "TSType" },
	EnumMember = { icon = "", hl = "TSField" },
	Struct = { icon = "ﴯ", hl = "TSType" },
	Event = { icon = "🗲", hl = "TSType" },
	Operator = { icon = "+", hl = "TSOperator" },
	TypeParameter = { icon = "𝙏", hl = "TSParameter" },
}

-- Set up completion using nvim_cmp with LSP source
local capabilities = require("cmp_nvim_lsp").update_capabilities(vim.lsp.protocol.make_client_capabilities())

nvim_lsp.flow.setup({
	on_attach = on_attach,
	capabilities = capabilities,
})

nvim_lsp.sumneko_lua.setup({
	on_attach = on_attach,
	settings = {
		Lua = {
			diagnostics = {
				-- Get the language server to recognize the `vim` global
				globals = { "vim" },
			},

			workspace = {
				-- Make the server aware of Neovim runtime files
				library = vim.api.nvim_get_runtime_file("", true),
				checkThirdParty = false,
			},
		},
	},
})

-- Diagnostic symbols in the sign column (gutter)
--local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
--local signs = { Error = " ", Warn = " ", Hint = " ", Info = "􀅴 " }
local signs = { Error = " ", Warn = " ", Hint = " ", Info = "􀅴 " }
for type, icon in pairs(signs) do
	local hl = "DiagnosticSign" .. type
	vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end
--
vim.diagnostic.config({
	virtual_text = {
		prefix = "●",
	},
	update_in_insert = true,
	float = {
		source = "always", -- Or "if_many"
	},
})
