-- lspconfig + nvim-cmp + lspsaga
-- Dependencies
--    nvim-lspconfig
--    nvim-cmp
--    cmp-buffer
--    cmp-path
--    cmp_luasnip
--    cmp-nvim-lsp
--    LuaSnip
--    friendly-snippets
local fn = vim.fn
local api = vim.api
local keymap = vim.keymap
local lsp = vim.lsp

local utils = require("utils")

local custom_attach = function(client, bufnr)
  -- Mappings.
  local map = function(mode, l, r, opts)
    opts = opts or {}
    opts.silent = true
    opts.buffer = bufnr
    keymap.set(mode, l, r, opts)
  end


local lsp_defaults = {
	flags = {
		debounce_text_changes = 150, -- Amount of miliseconds neovim will wait to send the next document update notification.
	},

  -- The data on this option is send to the server, to announce what features the editor can support.
	capabilities = require("cmp_nvim_lsp").update_capabilities(vim.lsp.protocol.make_client_capabilities()),
	on_attach = function(client, bufnr)
		vim.api.nvim_exec_autocmds("User", { pattern = "LspAttached" })
	end,
}

local lspconfig = require('lspconfig')

lspconfig.util.default_config = vim.tbl_deep_extend(
  'force',
  lspconfig.util.default_config,
  lsp_defaults
)

---
-- LSP Servers
---

if utils.executable("pylsp") then
  lspconfig.pylsp.setup {
    on_attach = custom_attach,
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
  }
else
  vim.notify("pylsp not found!", vim.log.levels.WARN, { title = "Nvim-config" })
end

-- if utils.executable('pyright') then
--   lspconfig.pyright.setup{
--     on_attach = custom_attach,
--     capabilities = capabilities
--   }
-- else
--   vim.notify("pyright not found!", vim.log.levels.WARN, {title = 'Nvim-config'})
-- end

if utils.executable("clangd") then
  lspconfig.clangd.setup {
    on_attach = custom_attach,
    capabilities = capabilities,
    filetypes = { "c", "cpp", "cc" },
    flags = {
      debounce_text_changes = 500,
    },
  }
else
  vim.notify("clangd not found!", vim.log.levels.WARN, { title = "Nvim-config" })
end

-- set up vim-language-server
if utils.executable("vim-language-server") then
  lspconfig.vimls.setup {
    on_attach = custom_attach,
    flags = {
      debounce_text_changes = 500,
    },
    capabilities = capabilities,
  }
else
  vim.notify("vim-language-server not found!", vim.log.levels.WARN, { title = "Nvim-config" })
end

-- set up bash-language-server
if utils.executable("bash-language-server") then
  lspconfig.bashls.setup {
    on_attach = custom_attach,
    capabilities = capabilities,
  }
end

if utils.executable("lua-language-server") then
  -- settings for lua-language-server can be found on https://github.com/sumneko/lua-language-server/wiki/Settings .
  lspconfig.sumneko_lua.setup {
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
          -- see also https://github.com/sumneko/lua-language-server/wiki/Libraries#link-to-workspace .
          -- Lua-dev.nvim also has similar settings for sumneko lua, https://github.com/folke/lua-dev.nvim/blob/main/lua/lua-dev/sumneko.lua .
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
  }
end
-- Lua
lspconfig.sumneko_lua.setup({
  settings = {
    Lua = {
      runtime = {
        -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
        version = 'LuaJIT',
      },
      diagnostics = {
        -- Get the language server to recognize the `vim` global
        globals = {'vim'},
      },
      workspace = {
        -- Make the server aware of Neovim runtime files
        library = vim.api.nvim_get_runtime_file("", true),
      },
      -- Do not send telemetry data containing a randomized but unique identifier
      telemetry = {
        enable = false,
      },
    },
  },
  single_file_support = true,
  on_attach = function(client, bufnr)
    print('hello')
    lspconfig.util.default_config.on_attach(client, bufnr)
  end
})

lspconfig.sumneko_lua.setup({
on_attach = custom_attach,
settings = {
    Lua = {
    runtime = {
        -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
        version = "LuaJIT",
        -- Setup your lua path
        path = runtime_path,
    },
    diagnostics = {
        -- Get the language server to recognize the `vim` global
        globals = { "vim" },
    },
    workspace = {
        -- Make the server aware of Neovim runtime files
        library = api.nvim_get_runtime_file("", true),
    },
    -- Do not send telemetry data containing a randomized but unique identifier
    telemetry = {
        enable = false,
    },
    },
},
})

  lspconfig.sumneko_lua.setup {
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
          -- see also https://github.com/sumneko/lua-language-server/wiki/Libraries#link-to-workspace .
          -- Lua-dev.nvim also has similar settings for sumneko lua, https://github.com/folke/lua-dev.nvim/blob/main/lua/lua-dev/sumneko.lua .
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
  }

require'lspconfig'.sumneko_lua.setup {
  settings = {
    Lua = {
      runtime = {
        -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
        version = 'LuaJIT',
      },
      diagnostics = {
        -- Get the language server to recognize the `vim` global
        globals = {'vim'},
      },
      workspace = {
        -- Make the server aware of Neovim runtime files
        library = vim.api.nvim_get_runtime_file("", true),
      },
      -- Do not send telemetry data containing a randomized but unique identifier
      telemetry = {
        enable = false,
      },
    },
  },
}



