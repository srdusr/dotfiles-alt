-- Shorten Function Names
local fn = vim.fn
local keymap = vim.keymap
local mods = require("user.mods")


-- Setup mason so it can manage external tooling
require('mason').setup()

-- Mason-lspconfig
require("mason-lspconfig").setup({
  ensure_installed = {
    "clangd",
    "lua_ls",
    "pylsp",
    "pyright",
  },
  ui = {
    icons = {
      package_pending = " ",
      package_installed = " ",
      package_uninstalled = " ﮊ",
    },
    keymaps = {
      toggle_server_expand = "<CR>",
      install_server = "i",
      update_server = "u",
      check_server_version = "c",
      update_all_servers = "U",
      check_outdated_servers = "C",
      uninstall_server = "X",
      cancel_installation = "<C-c>",
    },
  },
  max_concurrent_installers = 10,
})

-- Use an on_attach function to only map the following keys after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Shorten function names for mappings
  local map = function(mode, l, r, opts)
  	opts = opts or {}
  	opts.silent = true
    opts.noremap = true
  	opts.buffer = bufnr
  	keymap.set(mode, l, r, opts)
  end

  -- Mappings
	map("n", "K", "<Cmd>lua vim.lsp.buf.hover()<CR>")
  map("n", "gd", "<Cmd>lua vim.lsp.buf.definition()<CR>")
	map("n", "gi", "<Cmd>lua vim.lsp.buf.implementation()<CR>")
	map("n", "gr", "<Cmd>lua vim.lsp.buf.references()<CR>")
	map("n", "gD", "<Cmd>lua vim.lsp.buf.declaration()<CR>") -- most lsp servers don't implement textDocument/Declaration, so gD is useless for now.
	map("n", "<leader>k", "<Cmd>lua vim.lsp.buf.signature_help()<CR>")
	map("n", "gt", "<Cmd>lua vim.lsp.buf.type_definition()<CR>")
	map("n", "gn", "<Cmd>lua vim.lsp.buf.rename()<CR>")
	map("n", "ga", "<Cmd>lua vim.lsp.buf.code_action()<CR>")
  map("n", "gf", "<Cmd>lua vim.lsp.buf.formatting()<CR>")
	--map("n", "go", "<Cmd>lua vim.diagnostic.open_float()<CR>")
  map("n", "go", ":call utils#ToggleDiagnosticsOpenFloat()<CR> | :echom ('Toggle Diagnostics Float open/close...')<CR> | :sl! | echo ('')<CR>")
	map("n", "[d", "<Cmd>lua vim.diagnostic.goto_prev()<CR>")
	map("n", "]d", "<Cmd>lua vim.diagnostic.goto_next()<CR>")
	map("n", "gs", "<Cmd>lua vim.lsp.buf.document_symbol()<CR>")
	map("n", "gw", "<Cmd>lua vim.lsp.buf.workspace_symbol()<CR>")
	map("n", "<leader>wa", "<Cmd>lua vim.lsp.buf.add_workspace_folder()<CR>")
	map("n", "<leader>wr", "<Cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>")
	map("n", "<leader>wl", function()
		print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
	end)
	--map("n", "<leader>q", function()
	--	vim.diagnostic.setqflist({ open = true })
	--end)
	--map("n", "<space>q", "<Cmd>lua vim.diagnostic.setloclist()<CR>")
  --map("n", "gk", "<Cmd>Lspsaga diagnostic_jump_prev<CR>")
  --map("n", "gj", "<Cmd>Lspsaga diagnostic_jump_next<CR>")

  -- Set some key bindings conditional on server capabilities
	if client.server_capabilities.documentFormattingProvider then
		map("n", "<space>f", vim.lsp.buf.format)
	end

  -- Add rust specific keymappings
	if client.name == "rust_analyzer" then
		map("n", "<leader>rr", "<cmd>RustRunnables<CR>")
		map("n", "<leader>ra", "<cmd>RustHoverAction<CR>")
	end

  -- this part is telling Neovim to use the lsp server
  --local servers = { 'pyright', 'tsserver', 'jdtls' }
  --for _, lsp in pairs(servers) do
  --    require('lspconfig')[lsp].setup {
  --        on_attach = on_attach,
  --        flags = {
  --          debounce_text_changes = 150,
  --        }
  --    }
  --end

  -- Add the following to your on_attach (this allows checking server capabilities to avoid calling invalid commands.)
  -- Highlight symbol under cursor
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
    --vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
    --  group = 'lsp_document_highlight',
    --  buffer = bufnr,
    --  callback = vim.lsp.buf.document_highlight,
    --})
    --vim.api.nvim_create_autocmd("CursorHold", {
    --  buffer = bufnr,
    --  callback = function()
    --    local term_opts = {
    --      focusable = false,
    --      --close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
    --      close_events = { "BufLeave" },
    --      border = 'rounded',
    --      --source = 'always',
    --      --prefix = ' ',
    --      --scope = 'cursor',
    --    }
    --  vim.diagnostic.open_float(nil, term_opts)
    --  end
		--})
    vim.api.nvim_create_autocmd('CursorMoved', {
      group = 'lsp_document_highlight',
      buffer = bufnr,
      callback = vim.lsp.buf.clear_references,
      --callback = ":silent! lua vim.lsp.buf.clear_references()",

    })
  end

	if vim.g.logging_level == "debug" then
		local msg = string.format("Language server %s started!", client.name)
		vim.notify(msg, vim.log.levels.DEBUG, { title = "Server?" })
	end

