local file_system = require("code-editor.filesystem")
local config = require("code-editor.config.config")
local text_colors = require("code-editor.text-colors.text-colors")
local notifications = require("code-editor.render.notifications")
local editor = require("code-editor.render.editor.editor")

UI = {
  current_files_path = file_system.script_path,
  text_colors_files_names = {},
  configs_names = {},
  files_names = {}
}

function UI:show_main(show)
  self.editor_files_list:set_visible(show)
  self.load_file_data_button:set_visible(show)
  self.custom_directory_path_input:set_visible(show)
  self.load_directory_files_button:set_visible(show)
end

function UI:show_editor(show)
  self.editor_head_font_size:set_visible(show)
  self.editor_body_font_size:set_visible(show)
  self.editor_offset:set_visible(show)
  self.editor_head_foreground_color:set_visible(show)
  self.editor_head_background_color:set_visible(show)
  self.editor_body_foreground_color:set_visible(show)
  self.editor_body_background_color:set_visible(show)
  self.editor_outline_color:set_visible(show)
end

function UI:show_notifications(show)
  self.notification_align:set_visible(show)
  self.notification_animated_alpha:set_visible(show)
  self.notification_font_size:set_visible(show)
  self.notification_width:set_visible(show)
  self.notification_height:set_visible(show)
  self.notification_offset:set_visible(show)
  self.notification_display_time:set_visible(show)
  self.notification_foreground_color:set_visible(show)
  self.notification_background_color:set_visible(show)
  self.notification_outline_color:set_visible(show)
end

function UI:show_colors(show)
  self.text_colors_files:set_visible(show)
  self.load_text_colors_button:set_visible(show)
  self.refresh_text_colors_button:set_visible(show)
  self.text_colors_file_input:set_visible(show)
  self.text_colors_file_create_button:set_visible(show)
end

function UI:show_config(show)
  self.configs:set_visible(show)
  self.load_button:set_visible(show)
  self.save_button:set_visible(show)
  self.refresh_button:set_visible(show)
  self.config_input:set_visible(show)
  self.create_button:set_visible(show)
end

function UI:show_items()
  local category = self.categories:get_value()
  
  self:show_main(category == 0)
  self:show_editor(category == 1)
  self:show_notifications(category == 2)
  self:show_colors(category == 3)
  self:show_config(category == 4)
end

function convert_color_to_array(clr)
  return {clr.r, clr.g, clr.b, clr.a}
end

function convert_array_to_color(clr)
  return color_t.new(clr[1], clr[2], clr[3], clr[4])
end

function UI:update_config_variables()
  local converted_editor_head_foreground_color = convert_color_to_array(self.editor_head_foreground_color:get_value())
  local converted_editor_head_background_color = convert_color_to_array(self.editor_head_background_color:get_value())
  local converted_editor_body_foreground_color = convert_color_to_array(self.editor_body_foreground_color:get_value())
  local converted_editor_body_background_color = convert_color_to_array(self.editor_body_background_color:get_value())
  local converted_editor_outline_color = convert_color_to_array(self.editor_outline_color:get_value())

  config:get().editor_head_font_size = self.editor_head_font_size:get_value()
  config:get().editor_body_font_size = self.editor_body_font_size:get_value()
  config:get().editor_offset = self.editor_offset:get_value()
  config:get().editor_head_foreground_color = converted_editor_head_foreground_color
  config:get().editor_head_background_color = converted_editor_head_background_color
  config:get().editor_body_foreground_color = converted_editor_body_foreground_color
  config:get().editor_body_background_color = converted_editor_body_background_color
  config:get().editor_outline_color = converted_editor_outline_color

  local converted_notification_foreground_color = convert_color_to_array(self.notification_foreground_color:get_value())
  local converted_notification_background_color = convert_color_to_array(self.notification_background_color:get_value())
  local converted_notification_outline_color = convert_color_to_array(self.notification_outline_color:get_value())
 
  config:get().notification_align = self.notification_align:get_value()
  config:get().notification_animated_alpha = self.notification_animated_alpha:get_value()
  config:get().notification_font_size = self.notification_font_size:get_value()
  config:get().notification_width = self.notification_width:get_value()
  config:get().notification_height = self.notification_height:get_value()
  config:get().notification_offset = self.notification_offset:get_value()
  config:get().notification_display_time = self.notification_display_time:get_value()
  config:get().notification_foreground_color = converted_notification_foreground_color
  config:get().notification_background_color = converted_notification_background_color
  config:get().notification_outline_color = converted_notification_outline_color
