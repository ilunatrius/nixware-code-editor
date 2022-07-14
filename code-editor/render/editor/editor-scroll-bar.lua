local config = require("code-editor.config.config")
local renderer_helper = require("code-editor.render.renderer_helper")
local editor_head = require("code-editor.render.editor.editor-head")

EditorScrollBar = {
  is_scrolling = false,
  temp_value = 1,
  value = 1,
  min_value = 1,
  max_value = 1
}

function EditorScrollBar:cursor_in_rect(positions)
  local cursor_position = renderer.get_cursor_pos()

  local start_position = positions[1]
  local end_position = positions[2]

  if cursor_position.x >= start_position.x and cursor_position.x <= end_position.x then
    return cursor_position.y >= start_position.y and cursor_position.y <= end_position.y
  end

  return false
end

function EditorScrollBar:get_scroll_bar_value(positions, step)
  local cursor_position = renderer.get_cursor_pos()

  local start_position = positions[1]
  local end_position = positions[2]

  if not client.is_key_pressed(1) then
    self.is_scrolling = false
  end

  if client.is_key_pressed(1) then
    if self:cursor_in_rect(positions) then
      self.is_scrolling = true
    end

    if self.is_scrolling then
      local new_value = (cursor_position.y - start_position.y) / step
      self.temp_value = math.max(self.min_value, math.min(self.max_value, new_value))
      self.value = math.max(self.min_value, math.min(self.max_value, new_value))
    end
  end
end

function EditorScrollBar:draw()
  local variables = config:get()

  local x_position = variables.editor_x_position
  local y_position = variables.editor_y_position
 
  local width = variables.editor_width
  local height = variables.editor_height
  local head_height = editor_head.height

  local scroll_bar_width = 15

  local offset = variables.editor_offset

  local background_color = variables.editor_body_background_color
  local outline_color = variables.editor_outline_color

  local body_start_position = vec2_t.new(x_position, y_position + offset + head_height)
  local body_end_position = vec2_t.new(x_position + width, body_start_position.y + height)

  local start_x_position = body_end_position.x + offset
  local start_y_position = body_start_position.y
  local start_position = vec2_t.new(start_x_position, start_y_position)

  local end_x_position = start_x_position + scroll_bar_width
  local end_y_position = body_end_position.y
  local end_position = vec2_t.new(end_x_position, end_y_position)

  local positions = {start_position, end_position}

  renderer_helper:draw_outlined_rect(positions, background_color, outline_color)

  local full_height = end_y_position - start_y_position

  local scroll_bar_height = (full_height / self.max_value) * 2
  local scroll_step = (full_height - (scroll_bar_height / 2)) / self.max_value

  local value = math.min(math.max(0, self.temp_value - self.min_value), self.max_value)

  local scroll_start_x_position = start_x_position + 2
  local scroll_start_y_position = start_y_position + 2 + (scroll_step * value)
  local scroll_start_position = vec2_t.new(scroll_start_x_position, scroll_start_y_position)

  local scroll_end_x_position = scroll_start_x_position + scroll_bar_width - 4
  local scroll_end_y_position = scroll_start_y_position + scroll_bar_height - 4
  local scroll_end_position = vec2_t.new(scroll_end_x_position, scroll_end_y_position)

  local scroll_positions = {scroll_start_position, scroll_end_position}

  self:get_scroll_bar_value(positions, scroll_step)

  renderer_helper:draw_outlined_rect(scroll_positions, outline_color, background_color)
end

return EditorScrollBar