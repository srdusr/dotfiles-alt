local M = {}

--- Shorten Function Names
local fn = vim.fn
function M.executable(name)
  if fn.executable(name) > 0 then
    return true
  end

  return false
end


--------------------------------------------------

--- Check whether a feature exists in Nvim
--- @feat: string
---   the feature name, like `nvim-0.7` or `unix`.
--- return: bool
M.has = function(feat)
  if fn.has(feat) == 1 then
    return true
  end

  return false
end


--------------------------------------------------

---Determine if a value of any type is empty
---@param item any
---@return boolean?
function M.empty(item)
  if not item then return true end
  local item_type = type(item)
  if item_type == 'string' then return item == '' end
  if item_type == 'number' then return item <= 0 end
  if item_type == 'table' then return vim.tbl_isempty(item) end
  return item ~= nil
end

--------------------------------------------------

--- Create a dir if it does not exist
function M.may_create_dir(dir)
  local res = fn.isdirectory(dir)

  if res == 0 then
    fn.mkdir(dir, "p")
  end
end


--------------------------------------------------

--- Toggle cmp completion
vim.g.cmp_toggle_flag = false -- initialize
local normal_buftype = function()
  return vim.api.nvim_buf_get_option(0, "buftype") ~= "prompt"
end
M.toggle_completion = function()
  local ok, cmp = pcall(require, "cmp")
  if ok then
    local next_cmp_toggle_flag = not vim.g.cmp_toggle_flag
    if next_cmp_toggle_flag then
      print("completion on")
    else
      print("completion off")
    end
    cmp.setup({
      enabled = function()
        vim.g.cmp_toggle_flag = next_cmp_toggle_flag
        if next_cmp_toggle_flag then
          return normal_buftype
        else
          return next_cmp_toggle_flag
        end
      end,
    })
  else
    print("completion not available")
  end
end


--------------------------------------------------

--- Make sure using latest neovim version
function M.get_nvim_version()
  local actual_ver = vim.version()

  local nvim_ver_str = string.format("%d.%d.%d", actual_ver.major, actual_ver.minor, actual_ver.patch)
  return nvim_ver_str
end

function M.add_pack(name)
  local status, error = pcall(vim.cmd, "packadd " .. name)

  return status
end


--------------------------------------------------

--- Toggle autopairs on/off (requires "windwp/nvim-autopairs")
function M.Toggle_autopairs()
	local ok, autopairs = pcall(require, "nvim-autopairs")
	if ok then
		if autopairs.state.disabled then
			autopairs.enable()
			print("autopairs on")
		else
			autopairs.disable()
			print("autopairs off")
		end
	else
		print("autopairs not available")
	end
end

return M


--------------------------------------------------