end

function UI:update_ui_items()
  local converted_editor_head_foreground_color = convert_array_to_color(config:get().editor_head_foreground_color)
  local converted_editor_head_background_color = convert_array_to_color(config:get().editor_head_background_color)
  local converted_editor_body_foreground_color = convert_array_to_color(config:get().editor_body_foreground_color)
  local converted_editor_body_background_color = convert_array_to_color(config:get().editor_body_background_color)
  local converted_editor_outline_color = convert_array_to_color(config:get().editor_outline_color)

  self.editor_head_font_size:set_value(config:get().editor_head_font_size) 
  self.editor_body_font_size:set_value(config:get().editor_body_font_size)
  self.editor_offset:set_value(config:get().editor_offset)
  self.editor_head_foreground_color:set_value(converted_editor_head_foreground_color)
  self.editor_head_background_color:set_value(converted_editor_head_background_color)
  self.editor_body_foreground_color:set_value(converted_editor_body_foreground_color)
  self.editor_body_background_color:set_value(converted_editor_body_background_color)
  self.editor_outline_color:set_value(converted_editor_outline_color)

  local converted_notification_foreground_color = convert_array_to_color(config:get().notification_foreground_color)
  local converted_notification_background_color = convert_array_to_color(config:get().notification_background_color)
  local converted_notification_outline_color = convert_array_to_color(config:get().notification_outline_color)
  
  self.notification_align:set_value(config:get().notification_align)
  self.notification_animated_alpha:set_value(config:get().notification_animated_alpha)
  self.notification_font_size:set_value(config:get().notification_font_size)
  self.notification_width:set_value(config:get().notification_width)
  self.notification_height:set_value(config:get().notification_height)
  self.notification_offset:set_value(config:get().notification_offset)
  self.notification_display_time:set_value(config:get().notification_display_time)
  self.notification_foreground_color:set_value(converted_notification_foreground_color)
  self.notification_background_color:set_value(converted_notification_background_color)
  self.notification_outline_color:set_value(converted_notification_outline_color)
end

function has_value(tbl, value)
  for i = 1, #tbl do
    if tbl[i] == value then
      return true
    end
  end

  return false
end

function UI:load_text_colors()
  self.load_text_colors_button:set_value(false)
  
  local text_colors_file_id = self.text_colors_files:get_value()
  local text_colors_file_name = self.text_colors_files_names[text_colors_file_id+1]
  local text_colors_file_path = text_colors.directory_path.."/"..text_colors_file_name

  if file_system:exists(text_colors_file_path) then
    text_colors:load(text_colors_file_name)
    notifications:add("color file "..text_colors_file_name.." was loaded!")
  end
end

function UI:refresh_text_colors()
  self.refresh_text_colors_button:set_value(false)

  local text_colors_files_names = file_system:get_files_names_in_directory_by_type(text_colors.directory_path, "color")

  self.text_colors_files_names = text_colors_files_names
  self.text_colors_files:set_items(text_colors_files_names)
  self.text_colors_files:set_value(0)

  notifications:add("colors files list was updated!")
end

