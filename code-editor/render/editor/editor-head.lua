local renderer_helper = require("code-editor.render.renderer_helper")
local config = require("code-editor.config.config")

EditorHead = {
  width = 0,
  height = 0,
  minimal_width = 0,
  minimal_height = 0
}

function EditorHead:draw(text)
  local variables = config:get()

  local x_position = variables.editor_x_position
  local y_position = variables.editor_y_position
  local font_size = variables.editor_head_font_size
  local width = variables.editor_width
  local height = 15
  local head_foreground_color = variables.editor_head_foreground_color
  local head_background_color = variables.editor_head_background_color
  local outline_color = variables.editor_outline_color
  
  local text_start_offset = 10

  local font = renderer_helper:get_font(font_size)
  local text_size = renderer.get_text_size(font, font_size, text)
  local text_info = {text_size=text_size, text_start_offset=text_start_offset}

  local minimal_width = text_size.x + (text_start_offset*2)
  local minimal_height = text_size.y + 6

  self.minimal_width = minimal_width
  self.minimal_height = minimal_height

  width = math.max(minimal_width, width)
  height = math.max(minimal_height, height)
  
  self.width = width
  self.height = height

  local start_x_position = x_position
  local start_y_position = y_position
  local start_position = vec2_t.new(start_x_position, start_y_position)

  local end_x_position = start_x_position + width
  local end_y_position = start_y_position + height
  local end_position = vec2_t.new(end_x_position, end_y_position)

  local positions = {start_position, end_position}
  
  local text_x_position = (start_x_position + (width / 2)) - (text_size.x / 2)
  local text_y_position = start_y_position + ((height - text_size.y) / 2)
  local text_position = vec2_t.new(text_x_position, text_y_position)

  renderer_helper:draw_outlined_rect(positions, head_background_color, outline_color)
  renderer_helper:draw_text(text, text_position, font_size, head_foreground_color)
end

return EditorHead