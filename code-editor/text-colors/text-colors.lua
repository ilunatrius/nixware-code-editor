local variables_converter = require("code-editor.config.variables-converter")
local text_color_variables = require("code-editor.text-colors.text-color-variables")
local file_system = require("code-editor.filesystem")

TextColors = {
  directory_path = "code-editor-text-colors"
}

function add_color_type(text_colors_file_name)
  local has_type = string.sub(text_colors_file_name, -6) == ".color"
  return has_type and text_colors_file_name or text_colors_file_name..".color"
end

function TextColors:create_colors_folder()
  file_system:mkdir(self.directory_path)
end

function TextColors:create_default_config()
  self:save("default")
end

function TextColors:initialize()
  self:create_colors_folder()
  self:create_default_config()
end

function TextColors:get()
  return text_color_variables
end

function TextColors:save(text_colors_file_name)
  text_colors_file_name = add_color_type(text_colors_file_name)

  local full_file_path = self.directory_path.."/"..text_colors_file_name
  local stringified_variables = variables_converter:to_string(text_color_variables)

  file_system:write(full_file_path, stringified_variables)
end

function TextColors:load(text_colors_file_name)
  text_colors_file_name = add_config_type(text_colors_file_name)

  local full_file_path = self.directory_path.."/"..text_colors_file_name
  local stringified_variables = file_system:read(full_file_path)

  if stringified_variables then
    local parsed_variables = variables_converter:from_string(stringified_variables)

    for name, value in pairs(parsed_variables) do
      text_color_variables[name] = value
    end
  end
end

return TextColors