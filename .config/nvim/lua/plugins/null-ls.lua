--[[null-ls.]]
--
-- null-language-server i.e. a sort of language server which does not provide any services such as formatting and diagnostics you expect from a language server. Instead it will need to install corresponding external “sources” and then hook these sources into the neovim lsp client through null-ls.
--
local null_ls = require "null-ls"
local builtins = null_ls.builtins

local eslint_opts = {
  -- condition = function(utils)
  --   return utils.root_has_file ".eslintrc.js" or utils.root_has_file ".eslintrc" or utils.root_has_file ".eslintrc.json"
  -- end,
  -- diagnostics_format = "#{m} [#{c}]",
  prefer_local = true,
}

local sources = {
  builtins.formatting.stylua,
  builtins.formatting.shfmt.with({
    filetypes = { "bash", "zsh", "sh" },
    extra_args = { "-i", "2", "-ci" },
  }),
  builtins.formatting.shellharden,
  builtins.formatting.trim_whitespace.with { filetypes = { "tmux", "teal", "zsh" } },
  builtins.formatting.clang_format,
  builtins.formatting.rustfmt,
  builtins.formatting.sql_formatter,
  builtins.formatting.prettierd.with {
    filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact", "json", "yaml", "markdown", "html", "css", "scss", "less", "graphql", "vue", "svelte" },
    condition = function(utils)
      return utils.root_has_file ".prettierrc" or utils.root_has_file ".prettierrc.js" or utils.root_has_file ".prettierrc.json" or utils.root_has_file "prettier.config.js" or utils.root_has_file "prettier.config.cjs"
    end,
  },

  builtins.diagnostics.dotenv_linter,
  builtins.diagnostics.shellcheck.with({ -- shell script diagnostics
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
  builtins.diagnostics.eslint_d.with(eslint_opts),
  builtins.diagnostics.todo_comments,
  builtins.diagnostics.vint,

  builtins.code_actions.shellcheck, -- shell script code actions
  builtins.code_actions.eslint_d.with(eslint_opts),
  builtins.code_actions.gitsigns,
  builtins.code_actions.gitrebase,
  builtins.hover.dictionary,
  builtins.hover.printenv,
}

local M = {}

M.setup = function(on_attach)
  local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

  null_ls.setup {
    sources = sources,
    debug = false,
    on_attach = function(client, bufnr)
      on_attach(client, bufnr)
      -- Format on save
      -- vim.cmd [[autocmd BufWritePost <buffer> lua vim.lsp.buf.formatting()]]

      -- if client.supports_method "textDocument/formatting" then
      --   vim.api.nvim_clear_autocmds { group = augroup, buffer = bufnr }
      --   vim.api.nvim_create_autocmd("BufWritePre", {
      --     group = augroup,
      --     buffer = bufnr,
      --     callback = function()
      --       -- on 0.8, you should use vim.lsp.buf.format({ bufnr = bufnr }) instead
      --       vim.lsp.buf.format { bufnr = bufnr }
      --     end,
      --   })
      -- end
    end,
  }
end

return M

--require("null-ls").setup({
--	--debug = true,
--  disabled_filetypes = { "PKGBUILD" },
--  timeout_ms = 5000,
--  async = true,
--  debounce = 150,
--  --log = {
--  --  enable = true,
--  --  level = 'warn',
--  --  use_console = 'async',
--  --},
--  update_in_insert = false,
--  --fallback_severity = vim.diagnostic.severity.ERROR,
--  --log_level = "warn",
--  --on_attach = nil,
--  --on_init = nil,
--  --on_exit = nil,
--  sources = {
--    --require("null-ls").builtins.formatting.shfmt, -- shell script formatting
--    require("null-ls").builtins.diagnostics.dotenv_linter,
--    --require("null-ls").builtins.diagnostics.editorconfig_checker,
--    require("null-ls").builtins.formatting.shfmt.with({
--      filetypes = { "bash", "zsh", "sh" },
--      extra_args = { "-i", "2", "-ci" },
--    }),
--    require("null-ls").builtins.formatting.prettier, -- markdown formatting
--    --require("null-ls").builtins.diagnostics.shellcheck, -- shell script diagnostics
--    require("null-ls").builtins.diagnostics.shellcheck.with({
--      diagnostic_config = {
--      -- see :help vim.diagnostic.config()
--        underline = true,
--        virtual_text = false,
--        signs = true,
--        update_in_insert = false,
--        severity_sort = true,
--      },
--      diagnostics_format = "[#{c}] #{m} (#{s})",
--              -- this will run every time the source runs,
--        -- so you should prefer caching results if possible
--    }),
----		require("null-ls").builtins.formatting.stylua, -- lua formatting
----		require("null-ls").builtins.formatting.prettier.with({ -- markdown, html/js formatting
----			filetypes = { "html", "css", "javascript", "javascriptreact", "markdown", "json", "yaml" },
----		}),
----    require("null-ls").builtins.formatting.black,
----		require("null-ls").builtins.formatting.prettierd,
----		require("null-ls").builtins.diagnostics.cspell.with {
----    filetypes = { "python", "rust", "typescript" },
----  },
----		--require("null-ls").builtins.diagnostics.luacheck,
----		--require("null-ls").builtins.diagnostics.eslint,
----		--require("null-ls").builtins.diagnostics.eslint_d,
----		require("null-ls").builtins.diagnostics.mdl,
----		require("null-ls").builtins.diagnostics.vint,
----    require("null-ls").builtins.completion.spell,
----    require("null-ls").builtins.formatting.clang_format,
----    require("null-ls").builtins.formatting.rustfmt,
----    require("null-ls").builtins.formatting.sql_formatter,
----    --require("null-ls").builtins.formatting.google_java_format,
----    require("null-ls").builtins.diagnostics.cppcheck,
--    require("null-ls").builtins.formatting.shellharden,
----		--require("null-ls").builtins.code_actions.eslint_d,
--    require("null-ls").builtins.code_actions.shellcheck, -- shell script code actions
--    require("null-ls").builtins.formatting.clang_format,
--    require("null-ls").builtins.formatting.rustfmt,
--    --require("null-ls").builtins.formatting.beautysh,
--    require("null-ls").builtins.formatting.sql_formatter,
--    require("null-ls").builtins.diagnostics.todo_comments,
--    --require("null-ls").builtins.diagnostics.zsh,
--    require("null-ls").builtins.hover.dictionary,
--    require("null-ls").builtins.hover.printenv,
--  },
-- -- default_timeout = 5000,
-- -- diagnostics_format = '[#{c}] #{m} (#{s})',
-- -- fallback_severity = vim.diagnostic.severity.ERROR,
-- -- log = {
-- --   enable = true,
-- --   level = 'warn',
-- --   use_console = 'async',
-- -- },
--  --on_attach = nil,
--  --on_init = nil,
--  --on_exit = nil,
--  --update_in_insert = false,
--  --update_in_leave = false,
--})