function UI:create_text_colors_file()
  self.text_colors_file_create_button:set_value(false)

  local text_colors_file_name = self.text_colors_file_input:get_value()
  local text_colors_file_name_exists = #text_colors_file_name > 0
  local text_colors_file_name_not_in_table = not has_value(self.configs_names, text_colors_file_name..".color")

  if text_colors_file_name_exists and text_colors_file_name_not_in_table then
    text_colors:save(text_colors_file_name)

    table.insert(self.text_colors_files_names, text_colors_file_name..".color")
    self.text_colors_files:set_items(self.text_colors_files_names)

    notifications:add("color file "..text_colors_file_name.." was created!")
  end
end

function UI:load_config()
  self.load_button:set_value(false)
  
  local config_id = self.configs:get_value()
  local config_name = self.configs_names[config_id+1]
  local config_path = config.directory_path.."/"..config_name

  if file_system:exists(config_path) then
    config:load(config_name)
    self:update_ui_items()
    notifications:add("config "..config_name.." was loaded!")
  end
end

function UI:save_config()
  self.save_button:set_value(false)
  
  local config_id = self.configs:get_value()
  local config_name = self.configs_names[config_id+1]

  config:save(config_name)
  notifications:add("config "..config_name.." was saved!")
end

function UI:refresh_configs()
  self.refresh_button:set_value(false)

  local configs_names = file_system:get_files_names_in_directory_by_type(config.directory_path, "cfg")

  self.configs_names = configs_names
  self.configs:set_items(configs_names)
  self.configs:set_value(0)

  notifications:add("configs list was updated!")
end

function UI:create_config()
  self.create_button:set_value(false)

  local config_name = self.config_input:get_value()
  local config_name_exists = #config_name > 0
  local config_name_not_in_table = not has_value(self.configs_names, config_name..".cfg")

  if config_name_exists and config_name_not_in_table then
    config:save(config_name)

    table.insert(self.configs_names, config_name..".cfg")
    self.configs:set_items(self.configs_names)

    notifications:add("config "..config_name.." was created!")
  end
end

function UI:load_file_data()
  self.load_file_data_button:set_value(false)
  
  local file_id = self.editor_files_list:get_value()
  local file_name = self.files_names[file_id+1]
  local file_path = self.current_files_path.."/"..file_name
  local file_exists = file_system:exists(file_path)
  
  if file_exists then
    editor.file_name = file_name
    editor.file_path = file_path

    notifications:add(file_name.." data was loaded!")
  else
    notifications:add(file_name.." does not exists!")
  end
end

function UI:load_directory_files()
  self.load_directory_files_button:set_value(false)

  local custom_directory_path = self.custom_directory_path_input:get_value()
  custom_directory_path = #custom_directory_path > 3 and custom_directory_path or self.current_files_path
  
  local is_directory_path_full = string.sub(custom_directory_path, 2, 2) == ":"
  custom_directory_path = is_directory_path_full and custom_directory_path or file_system.script_path..custom_directory_path

  local path_exists = file_system:is_directory(custom_directory_path)

  if path_exists then
    local directory_files = file_system:get_files_names_in_directory(custom_directory_path)
    
    self.files_names = directory_files
    self.current_files_path = custom_directory_path

    self.editor_files_list:set_items(self.files_names)
    self.editor_files_list:set_value(0)

    notifications:add("directory files was loaded!")
  else
    notifications:add("path does not exists! ("..custom_directory_path..")")
  end
end

function UI:handle()
  self:show_items()

  if self.load_text_colors_button:get_value() then
    self:load_text_colors()
  end

  if self.refresh_text_colors_button:get_value() then
    self:refresh_text_colors()
  end

  if self.text_colors_file_create_button:get_value() then
    self:create_text_colors_file()
  end

  if self.load_button:get_value() then
    self:load_config()
  end

  if self.save_button:get_value() then
    self:save_config()
  end

  if self.refresh_button:get_value() then
    self:refresh_configs()
  end

  if self.create_button:get_value() then
    self:create_config()
  end

  if self.load_file_data_button:get_value() then
    self:load_file_data()
  end

  if self.load_directory_files_button:get_value() then
    self:load_directory_files()
  end

  self:update_config_variables()
end

return UI