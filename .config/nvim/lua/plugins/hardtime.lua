local hardtime = require('hardtime')

-- Function to toggle the hardtime state and echo a message
local hardtime_enabled = true

function ToggleHardtime()
  hardtime.toggle()
  hardtime_enabled = not hardtime_enabled
  local message = hardtime_enabled and 'hardtime on' or 'hardtime off'
  vim.cmd('echo "' .. message .. '"')
end

hardtime.setup({
  -- hardtime config here
  disabled_filetypes = { 'qf', 'netrw', 'NvimTree', 'lazy', 'mason', 'oil', 'dashboard' },
})

return {
  ToggleHardtime = ToggleHardtime,
}
