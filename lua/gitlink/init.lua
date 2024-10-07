local M = {}

local config = {}

local augroup = vim.api.nvim_create_augroup("gitlink", { clear = true })

local function debug_print(...)
  if config.debug then
    print(...)
  end
end


function M.setup(user_config)
  -- Simple variant; could also be more complex with validation, etc.
  config = user_config

  -- config defaults

    local build_push = "build_push"
  harpoon = require('harpoon.tmux')

end


function M.find_commands_file()
  --check if .nvim dir exists in repo base dir
  --dont open just check if it exists
  -- if it does not then return false
  local handle = io.popen("find . -name " .. config.commands_dir_name)
  if handle == nil then
    return false
  end
  if handle:read("*a") == "" then
    return false
  end

  local handle = io.popen("find . -name " .. config.commands_file_name)
  if handle == nil then
    return false
  end
  if handle == "" then
    return false
  end
  handle:close()

  return true

end

return M

