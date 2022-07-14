local ffi = require("code-editor.ffi")

FileSystem = {
  script_path = string.match(debug.getinfo(1, "S").source:sub(2), "(.*/)")
}

function FileSystem:read(file_path)
  local file_data = ""

  local is_file_path_full = string.sub(file_path, 2, 2) == ":"
  local full_file_path = is_file_path_full and file_path or self.script_path..file_path
  local file = io.open(full_file_path, "r")

  if file then
    file_data = file:read("*a")
    file:close()
  end

  return file_data
end

function FileSystem:write(file_path, data)
  if not data then
    return
  end

  local is_file_path_full = string.sub(file_path, 2, 2) == ":"
  local full_file_path = is_file_path_full and file_path or self.script_path..file_path
  local file = io.open(full_file_path, "w")

  file:write(data)
  file:close()
end

function FileSystem:mkdir(dir_path)
  local is_directory_path_full = string.sub(dir_path, 2, 2) == ":"
  local full_dir_path = is_directory_path_full and dir_path or self.script_path..dir_path
  
  ffi:create_directory_a(full_dir_path)
end

function FileSystem:is_directory(file_path)
  return ffi:is_directory(file_path)
end

function FileSystem:exists(file_path)
  local is_file_path_full = string.sub(file_path, 2, 2) == ":"
  local full_file_path = is_file_path_full and file_path or self.script_path..file_path
  local file_exists = ffi:get_file_attributes_a(full_file_path) ~= 4294967295

  local is_directory = self:is_directory(full_file_path)

  if not is_directory and file_exists then
    local file_data = self:read(full_file_path)
    file_exists = #file_data > 0
  end

  return file_exists
end

function sleep(condition)
  local iteration = 0
  while condition do
    if iteration > 5000 then break end
    iteration = iteration + 1
  end
end

function FileSystem:get_files_names_in_directory(dir_path)
  local is_directory_path_full = string.sub(dir_path, 2, 2) == ":"
  local full_dir_path = is_directory_path_full and dir_path or self.script_path..dir_path

  full_dir_path = string.sub(full_dir_path, -1, -1) == "/" and string.sub(full_dir_path, 1, -2) or full_dir_path
  local files_list_path = full_dir_path.."/files_list.txt"

  -- write all files names from directory to files_list.txt
  local command = 'dir "'..full_dir_path..'" /b > "'..files_list_path..'"'
  ffi:execute_command(command)

  while not self:exists(files_list_path) do end

  local files_names = {}

  for file_name in io.lines(files_list_path) do
    local file_path = full_dir_path.."/"..file_name

    if not self:is_directory(file_path) then
      table.insert(files_names, file_name)
    end
  end

  os.remove(files_list_path)

  return files_names
end

function FileSystem:get_files_names_in_directory_by_type(dir_path, file_type)
  file_type = string.sub(file_type, 1, 1) == "." and file_type or "."..file_type

  local configs_names = {}
  local files_names = self:get_files_names_in_directory(dir_path)
  
  for file_name_id = 1, #files_names do
    local file_name = files_names[file_name_id]
    local curr_file_type = string.sub(file_name, #file_type * -1)

    if curr_file_type == file_type then
      table.insert(configs_names, file_name)
    end
  end

  return configs_names
end

function FileSystem:get_file_lines(file_path)
  local lines = {}

  local is_file_path_full = string.sub(file_path, 2, 2) == ":"
  local full_file_path = is_file_path_full and file_path or self.script_path..file_path

  for line in io.lines(full_file_path) do
    table.insert(lines, line)
  end

  return lines
end

return FileSystem