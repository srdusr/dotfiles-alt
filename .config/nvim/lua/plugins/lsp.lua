require('mason').setup()
local lspconfig = require 'lspconfig'
local null_ls = require 'null-ls'

local keymap = vim.keymap
local cmd = vim.cmd

local border = {
  { '🭽', 'FloatBorder' },
  { '▔', 'FloatBorder' },
  { '🭾', 'FloatBorder' },
  { '▕', 'FloatBorder' },
  { '🭿', 'FloatBorder' },
  { '▁', 'FloatBorder' },
  { '🭼', 'FloatBorder' },
  { '▏', 'FloatBorder' },
}

local signs = { Error = " ", Warn = "▲", Info = "􀅳", Hint = "⚑" }
for type, icon in pairs(signs) do
	local hl = "DiagnosticSign" .. type
	vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

vim.diagnostic.config({
    underline = false,
    signs = true,
    virtual_text = false,
    virtual_lines = { only_current_line = true },
    float = {
        show_header = true,
        source = 'if_many',
        --border = 'rounded',
        border = border,
        focusable = true,
    },
    update_in_insert = false, -- default to false
    severity_sort = false, -- default to false
})

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
	underline = false,
	virtual_text = false,
	signs = true,
	update_in_insert = false,
})

vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })
vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" })

-- Use an on_attach function to only map the following keys after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
  local map = function(mode, l, r, opts)
  	opts = opts or {}
  	opts.silent = true
    opts.noremap = true
  	opts.buffer = bufnr
  	keymap.set(mode, l, r, opts)
  end
  -- Mappings
	map("n", "K", "<Cmd>lua vim.lsp.buf.hover()<CR>")
  --map("n", "gd", "<Cmd>lua vim.lsp.buf.definition()<CR>")
  map("n", "gd", "<cmd>lua require('goto-preview').goto_preview_definition()<CR>")
	--map("n", "gi", "<Cmd>lua vim.lsp.buf.implementation()<CR>")
	map("n", "gi", "<cmd>lua require('goto-preview').goto_preview_implementation()<CR>")
	--map("n", "gr", "<Cmd>lua vim.lsp.buf.references()<CR>")
	map("n", "gr", "<cmd>lua require('goto-preview').goto_preview_references()<CR>")
	map("n", "gD", "<Cmd>lua vim.lsp.buf.declaration()<CR>") -- most lsp servers don't implement textDocument/Declaration, so gD is useless for now.
	map("n", "<leader>k", "<Cmd>lua vim.lsp.buf.signature_help()<CR>")
	--map("n", "gt", "<Cmd>lua vim.lsp.buf.type_definition()<CR>")
	map("n", "gt", "<cmd>lua require('goto-preview').goto_preview_type_definition()<CR>")
	map("n", "gn", "<Cmd>lua vim.lsp.buf.rename()<CR>")
	map("n", "ga", "<Cmd>lua vim.lsp.buf.code_action()<CR>")
  map("n", "gf", "<Cmd>lua vim.lsp.buf.formatting()<CR>")
	map("n", "go", "<Cmd>lua vim.diagnostic.open_float()<CR>")
  map("n", "<leader>go", ":call utils#ToggleDiagnosticsOpenFloat()<CR> | :echom ('Toggle Diagnostics Float open/close...')<CR> | :sl! | echo ('')<CR>")
	map("n", "[d", "<Cmd>lua vim.diagnostic.goto_prev()<CR>")
	map("n", "]d", "<Cmd>lua vim.diagnostic.goto_next()<CR>")
	map("n", "gs", "<Cmd>lua vim.lsp.buf.document_symbol()<CR>")
	map("n", "gw", "<Cmd>lua vim.lsp.buf.workspace_symbol()<CR>")
	map("n", "<leader>wa", "<Cmd>lua vim.lsp.buf.add_workspace_folder()<CR>")
	map("n", "<leader>wr", "<Cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>")
	map("n", "<leader>wl", function()
		print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
	end)

  -- TODO: Use the nicer new API for autocommands
  cmd 'augroup lsp_aucmds'
  if client.server_capabilities.documentHighlightProvider then
    cmd 'au CursorHold <buffer> lua vim.lsp.buf.document_highlight()'
    cmd 'au CursorMoved <buffer> lua vim.lsp.buf.clear_references()'
  end
  cmd 'augroup END'
end

-- Toggle diagnostics visibility
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
capabilities = require("cmp_nvim_lsp").default_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.offsetEncoding = { "utf-16" }

local function prefer_null_ls_fmt(client)
  client.server_capabilities.documentHighlightProvider = false
  client.server_capabilities.documentFormattingProvider = false
  on_attach(client)
end

