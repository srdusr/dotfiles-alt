
local fn = vim.fn
local keymap = vim.keymap

local utils = require("user.utils")

local custom_attach = function(client, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
--vim.lsp.protocol.CompletionItemKind = {}
	-- Mappings.
	local map = function(mode, l, r, opts)
		opts = opts or {}
		opts.silent = true
    opts.noremap = true
		opts.buffer = bufnr
		keymap.set(mode, l, r, opts)
	end
--map("n", "gd", "<Cmd>Lspsaga lsp_finder<CR>") -- Press "o" to open the reference location
--map("n", "gp", "<Cmd>Lspsaga peek_definition<CR>")
--	--map("n", "gd", vim.lsp.buf.definition, { desc = "go to definition" })
  map("n", "<C-]>", vim.lsp.buf.definition)
--	map("n", "K", vim.lsp.buf.hover)
--	map("n", "<C-k>", vim.lsp.buf.signature_help)
--	map("n", "<leader>rn", vim.lsp.buf.rename, { desc = "varialble rename" })
--	map("n", "gr", vim.lsp.buf.references, { desc = "show references" })
--	map("n", "[d", vim.diagnostic.goto_prev, { desc = "previous diagnostic" })
--	map("n", "]d", vim.diagnostic.goto_next, { desc = "next diagnostic" })
	map("n", "<leader>q", function()
		vim.diagnostic.setqflist({ open = true })
	end, { desc = "put diagnostic to qf" })
--	--map.('n', '<space>q', vim.diagnostic.setloclist)
--	map("n", "ga", vim.lsp.buf.code_action, { desc = "LSP code action" })
--	map("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, { desc = "add workspace folder" })
--	map("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, { desc = "remove workspace folder" })
--	map("n", "<leader>wl", function()
--		print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
--	end, { desc = "list workspace folder" })
--	map("n", "gs", "vim.lsp.buf.document_symbol()<cr>")
--	map("n", "gw", "vim.lsp.buf.workspace_symbol()<cr>", { desc = "list workspace folder" })
--	--map("n", "gs", ":lua vim.lsp.buf.document_symbol()<cr>")
--	map("n", "gt", ":lua vim.lsp.buf.type_definition()<cr>")
--	map("n", "gD", ":lua vim.lsp.buf.declaration()<cr>") -- most lsp servers don't implement textDocument/Declaration, so gD is useless for now.
--	map("n", "gi", ":lua vim.lsp.buf.implementation()<cr>")
	map("n", "go", ":lua vim.diagnostic.open_float()<cr>")
--	map("n", "gk", "<Cmd>Lspsaga diagnostic_jump_prev<CR>")
--	map("n", "gj", "<Cmd>Lspsaga diagnostic_jump_next<CR>")
--vim.api.nvim_set_keymap('n', '<leader>dd', '<cmd>lua vim.diagnostic.setloclist()<CR>', { noremap = true, silent = true })
  --nnoremap("gI", vim.lsp.buf.incoming_calls, opts)
  --
  --nnoremap("<leader>cs", vim.lsp.buf.document_symbol, opts)
  --nnoremap("<leader>cw", vim.lsp.buf.workspace_symbol, opts)
  --nnoremap("<leader>rf", vim.lsp.buf.formatting, opts)
  --require("which-key").register {
  --  ["<leader>rf"] = "lsp: format buffer",
  --  ["<leader>ca"] = "lsp: code action",
  --  ["<leader>gd"] = "lsp: go to type definition",
  --  ["gr"] = "lsp: references",
  --  ["gi"] = "lsp: implementation",
  --  ["gI"] = "lsp: incoming calls",
  --}
--end
vim.g.diagnostics_visible = true
function _G.toggle_diagnostics()
  if vim.g.diagnostics_visible then
    vim.g.diagnostics_visible = false
    vim.diagnostic.disable()
  else
    vim.g.diagnostics_visible = true
    vim.diagnostic.enable()
  end
end

	-- Set some key bindings conditional on server capabilities
	if client.server_capabilities.documentFormattingProvider then
		map("n", "<space>f", vim.lsp.buf.format, { desc = "format code" })
	end

	-- add rust specific keymappings
	if client.name == "rust_analyzer" then
		map("n", "<leader>rr", "<cmd>RustRunnables<CR>")
		map("n", "<leader>ra", "<cmd>RustHoverAction<CR>")
	end

-- Highlight symbol under cursor

-- Add the following to your on_attach (this allows checking server capabilities to avoid calling invalid commands.

if client.server_capabilities.document_highlight then
  vim.cmd [[
    hi! LspReferenceRead cterm=bold ctermbg=red guibg=LightYellow
    hi! LspReferenceText cterm=bold ctermbg=red guibg=LightYellow
    hi! LspReferenceWrite cterm=bold ctermbg=red guibg=LightYellow
  ]]
  vim.api.nvim_create_augroup('lsp_document_highlight', {
    clear = false
  })
  vim.api.nvim_clear_autocmds({
    buffer = bufnr,
    group = 'lsp_document_highlight',
  })
  vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
    group = 'lsp_document_highlight',
    buffer = bufnr,
    callback = vim.lsp.buf.document_highlight,
  })
  vim.api.nvim_create_autocmd('CursorMoved', {
    group = 'lsp_document_highlight',
    buffer = bufnr,
    callback = vim.lsp.buf.clear_references,
  })
end

	if vim.g.logging_level == "debug" then
		local msg = string.format("Language server %s started!", client.name)
		vim.notify(msg, vim.log.levels.DEBUG, { title = "Server?" })
	end
-- suppress error messages from lang servers
end
vim.lsp.set_log_level("debug")
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.offsetEncoding = { "utf-16" }

local lspconfig = require("lspconfig")

if utils.executable("pylsp") then
	lspconfig.pylsp.setup({
		settings = {
			pylsp = {
				plugins = {
					pylint = { enabled = true, executable = "pylint" },
					pyflakes = { enabled = false },
					pycodestyle = { enabled = false },
					jedi_completion = { fuzzy = true },
					pyls_isort = { enabled = true },
					pylsp_mypy = { enabled = true },
				},
			},
		},
		flags = {
			debounce_text_changes = 200,
		},
		capabilities = capabilities,
	})
else
	vim.notify("pylsp not found!", vim.log.levels.WARN, { title = "Server?" })
end

--if utils.executable('pyright') then
--  lspconfig.pyright.setup{
--    on_attach = custom_attach,
--    capabilities = capabilities
--  }
--else
--  vim.notify("pyright not found!", vim.log.levels.WARN, {title = 'Server?'})
--end

if utils.executable("clangd") then
	lspconfig.clangd.setup({
		on_attach = custom_attach,
		capabilities = capabilities,
		filetypes = { "c", "cpp", "cc" },
		flags = {
			debounce_text_changes = 500,
		},
	})
else
	vim.notify("clangd not found!", vim.log.levels.WARN, { title = "Server?" })
end

-- set up vim-language-server
--if utils.executable("vim-language-server") then
--	lspconfig.vimls.setup({
--		on_attach = custom_attach,
--		flags = {
--			debounce_text_changes = 500,
--		},
--		capabilities = capabilities,
--	})
--else
--	vim.notify("vim-language-server not found!", vim.log.levels.WARN, { title = "Server?" })
--end
--
---- set up bash-language-server
--if utils.executable("bash-language-server") then
--	lspconfig.bashls.setup({
--		on_attach = custom_attach,
--		capabilities = capabilities,
--	})
--end

if utils.executable("lua-language-server") then
	lspconfig.sumneko_lua.setup({
		on_attach = custom_attach,
		settings = {
			Lua = {
				runtime = {
					-- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
					version = "LuaJIT",
				},
				diagnostics = {
					-- Get the language server to recognize the `vim` global
					globals = { "vim" },
				},
				workspace = {
					-- Make the server aware of Neovim runtime files,
					library = {
						fn.stdpath("data") .. "/site/pack/packer/opt/emmylua-nvim",
						fn.stdpath("config"),
					},
					maxPreload = 2000,
					preloadFileSize = 50000,
				},
			},
		},
		capabilities = capabilities,
	})
end


if utils.executable("rust-language-server") then
require("lspconfig").rust_analyzer.setup{
    cmd = { "rustup", "run", "nightly", "rust-analyzer" },
    on_attach = custom_attach,
  	flags = {
			debounce_text_changes = 500,
		},
	--[[
    settings = {
        rust = {
            unstable_features = true,
            build_on_save = false,
            all_features = true,
        },
    }
    --]]
}
end

--vim.diagnostic.config({
--  virtual_text = false,
--	underline = true,
--})
vim.diagnostic.config({
    underline = false,
    signs = true,
    virtual_text = false,
    float = {
        show_header = true,
        source = 'if_many',
        border = 'rounded',
        focusable = false,
    },
    update_in_insert = false, -- default to false
    severity_sort = false, -- default to false
})

vim.cmd[[ 
augroup OpenFloat
        autocmd CursorHold,CursorHoldI * lua vim.diagnostic.open_float(nil, {focusable = false,})

augroup END
]]
vim.cmd([[
function! ToggleDiagnosticsOpenFloat()
    " Switch the toggle variable
    let g:DiagnosticsOpenFloat = !get(g:, 'DiagnosticsOpenFloat', 1)

    " Reset group
    augroup OpenFloat
            autocmd!
    augroup END

    " Enable if toggled on
    if g:DiagnosticsOpenFloat
        augroup OpenFloat
            autocmd! CursorHold,CursorHoldI * lua vim.diagnostic.open_float(nil, {focusable = false,}) print ("vim.diagnostic.open_float enabled...")
        augroup END
    endif
endfunction
nnoremap <leader>to :call ToggleDiagnosticsOpenFloat()<CR>\|:echom "vim.diagnostic.open_float disabled . . ."<CR>
]])


vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
	underline = true,
	virtual_text = false,
	signs = true,
	update_in_insert = false,
})

--vim.lsp.buf.definition
vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })

--vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })

vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" })

--local signs = { Error = "✘", Warn = "▲", Info = "􀅳", Hint = "⚑" }
local signs = { Error = " ", Warn = "▲", Info = "􀅳", Hint = "⚑" }
for type, icon in pairs(signs) do
	local hl = "DiagnosticSign" .. type
	vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end


