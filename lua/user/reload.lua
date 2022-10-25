--function _G.ReloadConfig()
--  for name,_ in pairs(package.loaded) do
--    if name:match('^lua') and not name:match('nvim-tree') then
--      package.loaded[name] = nil
--    end
--  end
--
--  dofile(vim.env.MYVIMRC)
--  vim.notify("Nvim configuration reloaded!", vim.log.levels.INFO)
--end
--function _G.ReloadConfig()
  --dofile(vim.env.MYVIMRC)
 -- dofile(vim.fn.stdpath('config') .. '/init.lua')
    --dofile(vim.fn.stdpath('user') .. '/init.lua')
 -- require("plenary.reload").reload_module("user", true)
  --dofile("/home/sxrdusr/.config/nvim/lua/user/keys.lua")
  --dofile("/home/sxrdusr/.config/nvim/lua/user/mods.lua")
  --dofile("/home/sxrdusr/.config/nvim/lua/user/opts.lua")
  --dofile("/home/sxrdusr/.config/nvim/lua/user/pack.lua")
  --dofile("/home/sxrdusr/.config/nvim/lua/user/utils.lua")
  --vim.notify("Nvim configuration reloaded!", vim.log.levels.INFO)
--end
--P = function(v)
--  print(vim.inspect(v))
--  return v
--end
--
--if pcall(require, "plenary") then
--  RELOAD = require("plenary.reload").reload_module
--
--  R = function(name)
--    RELOAD(name)
--    return require(name)
--  end
--end
-- r = reload vimrc


local M = {}

M['unload_lua_namespace'] = function(prefix)
  local prefix_with_dot = prefix .. '.'
  for key, value in pairs(package.loaded) do
    if key == prefix or key:sub(1, #prefix_with_dot) == prefix_with_dot then
      package.loaded[key] = nil
    end
  end
end

return M