local servers = {
  asm_lsp = {},
  bashls = {},
  clangd = {},
  cssls = {
    filetypes = { 'css', 'scss', 'less', 'sass' },
    root_dir = lspconfig.util.root_pattern('package.json', '.git'),
  },
  -- ghcide = {},
  html = {},
  jsonls = { prefer_null_ls = true, cmd = { '--stdio' } },
  intelephense = {},
  julials = {
    on_new_config = function(new_config, _)
      local julia = vim.fn.expand '~/.julia/environments/nvim-lspconfig/bin/julia'
      if lspconfig.util.path.is_file(julia) then
        new_config.cmd[1] = julia
      end
    end,
    settings = { julia = { format = { indent = 2 } } },
  },
  pyright = { settings = { python = { formatting = { provider = 'yapf' }, linting = { pytypeEnabled = true } } } },
  rust_analyzer = {
    settings = {
      ['rust-analyzer'] = {
        cargo = { allFeatures = true },
        checkOnSave = {
          command = 'clippy',
          extraArgs = { '--no-deps' },
        },
      },
    },
  },
  lua_ls = ({
		on_attach = on_attach,
		capabilities = capabilities,
    debounce_text_changes = 500,
		settings = {
			Lua = {
				runtime = {
					version = "LuaJIT",
          path = vim.split(package.path, ';'),
				},
				diagnostics = {
          enable = true,
					globals = { "vim" },
				},
				workspace = {
          maxPreload = 2000,
					preloadFileSize = 50000,
          checkThirdParty = false,
				},
			},
		},
	}),
	sqlls = {},
  tsserver = { capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities()),
    on_attach = function(client)
        client.server_capabilities.document_formatting = false
        client.server_capabilities.document_range_formatting = false
    end,
    filetypes = {
      'javascript',
      'javascriptreact',
      'javascript.jsx',
      'typescript',
      'typescriptreact',
      'typescript.tsx'
  }, },
  vimls = {},
  yamlls = {},
}



for server, config in pairs(servers) do
  if config.prefer_null_ls then
    if config.on_attach then
      local old_on_attach = config.on_attach
      config.on_attach = function(client, bufnr)
        old_on_attach(client, bufnr)
        prefer_null_ls_fmt(client)
      end
    else
      config.on_attach = prefer_null_ls_fmt
    end
  elseif not config.on_attach then
    config.on_attach = on_attach
  end

  lspconfig[server].setup(config)
end


-- null_ls setup
local builtins = null_ls.builtins
local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

--local eslint_opts = {
--  -- condition = function(utils)
--  --   return utils.root_has_file ".eslintrc.js" or utils.root_has_file ".eslintrc" or utils.root_has_file ".eslintrc.json"
--  -- end,
--  -- diagnostics_format = "#{m} [#{c}]",
--  prefer_local = true,
--}

null_ls.setup {
  sources = {
    -- Diagnostics
    builtins.diagnostics.chktex,
    --null_ls.builtins.code_actions.eslint_d,
    --null_ls.builtins.diagnostics.eslint_d,
    --null_ls.builtins.formatting.eslint_d,
    -- null_ls.builtins.diagnostics.cppcheck,
    -- null_ls.builtins.diagnostics.proselint,
    -- null_ls.builtins.diagnostics.pylint,
    --builtins.diagnostics.selene,
    builtins.diagnostics.dotenv_linter,
    builtins.diagnostics.shellcheck.with({
      -- shell script diagnostics
      diagnostic_config = {
        -- see :help vim.diagnostic.config()
        underline = true,
        virtual_text = false,
        signs = true,
        update_in_insert = false,
        severity_sort = true,
      },
      diagnostics_format = "[#{c}] #{m} (#{s})",
      -- this will run every time the source runs,
      -- so you should prefer caching results if possible
    }),
    builtins.diagnostics.zsh,
    builtins.diagnostics.todo_comments,
    builtins.diagnostics.teal,
    -- null_ls.builtins.diagnostics.vale,
    builtins.diagnostics.vint,
    builtins.diagnostics.tidy,
    builtins.diagnostics.php,
    builtins.diagnostics.phpcs,
    -- null_ls.builtins.diagnostics.write_good.with { filetypes = { 'markdown', 'tex' } },


    -- Formatting
    builtins.formatting.shfmt.with({
      filetypes = { "bash", "zsh", "sh" },
      extra_args = { "-i", "2", "-ci" },
    }),
    builtins.formatting.shellharden,
    builtins.formatting.trim_whitespace.with { filetypes = { "tmux", "teal", "zsh" } },
    builtins.formatting.clang_format,
    builtins.formatting.rustfmt,
    builtins.formatting.sql_formatter,

    -- null_ls.builtins.formatting.cmake_format,
    builtins.formatting.isort,
    builtins.formatting.htmlbeautifier,
    -- null_ls.builtins.formatting.prettier,
    builtins.formatting.prettier.with({
      filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact", "json", "yaml", "markdown", "html",
      "css", "scss", "less", "graphql", "vue", "svelte" },
      extra_args = { "--single-quote", "--tab-width 4", "--print-width 200" },
    }),
    --null_ls.builtins.formatting.prettierd,
    builtins.formatting.rustfmt,
    builtins.formatting.stylua,
    builtins.formatting.trim_whitespace,
    builtins.formatting.yapf,
    -- null_ls.builtins.formatting.black


    -- Code Actions
    builtins.code_actions.shellcheck, -- shell script code actions
    --builtins.code_actions.eslint_d.with(eslint_opts),
    -- null_ls.builtins.code_actions.refactoring.with { filetypes = { 'javascript', 'typescript', 'lua', 'python', 'c', 'cpp' } },
    builtins.code_actions.gitsigns,
    builtins.code_actions.gitrebase,


    -- Hover
    builtins.hover.dictionary,
    builtins.hover.printenv,
  },
    on_attach = function(client, bufnr)
        if client.supports_method("textDocument/formatting") then
            vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
            vim.api.nvim_create_autocmd("BufWritePre", {
                group = augroup,
                buffer = bufnr,
                callback = function()
                  vim.lsp.buf.format()
                end
            })
        end
      end,
}
