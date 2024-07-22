local M = {}

local config = {}

local augroup = vim.api.nvim_create_augroup("projcom", { clear = true })

local harpoon = nil


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
    local build = "build"
    local clean = "clean"
    local clean_build="clean_build"
    local follow_service = "follow_service"
    local stop_service = "stop_service"
    local start_service = "start_service"
    local restart_service = "restart_service"
    local command_string = "cmd"
    local description = "desc"


  local standard_cmds = {
    build_push,
    build,
    clean,
    clean_build,
    follow_service,
    stop_service,
    start_service,
    restart_service
}
  
  config.debug = config.debug or false
  config.commands_dir_name = config.commands_dir_name or ".neovim"
  config.commands_file_name = config.commands_file_name or "commands.lua"

  harpoon = require('harpoon.tmux')

  local in_repo = M.is_in_repo()
  if in_repo and M.find_commands_file() then
    debug_print("We are in a repo")
    local commands = M.load_commands()
    if commands then

      vim.keymap.set('n', "<leader>1q", function()
        harpoon.sendCommand("3", "C-c")
      end, { desc = "clober pane 3" })

      for screen_index, screen_value in pairs(commands) do
        debug_print("Screen Index: " .. screen_index)
        for std_command_key, std_command_value in pairs(standard_cmds) do
          debug_print("Key: " .. std_command_key .. " Value: " .. std_command_value)
          if commands[screen_index][std_command_value] then
            debug_print("We have a " .. std_command_value .. " command")
            debug_print("Command: " .. commands[screen_index][std_command_value][command_string])
            debug_print("Description: " .. commands[screen_index][std_command_value][description])
            vim.keymap.set('n', "<leader>1" .. std_command_key, function()
              harpoon.sendCommand(screen_value, "C-c")
              harpoon.sendCommand(screen_value, commands[screen_index][std_command_value][command_string] .. "\n")
            end, { desc = commands[screen_index][std_command_value][description] })
          end
        end
      end
    end

 end
  --vim.api.nvim_create_autocmd("VimEnter", { group = augroup, desc = "find out if im in a repo", once = true, callback = M.main })

end


function M.do_somthing()
   local option_x = config.option_x or 'som_default_value'
   -- ...
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

function M.load_commands()

  -- now load the table of commands
  -- should be a table with the functional name as the key and the command as the value
  -- example:
  -- commands = {
  --  ["run_tests "] = "pytest",
  --  ["run_linter"] = "mypy",
  --  }
  
  --get the explicit complete path to the commands file
  -- local handle = io.popen("find . -name " .. config.commands_dir_name .. "/" .. config.commands_file_name)
  debug_print("find . -name " .. config.commands_dir_name .. "/" .. config.commands_file_name)
  local cmds_path = vim.fn.getcwd() .. "/" .. config.commands_dir_name .. "/" .. config.commands_file_name
  -- package.path = package.path .. ";" .. cmds_path
  local commands = dofile(cmds_path)--.commands
  debug_print("Commands: " .. vim.inspect(commands))
  return commands
end

function M.is_in_repo()
  -- find if we are in a git repo by running git status
  local handle = io.popen("git status 2>&1")
  -- check if handle is nil
  if handle == nil then
    return false
  end
  local result = handle:read("*a")
  handle:close()
  if string.match(result, "fatal: not a git repository") then
    return false
  else
    return true
  end
end


function M.main()
  debug_print("Hello from our plugin")
end
return M

