local build_push = "build_push"
local build = "build"
local clean = "clean"
local clean_build="clean_build"
local follow_service = "follow_service"
local stop_service = "stop_service"
local start_service = "start_service"
local restart_service = "restart_service"
local ands = " && "
local nextop = "; "
local clear = "clear; "
local cmd = "cmd"
local desc = "desc"
local name = "name"

-- command strings
local main_service = 'canmanager'
local release_bin_path = '/home/nicholasmabe/framery_repos/supra2-radar-unit/application/framery-radar-unit-mss/Release/'
local version_file_path = '/home/nicholasmabe/framery_repos/supra2-radar-unit/application/framery-radar-unit-mss/mss/version_info.h'
local bin_name = 'framery_radar_unit.bin'
local build_mss_bin = '/home/nicholasmabe/framery_repos/deps/radar/ccs1200/ccs/eclipse/eclipse -noSplash -data /home/nicholasmabe/framery_repos/deps/workspaces/CodeComposerWorkspace/ -application com.ti.ccstudio.apps.projectBuild -ccs.autoImport -ccs.projects framery_radar_unit_mss -ccs.full -ccs.configuration Release | grep --color=always -e "^" -e "error " -e " error"'
local build_bss_bin = '/home/nicholasmabe/framery_repos/deps/radar/ccs1200/ccs/eclipse/eclipse -noSplash -data /home/nicholasmabe/framery_repos/deps/workspaces/CodeComposerWorkspace/ -application com.ti.ccstudio.apps.projectBuild -ccs.autoImport -ccs.projects framery_radar_unit_bss -ccs.full -ccs.configuration Release | grep --color=always -e "^" -e "error " -e " error"'
local get_fw_bin_name = 'python .neovim/inc_version.py ' .. version_file_path  .. ' --bin_name '
local no_bin_name = get_fw_bin_name .. ' | xargs -I {} echo {} | cut -d "." -f 1'
local zip_files = 'rm supra*.zip; ' .. no_bin_name .. ' | xargs -I {} zip -r {}.zip ' .. release_bin_path .. '{}.bin'
local push_files = 'adb push ' .. release_bin_path .. 'supra*.bin' .. ' /lib/firmware/'
local clean_device_bin = 'adb shell "rm /lib/firmware/supra*.bin"'
local clean_fw_bin = 'rm ' .. release_bin_path .. 'supra*.bin'
local rename_bin = get_fw_bin_name .. ' | xargs -I {} mv ' .. release_bin_path .. bin_name .. ' ' .. release_bin_path .. '{}'
local stop_main_service = 'adb shell "systemctl stop ' .. main_service .. '"'
local stop_main_service_bg = 'adb shell "systemctl stop ' .. main_service .. ' &"'
local start_main_service = 'adb shell "systemctl start ' .. main_service .. '"'
local clean_mss_files = '/home/nicholasmabe/framery_repos/deps/radar/ccs1200/ccs/eclipse/eclipse -noSplash -data /home/nicholasmabe/framery_repos/deps/workspaces/CodeComposerWorkspace/ -application com.ti.ccstudio.apps.projectBuild -ccs.autoImport -ccs.projects framery_radar_unit_mss -ccs.clean | grep --color=always -e "^" -e "error " -e " error"'
local clean_bss_files = '/home/nicholasmabe/framery_repos/deps/radar/ccs1200/ccs/eclipse/eclipse -noSplash -data /home/nicholasmabe/framery_repos/deps/workspaces/CodeComposerWorkspace/ -application com.ti.ccstudio.apps.projectBuild -ccs.autoImport -ccs.projects framery_radar_unit_mss -ccs.clean | grep --color=always -e "^" -e "error " -e " error"'
local clean_files = clean_mss_files .. nextop .. clean_bss_files .. nextop .. clean_fw_bin
local inc_version = 'python .neovim/inc_version.py ' .. version_file_path .. ' '


local commands = {
  ["3"] = {
    ["1"]={
      [cmd]='clear; ' .. stop_main_service_bg .. ands .. clean_fw_bin .. nextop .. inc_version .. ands .. build_mss_bin .. ands .. clean_device_bin .. nextop .. rename_bin .. ands .. push_files .. ands .. start_main_service .. ands .. zip_files,
      [desc]='Build and push the ' .. bin_name .. ' to the device',
      [name]=build_push,
    },
    ["2"] = {
      [cmd]='clear; ' .. clean_fw_bin .. nextop .. inc_version .. ands .. build_mss_bin .. ands .. rename_bin .. ands .. zip_files,
      [desc]='Build the ' .. bin_name .. '',
      [name]=build,
    },

    ["3"] = {
        [cmd]=clear .. clean_files,
        [desc]='Clean the build files',
        [name]=clean,
    },
    ["4"] = {
      [cmd]=clear .. clean_files .. ands .. build_mss_bin,
      [desc]='Clean and rebuild the ' .. main_service,
      [name]=clean_build,
    },
    ["5"] = {
      [cmd]='adb shell "journalctl -fu ' .. main_service .. '.service"',
      [desc]='Follow the ' ..main_service.. ' journal logs',
      [name]=follow_service,
    },
    ["6"] = {
      [cmd]=stop_main_service,
      [desc]='Stop the ' .. main_service .. ' service',
      [name]=stop_service,
    },
    ["7"] = {
      [cmd]=start_main_service,
      [desc]='Start the ' .. main_service .. ' service',
      [name]=start_service,
    },
    ["8"] = {
      [cmd]=stop_main_service .. ands .. start_main_service,
      [desc]='Restart the ' .. main_service .. ' service',
      [name]=restart_service,
    },
    ["9"] = {
      [cmd]='clear; ' .. stop_main_service_bg .. ands .. clean_fw_bin .. nextop .. build_mss_bin .. ands .. clean_device_bin .. nextop .. rename_bin .. ands .. push_files .. ands .. start_main_service .. ands .. zip_files,
      [desc]='Build, push, without incrementing version',
      [name]='release_build_push',
    },

  },

}

commands["2"] = commands["3"]

return commands

