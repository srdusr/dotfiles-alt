--[[null-ls.]]
--
-- null-language-server i.e. a sort of language server which does not provide any services such as formatting and diagnostics you expect from a language server. Instead it will need to install corresponding external “sources” and then hook these sources into the neovim lsp client through null-ls.
--
require("null-ls").setup({
	--debug = true,
  disabled_filetypes = { "PKGBUILD" },
  timeout_ms = 5000,
  async = true,
  debounce = 150,
  sources = {
    --require("null-ls").builtins.formatting.shfmt, -- shell script formatting
    require("null-ls").builtins.diagnostics.dotenv_linter,
    --require("null-ls").builtins.diagnostics.editorconfig_checker,
    require("null-ls").builtins.formatting.shfmt.with({
      filetypes = { "bash", "zsh", "sh" },
      extra_args = { "-i", "2", "-ci" },
    }),
    require("null-ls").builtins.formatting.prettier, -- markdown formatting
    --require("null-ls").builtins.diagnostics.shellcheck, -- shell script diagnostics
    require("null-ls").builtins.diagnostics.shellcheck.with({
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
--		require("null-ls").builtins.formatting.stylua, -- lua formatting
--		require("null-ls").builtins.formatting.prettier.with({ -- markdown, html/js formatting
--			filetypes = { "html", "css", "javascript", "javascriptreact", "markdown", "json", "yaml" },
--		}),
--    require("null-ls").builtins.formatting.black,
--		require("null-ls").builtins.formatting.prettierd,
--		require("null-ls").builtins.diagnostics.cspell.with {
--    filetypes = { "python", "rust", "typescript" },
--  },
--		--require("null-ls").builtins.diagnostics.luacheck,
--		--require("null-ls").builtins.diagnostics.eslint,
--		--require("null-ls").builtins.diagnostics.eslint_d,
--		require("null-ls").builtins.diagnostics.mdl,
--		require("null-ls").builtins.diagnostics.vint,
--    require("null-ls").builtins.completion.spell,
--    require("null-ls").builtins.formatting.clang_format,
--    require("null-ls").builtins.formatting.rustfmt,
--    require("null-ls").builtins.formatting.sql_formatter,
--    --require("null-ls").builtins.formatting.google_java_format,
--    require("null-ls").builtins.diagnostics.cppcheck,
    require("null-ls").builtins.formatting.shellharden,
--		--require("null-ls").builtins.code_actions.eslint_d,
    require("null-ls").builtins.code_actions.shellcheck, -- shell script code actions
    require("null-ls").builtins.formatting.clang_format,
    require("null-ls").builtins.formatting.rustfmt,
    --require("null-ls").builtins.formatting.beautysh,
    require("null-ls").builtins.formatting.sql_formatter,
    require("null-ls").builtins.diagnostics.todo_comments,
    --require("null-ls").builtins.diagnostics.zsh,
    require("null-ls").builtins.hover.dictionary,
    require("null-ls").builtins.hover.printenv,
  },
 -- default_timeout = 5000,
 -- diagnostics_format = '[#{c}] #{m} (#{s})',
 -- fallback_severity = vim.diagnostic.severity.ERROR,
 -- log = {
 --   enable = true,
 --   level = 'warn',
 --   use_console = 'async',
 -- },
  --on_attach = nil,
  --on_init = nil,
  --on_exit = nil,
  --update_in_insert = false,
  --update_in_leave = false,
})
