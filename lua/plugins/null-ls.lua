local null_ls_status_ok, null_ls = pcall(require, "null-ls")
if not null_ls_status_ok then
	return
end

---- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/formatting
local formatting = null_ls.builtins.formatting
---- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/diagnostics
local diagnostics = null_ls.builtins.diagnostics
--
--local completion = null_ls.builtins.completion
local codeactions = null_ls.builtins.code_actions

----null_ls.setup({
----	debug = false,
----	sources = {
----		formatting.prettier.with({ extra_args = { "--no-semi", "--single-quote", "--jsx-single-quote" } }),
----		formatting.black.with({ extra_args = { "--fast" } }),
----		formatting.stylua,
----    -- diagnostics.flake8
----	},
----})
--require("null-ls").setup({
--	sources = {
--		require("null-ls").builtins.formatting.stylua,
--		require("null-ls").builtins.diagnostics.eslint,
--		require("null-ls").builtins.completion.spell,
--	},
--})

--null_ls.setup({
--	sources = {
--		formatting.prettier.with({
--			filetypes = { "html", "css", "javascript", "javascriptreact", "markdown", "json", "yaml" },
--		}),
--		formatting.black,
--		formatting.eslint_d,
--		formatting.stylua,
--		formatting.shfmt.with({
--			filetypes = { "bash", "zsh", "sh" },
--		}),
--
--		diagnostics.eslint_d,
--		diagnostics.luacheck,
--		diagnostics.mdl,
--		diagnostics.vint,
--
--		codeactions.eslint_d,
--	},
--	on_attach = function(client)
--		if client.resolved_capabilities.document_formatting then
--			vim.cmd("autocmd BufWritePre <buffer> lua vim.lsp.buf.format()")
--		end
--	end,
--})

null_ls.setup({
	debug = true,
	sources = {
		formatting.prettierd,
		formatting.stylua,
		formatting.shfmt.with({
			filetypes = { "bash", "zsh", "sh" },
		}),
	},
	on_attach = function(client, bufnr)
		if client.server_capabilities.document_formatting then
			local group = vim.api.nvim_create_augroup("NullLsFormatting", { clear = true })
			vim.api.nvim_create_autocmd("BufWritePre", {
				callback = function()
					vim.lsp.buf.formatting_sync(nil, 4000)
				end,
				buffer = bufnr,
				group = group,
			})
		end
	end,
})
