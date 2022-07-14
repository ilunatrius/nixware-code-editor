local variables_converter = require("code-editor.config.variables-converter")
local variables = require("code-editor.config.variables")
local file_system = require("code-editor.filesystem")

Config = {
  directory_path = "code-editor-configs"
}

function add_config_type(config_name)
  local has_type = string.sub(config_name, -4) == ".cfg"
  return has_type and config_name or config_name..".cfg"
end

function Config:create_configs_folder()
  file_system:mkdir(self.directory_path)
end

function Config:create_default_config()
  self:save("default")
end

function Config:initialize()
  self:create_configs_folder()
  self:create_default_config()
end

function Config:get()
  return variables
end

function Config:save(config_name)
  config_name = add_config_type(config_name)

  local full_file_path = self.directory_path.."/"..config_name
  local stringified_variables = variables_converter:to_string(variables)

  file_system:write(full_file_path, stringified_variables)
end

function Config:load(config_name)
  config_name = add_config_type(config_name)

  local full_file_path = self.directory_path.."/"..config_name
  local stringified_variables = file_system:read(full_file_path)

  if stringified_variables then
    local parsed_variables = variables_converter:from_string(stringified_variables)

    for name, value in pairs(parsed_variables) do
      variables[name] = value
    end
  end
end

return Config