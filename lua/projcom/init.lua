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
    local name = "name"


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

  if M.is_in_repo() then
    local repo_name = M.get_repo_name()
    --check if .config commands file exists
    -- need one dir up from standard path

    local global_path = config.global_path or vim.fn.expand('$HOME/.config/projcom')
    debug_print("Global Path: " .. global_path)
    
    local commands = nil

    if  M.find_commands_file() then
      debug_print("We are in a repo")
      commands = M.load_commands()
    elseif M.find_command_file_in_global_dir(global_path, repo_name) then
      debug_print("We are in a repo")
      debug_print("Repo Name: " .. repo_name)
      commands = M.get_commands_from_global_dir(global_path, repo_name)
    end
    if commands then
      for screen_index, screen_value in pairs(commands) do
        debug_print("Screen Index: " .. screen_index)

        -- set up some default commands for every pane
        vim.keymap.set('n', "<leader>" .. screen_index .. "w", function()
          harpoon.sendCommand(screen_index, "clear\n")
        end, { desc = "clear pane " .. screen_index })

        vim.keymap.set('n', "<leader>" .. screen_index .. "q", function()
          harpoon.sendCommand(screen_index, "C-c")
        end, { desc = "clober pane " .. screen_index })

        for bnd_key, cmd_info in pairs(commands[screen_index]) do
          debug_print("Key: " .. bnd_key)
          debug_print("Cmd Info: " .. vim.inspect(cmd_info))

          vim.keymap.set('n', "<leader>" .. screen_index .. bnd_key, function()
            harpoon.sendCommand(screen_index, "C-c")
            harpoon.sendCommand(screen_index, cmd_info[command_string] .. "\n")
          end, { desc = cmd_info[description] })
        end
      end
    end
  end
    --vim.api.nvim_create_autocmd("VimEnter", { group = augroup, desc = "find out if im in a repo", once = true, callback = M.main })

end


function M.find_command_file_in_global_dir(global_path, repo_name)
  local handle = io.popen("find " .. global_path .. " -name " .. repo_name .. ".lua")
  if handle == nil then
    debug_print("Handle for find command file in global dir is nil")
    return false
  end
  if handle:read("*a") == "" then
    debug_print("Handle for find command file in global dir is empty:" .. global_path .. " -name " .. repo_name .. ".lua"  )
    return false
  end
  handle:close()
  debug_print("Handle for find command file in global dir is not empty")
  return true
end

function M.get_commands_from_global_dir(global_path, repo_name)
  local cmds_path = global_path .. "/" .. repo_name .. ".lua"
  local commands = dofile(cmds_path)--.commands
  debug_print("Commands: " .. vim.inspect(commands))
  return commands
end


function M.find_commands_file()
  --check if .nvim dir exists in repo base dir
  --dont open just check if it exists
  -- if it does not then return false
  local handle = io.popen("find -maxdepth 3 . -name " .. config.commands_dir_name)
  if handle == nil then
    return false
  end
  if handle:read("*a") == "" then
    return false
  end

  local handle = io.popen("find -maxdepth 3 . -name " .. config.commands_file_name)
  if handle == nil then
    return false
  end
  if handle == "" then
    return false
  end
  handle:close()

  return true

end

function M.get_repo_name()
  -- get the name of the repo
  local handle = io.popen("git remote -v")
  local result = handle:read("*a")
  handle:close()
  local repo_name = ""
  -- capture only the name from the command result
  -- example: project from /project.git (fetch)
  local match_str = "/(.*)%.git %(fetch%)"
  _, _, repo_name = string.find(result, match_str)

  if repo_name ~= nil then
    debug_print("Git Repo Name: " .. repo_name)
    return repo_name
  end

  local match_str_codecommit = ".*/(.*)% %(fetch%)"
  _, _, repo_name = string.find(result, match_str_codecommit)

  if repo_name ~= nil then
    debug_print("CodeCommit Repo Name: " .. repo_name)
    return repo_name
  end

  return repo_name
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