require'lspconfig'.sumneko_lua.setup{}


**Default values:**
  - `cmd` : 
  { "lua-language-server" }
  - `filetypes` : 
  - `log_level` : 
  ```lua
  2
  ```
  - `root_dir` : 
  ```lua
  root_pattern(".luarc.json", ".luacheckrc", ".stylua.toml", "stylua.toml", "selene.toml", ".git")
  ```
  - `settings` : 
  ```lua
  {
    Lua = {
      telemetry = {
        enable = false
      }
    }
  }
  - `single_file_support` : 
  true
















**Snippet to enable the language server:**
```lua
require'lspconfig'.ccls.setup{}
```


**Default values:**
  - `cmd` : 
  ```lua
  { "ccls" }
  ```
  - `filetypes` : 
  ```lua
  { "c", "cpp", "objc", "objcpp" }
  ```
  - `offset_encoding` : 
  ```lua
  "utf-32"
  ```
  - `root_dir` : 
  ```lua
  root_pattern('compile_commands.json', '.ccls', '.git')
  ```
  - `single_file_support` : 
  ```lua
  false
  ```



**Snippet to enable the language server:**
```lua
require'lspconfig'.clangd.setup{}
```
**Commands:**
- ClangdSwitchSourceHeader: Switch between source/header

**Default values:**
  - `capabilities` : 
  ```lua
  default capabilities, with offsetEncoding utf-8
  ```
  - `cmd` : 
  ```lua
  { "clangd" }
  ```
  - `filetypes` : 
  ```lua
  { "c", "cpp", "objc", "objcpp", "cuda", "proto" }
  ```
  - `root_dir` : 
  ```lua
          root_pattern(
            '.clangd',
            '.clang-tidy',
            '.clang-format',
            'compile_commands.json',
            'compile_flags.txt',
            'configure.ac',
            '.git'
          )
        
  ```
  - `single_file_support` : 
  ```lua
  true
  ```


**Snippet to enable the language server:**
```lua
require'lspconfig'.pyright.setup{}
```
**Commands:**
- PyrightOrganizeImports: Organize Imports

**Default values:**
  - `cmd` : 
  ```lua
  { "pyright-langserver", "--stdio" }
  ```
  - `filetypes` : 
  ```lua
  { "python" }
  ```
  - `root_dir` : 
  ```lua
  see source file
  ```
  - `settings` : 
  ```lua
  {
    python = {
      analysis = {
        autoSearchPaths = true,
        diagnosticMode = "workspace",
        useLibraryCodeForTypes = true
      }
    }
  }
  ```
  - `single_file_support` : 
  ```lua
  true
  ```

## rls

https://github.com/rust-lang/rls

rls, a language server for Rust

See https://github.com/rust-lang/rls#setup to setup rls itself.
See https://github.com/rust-lang/rls#configuration for rls-specific settings.
All settings listed on the rls configuration section of the readme
must be set under settings.rust as follows:

```lua
nvim_lsp.rls.setup {
  settings = {
    rust = {
      unstable_features = true,
      build_on_save = false,
      all_features = true,
    },
  },
}
```

If you want to use rls for a particular build, eg nightly, set cmd as follows:

```lua
cmd = {"rustup", "run", "nightly", "rls"}
```
    


**Snippet to enable the language server:**
```lua
require'lspconfig'.rls.setup{}
```


**Default values:**
  - `cmd` : 
  ```lua
  { "rls" }
  ```
  - `filetypes` : 
  ```lua
  { "rust" }
  ```
  - `root_dir` : 
  ```lua
  root_pattern("Cargo.toml")
  ```


## rust_analyzer

https://github.com/rust-analyzer/rust-analyzer

rust-analyzer (aka rls 2.0), a language server for Rust

See [docs](https://github.com/rust-analyzer/rust-analyzer/tree/master/docs/user#settings) for extra settings.
    


**Snippet to enable the language server:**
```lua
require'lspconfig'.rust_analyzer.setup{}
```
**Commands:**
- CargoReload: Reload current cargo workspace

**Default values:**
  - `cmd` : 
  ```lua
  { "rust-analyzer" }
  ```
  - `filetypes` : 
  ```lua
  { "rust" }
  ```
  - `root_dir` : 
  ```lua
  root_pattern("Cargo.toml", "rust-project.json")
  ```
  - `settings` : 
  ```lua
  {
    ["rust-analyzer"] = {}
  }
  ```

## rust_analyzer

https://github.com/rust-analyzer/rust-analyzer

rust-analyzer (aka rls 2.0), a language server for Rust

See [docs](https://github.com/rust-analyzer/rust-analyzer/tree/master/docs/user#settings) for extra settings.
    


**Snippet to enable the language server:**
```lua
require'lspconfig'.rust_analyzer.setup{}
```
**Commands:**
- CargoReload: Reload current cargo workspace

**Default values:**
  - `cmd` : 
  ```lua
  { "rust-analyzer" }
  ```
  - `filetypes` : 
  ```lua
  { "rust" }
  ```
  - `root_dir` : 
  ```lua
  root_pattern("Cargo.toml", "rust-project.json")
  ```
  - `settings` : 
  ```lua
  {
    ["rust-analyzer"] = {}
  }
  ```


