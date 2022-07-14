local script_path = string.match(debug.getinfo(1, "S").source:sub(2), "(.*/)")
package.path = package.path .. script_path .. "?.lua;"

local config = require("code-editor.config.config")
local text_colors = require("code-editor.text-colors.text-colors")
local ui_handler = require("code-editor.ui-handler")
local notifications = require("code-editor.render.notifications")
local editor = require("code-editor.render.editor.editor")

-- because we cant (or i dont know how) create ui elements in other files
ui_handler.categories = ui.add_combo_box("Categories", "code_editor_categories", {"Main", "Editor", "Notifications", "Colors", "Config"}, 4)

ui_handler.editor_files_list = ui.add_combo_box("File To Open", "editor_files_list", {}, 0)
ui_handler.load_file_data_button = ui.add_check_box("Load File Data", "load_file_data_button", false)
ui_handler.custom_directory_path_input = ui.add_text_input("Custom Directory Path", "custom_directory_path_input", "")
ui_handler.load_directory_files_button = ui.add_check_box("Load Directory Files", "load_directory_files_button", false)

ui_handler.editor_head_font_size = ui.add_slider_int("Editor Head Font Size", "editor_head_font_size", 8, 32, 16)
ui_handler.editor_body_font_size = ui.add_slider_int("Editor Body Font Size", "editor_body_font_size", 8, 32, 16)
ui_handler.editor_offset = ui.add_slider_int("Editor Offset", "editor_offset", 1, 20, 5)
ui_handler.editor_head_foreground_color = ui.add_color_edit("Editor Head Foreground", "editor_head_foreground_color", false, color_t.new(255, 255, 255, 255))
ui_handler.editor_head_background_color = ui.add_color_edit("Editor Head Background", "editor_head_background_color", true, color_t.new(44, 44, 44, 255))
ui_handler.editor_body_foreground_color = ui.add_color_edit("Editor Body Foreground", "editor_body_foreground_color", false, color_t.new(255, 255, 255, 255))
ui_handler.editor_body_background_color = ui.add_color_edit("Editor Body Background", "editor_body_background_color", true, color_t.new(44, 44, 44, 255))
ui_handler.editor_outline_color = ui.add_color_edit("Editor Outline", "editor_outline_color", false, color_t.new(255, 255, 255, 255))

ui_handler.notification_align = ui.add_combo_box("Notification Align", "code_editor_notification_align", { "Left", "Center", "Right" }, 0)
ui_handler.notification_animated_alpha = ui.add_check_box("Notification Animated Alpha", "code_editor_notification_animated_alpha", true)
ui_handler.notification_font_size = ui.add_slider_int("Notification Font Size", "code_editor_notification_font_size", 8, 32, 16)
ui_handler.notification_width = ui.add_slider_int("Notification Width", "code_editor_notification_width", 10, 1200, 300)
ui_handler.notification_height = ui.add_slider_int("Notification Height", "code_editor_notification_height", 5, 30, 10)
ui_handler.notification_offset = ui.add_slider_int("Notification Offset", "code_editor_notification_offset", 1, 20, 5)
ui_handler.notification_display_time = ui.add_slider_float("Notification Display Time", "code_editor_notification_display_time", 0.5, 8, 3)
ui_handler.notification_foreground_color = ui.add_color_edit("Notification Foreground", "code_editor_notification_foreground_color", false, color_t.new(255, 255, 255, 255))
ui_handler.notification_background_color = ui.add_color_edit("Notification Background", "code_editor_notification_background_color", true, color_t.new(44, 44, 44, 255))
ui_handler.notification_outline_color = ui.add_color_edit("Notification Outline", "code_editor_notification_outline_color", true, color_t.new(0, 0, 0, 255))

ui_handler.text_colors_files = ui.add_combo_box("", "code_editor_text_colors_files", {}, 0)
ui_handler.load_text_colors_button = ui.add_check_box("Load Text Colors", "code_editor_load_text_colors", false)
ui_handler.refresh_text_colors_button = ui.add_check_box("Refresh Text Colors Files", "code_editor_refresh_text_colors", false)
ui_handler.text_colors_file_input = ui.add_text_input("New Text Colors File Name", "code_editor_text_colors_file_input", "")
ui_handler.text_colors_file_create_button = ui.add_check_box("Create And Save Colors File", "code_editor_text_colors_file_create_button", false)

ui_handler.configs = ui.add_combo_box("", "code_editor_configs", {}, 0)
ui_handler.load_button = ui.add_check_box("Load Config", "code_editor_load", false)
ui_handler.save_button = ui.add_check_box("Save Config", "code_editor_save", false)
ui_handler.refresh_button = ui.add_check_box("Refresh Configs", "code_editor_refresh", false)
ui_handler.config_input = ui.add_text_input("New Editor Config Name", "code_editor_config_input", "")
ui_handler.create_button = ui.add_check_box("Create And Save Config", "code_editor_create", false)
---------------------------------------------------------------------------

local main = function ()
  config:initialize()
  text_colors:initialize()

  ui_handler:refresh_configs()
  ui_handler:refresh_text_colors()
  ui_handler:load_directory_files()
  
  client.register_callback("paint", function ()
    if ui.is_visible() then
      ui_handler:handle()
      editor:draw()
    end

    notifications:draw()
  end)
end

main()