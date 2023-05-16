return {
  {
    "L3MON4D3/LuaSnip",
    opts = {
      history = true,
      -- Allow autotrigger snippets
      enable_autosnippets = true,
      -- For equivalent of UltiSnips visual selection
      store_selection_keys = "<Tab>",
      -- Event on which to check for exiting a snippet's region
      region_check_events = "InsertEnter",
      -- ejmastnak uses InsertLeave, perhaps because he has history=false
      delete_check_events = "TextChanged",
      -- When to trigger update of active nodes' dependents, e.g. repeat nodes
      update_events = "TextChanged,TextChangedI",
    },
    config = function(_, opts)
      require("luasnip").setup(opts)
      -- TODO: better way to detect this relative to config dir?
      require("luasnip.loaders.from_lua").load({ paths = "~/.config/nvim/snippets/" })
    end,
  },
}