end

 Toggle diagnostics visibility
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

-- Open float for diagnostics automatically
vim.cmd([[
augroup OpenFloat
        " autocmd CursorHold,CursorHoldI * lua vim.diagnostic.open_float(nil, {focusable = false,})
        autocmd CursorHold * lua vim.diagnostic.open_float(nil, {focusable = false,})

augroup END
]])

-- Suppress error messages from lang servers
vim.lsp.set_log_level("debug")
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.offsetEncoding = { "utf-16" }

local lspconfig = require("lspconfig")

if mods.executable("pylsp") then
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

if mods.executable('pyright') then
  lspconfig.pyright.setup{
    on_attach = on_attach,
    capabilities = capabilities
  }
else
  vim.notify("pyright not found!", vim.log.levels.WARN, {title = 'Server?'})
end

if mods.executable("clangd") then
	lspconfig.clangd.setup({
		on_attach = on_attach,
		capabilities = capabilities,
		filetypes = { "c", "cpp", "cc" },
		flags = {
			debounce_text_changes = 500,
		},
	})
else
	vim.notify("clangd not found!", vim.log.levels.WARN, { title = "Server?" })
end

-- Set up vim-language-server
if mods.executable("vim-language-server") then
	lspconfig.vimls.setup({
		on_attach = on_attach,
		flags = {
			debounce_text_changes = 500,
		},
		capabilities = capabilities,
	})
else
	vim.notify("vim-language-server not found!", vim.log.levels.WARN, { title = "Server?" })
end

-- Set up bash-language-server
if mods.executable("bash-language-server") then
	lspconfig.bashls.setup({
		on_attach = on_attach,
		capabilities = capabilities,
    debounce_text_changes = 500,
	})
end

if mods.executable("lua-language-server") then
	lspconfig.lua_ls.setup({
		on_attach = on_attach,
		capabilities = capabilities,
    debounce_text_changes = 500,
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
          maxPreload = 2000,
					preloadFileSize = 50000,
				},
			},
		},
	})
end


if mods.executable("rust-language-server") then
require("lspconfig").rust_analyzer.setup{
    cmd = { "rustup", "run", "nightly", "rust-analyzer" },
    on_attach = on_attach,
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

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
	underline = false,
	virtual_text = false,
	signs = false,
	update_in_insert = false,
})
vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })
vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" })


-- The following settings works with the bleeding edge neovim.
-- See https://github.com/neovim/neovim/pull/13998.
vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
  vim.lsp.handlers.hover, {
    border = {
       {"┌", "Normal"},
       {"─", "Normal"},
       {"┐", "Normal"},
       {"│", "Normal"},
       {"┘", "Normal"},
       {"─", "Normal"},
       {"└", "Normal"},
       {"│", "Normal"}
     }
})

-- this is for diagnositcs signs on the line number column
-- use this to beautify the plain E W signs to more fun ones
-- !important nerdfonts needs to be setup for this to work in your terminal
--local signs = { Error = "✘", Warn = "▲", Info = "􀅳", Hint = "⚑" }
local signs = { Error = " ", Warn = "▲", Info = "􀅳", Hint = "⚑" }
for type, icon in pairs(signs) do
	local hl = "DiagnosticSign" .. type
	--vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
	vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end


