local renderer_helper = require("code-editor.render.renderer_helper")
local config = require("code-editor.config.config")
local editor_head = require("code-editor.render.editor.editor-head")
local editor_text = require("code-editor.render.editor.editor-text")
local editor_scroll_bar = require("code-editor.render.editor.editor-scroll-bar")
local additional = require("code-editor.render.editor.additional")

EditorBody = {
  start_position = vec2_t.new(0, 0),
  end_position = vec2_t.new(0, 0)
}

function EditorBody:draw(file_path)
  local variables = config:get()

  local x_position = variables.editor_x_position
  local y_position = variables.editor_y_position
  local offset = variables.editor_offset
  local width = variables.editor_width
  local height = variables.editor_height
  local body_background_color = variables.editor_body_background_color
  local outline_color = variables.editor_outline_color

  local start_x_position = x_position
  local start_y_position = y_position + editor_head.height + offset
  local start_position = vec2_t.new(start_x_position, start_y_position)

  local end_x_position = start_x_position + width
  local end_y_position = start_y_position + height
  local end_position = vec2_t.new(end_x_position, end_y_position)

  self.start_position = start_position
  self.end_position = end_position

  local positions = {start_position, end_position}

  local extended_corner_start_position = vec2_t.new(end_position.x - 12, end_position.y - 12)
  local extended_corner_end_position = vec2_t.new(end_position.x + 3, end_position.y + 3)
  local extended_positions = {extended_corner_start_position, extended_corner_end_position}

  renderer_helper:draw_filled_rect(extended_positions, outline_color)
  renderer_helper:draw_outlined_rect(positions, body_background_color, outline_color)

  editor_text:draw(file_path)
  editor_scroll_bar:draw()
end

return EditorBody