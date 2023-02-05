local fn = vim.fn

--------------------------------------------------

-- Automatically install packer
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
	PACKER_BOOTSTRAP = fn.system({
		"git",
		"clone",
		"--depth",
		"1",
		"https://github.com/wbthomason/packer.nvim",
		install_path,
	})
	print("Installing packer close and reopen Neovim...")
	vim.cmd([[packadd packer.nvim]])
end

--------------------------------------------------

-- Autocommand that reloads neovim whenever you save this file
vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost pack.lua source <afile> | PackerSync
  augroup end
]])

--------------------------------------------------

-- Use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then
	return
end

--------------------------------------------------

-- Have packer use a popup window and set a maximum number of jobs
packer.init({
	auto_reload_compiled = true,
	--max_jobs = 90,
	display = {
		open_fn = function()
			return require("packer.util").float({ border = "rounded" })
		end,
	},
})

--------------------------------------------------

-- Install plugins here
return packer.startup(function(use)
  -- Defaults
	use("wbthomason/packer.nvim") -- Have packer manage itself
  use("nvim-lua/plenary.nvim") -- Useful lua functions used by lots of plugins
	use("lewis6991/impatient.nvim") -- Faster loading/startup times

  -- Tree-sitter
	use({ "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" }) -- For language parsing, examples: highlighting, folding, jumping, refactoring...
	use("nvim-treesitter/nvim-treesitter-refactor") -- Refactor module for nvim-treesitter

  -- lsp
  use("williamboman/mason.nvim") -- Package manager to install and manage LSP servers, DAP servers, linters and formatters
  use("williamboman/mason-lspconfig.nvim") -- Bridges mason.nvim with nvim-lspconfig to help use them together
  use("neovim/nvim-lspconfig") -- Collection of LSP configs
  --use {
  --  "williamboman/mason.nvim", -- Package manager to install and manage LSP servers, DAP servers, linters and formatters
  --  "williamboman/mason-lspconfig.nvim", -- Bridges mason.nvim with nvim-lspconfig to help use them together
  --  "neovim/nvim-lspconfig", -- Collection of LSP configs
  --}

  -- Debugger
	use("mfussenegger/nvim-dap") -- Debug Adapter Protocol client implementation for Neovim

	-- Linters/Formatters
  use({
		"jose-elias-alvarez/null-ls.nvim", -- Provides LSP: linters, formatters, diagnostics, code actions and etc...
		config = function()
			require("null-ls").setup()
		end,
		requires = { "nvim-lua/plenary.nvim" },
	})

	-- Completion
  use("hrsh7th/nvim-cmp")
	use("hrsh7th/cmp-nvim-lsp")
	use("hrsh7th/cmp-buffer")
	use("hrsh7th/cmp-path")
	use("hrsh7th/cmp-cmdline")
  use("petertriho/cmp-git")
	use("tamago324/cmp-zsh")
	use("f3fora/cmp-spell")
	use("hrsh7th/cmp-calc")
	use("saadparwaiz1/cmp_luasnip")
	use("hrsh7th/cmp-nvim-lsp-signature-help")
	use("onsails/lspkind-nvim")

	-- Snippets
	use("L3MON4D3/LuaSnip") -- Snippet engine
	use("rafamadriz/friendly-snippets") -- Collection of snippets to use

	-- Git
	use("dinhhuy258/git.nvim") -- For git blame & browse
  use("kdheepak/lazygit.nvim")
	use("lewis6991/gitsigns.nvim")

  -- File explorer/fuzzy finder
	use("kyazdani42/nvim-tree.lua")
	use('ibhagwan/fzf-lua') -- Fuzzy finder
	use("nvim-telescope/telescope.nvim")
	use({ "nvim-telescope/telescope-fzf-native.nvim", run = "make" })
	use("nvim-telescope/telescope-ui-select.nvim")
	use("nvim-telescope/telescope-media-files.nvim")
	use("nvim-telescope/telescope-file-browser.nvim")
	use({ "nvim-telescope/telescope-symbols.nvim", after = "telescope.nvim" }) -- Search emoji(s) and other symbols
	use("axkirillov/telescope-changed-files")

	-- UX
  use({
    'numToStr/Navigator.nvim', -- Navigate between Tmux and Nvim
    config = function()
        require('Navigator').setup()
    end,
  })
	use({ "tpope/vim-eunuch", cmd = { "Rename", "Delete" } }) -- Handy unix commands inside Vim (Rename, Move etc.)
	use("tpope/vim-fugitive")
	--use("tpope/vim-surround")
	--use("tpope/vim-obsession")
	--use("tpope/vim-unimpaired")
	--use("vimpostor/vim-tpipeline")
  use("nathom/filetype.nvim")
	use("myusuf3/numbers.vim")
	use("windwp/nvim-autopairs")
	use("numToStr/Comment.nvim")
	use("akinsho/toggleterm.nvim")
	use("tweekmonster/startuptime.vim")
	use({
	  "ggandor/leap.nvim",
	  config = function()
      require('leap').add_default_mappings()
	    --require("leap").set_default_keymaps()
      --vim.keymap.set('n', '-', '<Plug>(leap-forward)', {})
      --vim.keymap.set('n', '_', '<Plug>(leap-backward)', {})
	  end,
	})
  use({ "ggandor/flit.nvim",
    config = function()
      require("flit").setup()
    end,
  })
	use("folke/which-key.nvim")
	use("folke/zen-mode.nvim")
	use("romainl/vim-cool")
  use "antoinemadec/FixCursorHold.nvim"
  use("airblade/vim-rooter")
	--use("vim-test/vim-test")
	--use({
	--  "rcarriga/vim-ultest",
	--  requires = { "vim-test/vim-test" },
	--  run = ":UpdateRemotePlugins",
	--  config = function()
	--    require("plugins.ultest")
	--  end,
	--})

	-- Colorschemes
	use("gruvbox-community/gruvbox")
	use("srcery-colors/srcery-vim")
	use("tomasr/molokai")
	use("ayu-theme/ayu-vim")
	use("joshdick/onedark.vim")
	use("everblush/everblush.nvim")
	use("EdenEast/nightfox.nvim")
	use("bluz71/vim-nightfly-guicolors")
	use("jacoborus/tender.vim")
	use("sainnhe/sonokai")
	use("NTBBloodbath/doom-one.nvim")

  -- UI
	use("kyazdani42/nvim-web-devicons")
  --use("goolord/alpha-nvim")
	use("rcarriga/nvim-notify") -- Notification plugin
	use("karb94/neoscroll.nvim")
	use("MunifTanjim/prettier.nvim") -- Prettier plugin for Neovim's built-in LSP client
	use("norcalli/nvim-colorizer.lua")
  use({ "j-hui/fidget.nvim", -- UI to show nvim-lsp progress
    config = function()
      require("fidget").setup()
    end
  })
	use("rcarriga/nvim-dap-ui")
  use { "simrat39/symbols-outline.nvim",
    config = function()
      require("symbols-outline").setup({
        auto_close = true,
      })
    end
  }
  use { "kosayoda/nvim-lightbulb", requires = { "antoinemadec/FixCursorHold.nvim" } }
  use({
    "SmiteshP/nvim-navic", -- Statusline/Winbar component that uses LSP to show current code context
		requires = "neovim/nvim-lspconfig",
	})
  use({
    'rebelot/heirline.nvim', -- Statusline that is highly configurable
    requires = 'kyazdani42/nvim-web-devicons',
    event = 'VimEnter',
  })

  -- Language specific tools
  use "simrat39/rust-tools.nvim"
  use { "saecki/crates.nvim",
    requires = { "nvim-lua/plenary.nvim" },
    config = function()
      require("crates").setup()
    end,
  }
  use({
    "iamcco/markdown-preview.nvim", -- Markdown Preview
    run = function() vim.fn["mkdp#util#install"]() end,
  })
  use {"ellisonleao/glow.nvim", config = function() require("glow").setup() end} -- Markdown Preview

--------------------------------------------------

	-- Automatically set up your configuration after cloning packer.nvim
	-- Put this at the end after all plugins
	if PACKER_BOOTSTRAP then
		require("packer").sync()
	end
end)
