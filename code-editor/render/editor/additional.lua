local config = require("code-editor.config.config")
local renderer_helper = require("code-editor.render.renderer_helper")
local editor_head = require("code-editor.render.editor.editor-head")
local editor_text = require("code-editor.render.editor.editor-text")

Additional = {
  moving = false,
  button_pressed_out_of_moving_rect = false,
  start_move_position = vec2_t.new(0, 0),
  resizing = false,
  button_pressed_out_of_resizing_rect = false
}

function Additional:cursor_in_rect(positions)
  local cursor_position = renderer.get_cursor_pos()

  local start_position = positions[1]
  local end_position = positions[2]

  if cursor_position.x >= start_position.x and cursor_position.x <= end_position.x then
    return cursor_position.y >= start_position.y and cursor_position.y <= end_position.y
  end

  return false
end

function Additional:clamp_positions(x_position, y_position)
  local screen_size = engine.get_screen_size()

  local variables = config:get()

  local width = variables.editor_width
  local height = variables.editor_height
  local offset = variables.editor_offset
  local head_height = editor_head.height
  local full_height = head_height + offset + height

  local start_position = vec2_t.new(x_position, y_position)
  local end_position = vec2_t.new(x_position + width, y_position + full_height)

  if start_position.x <= 0 then x_position = 0 end
  if end_position.x >= screen_size.x then x_position = screen_size.x - width end

  if start_position.y <= 0 then y_position = 0 end
  if end_position.y >= screen_size.y then y_position = screen_size.y - full_height end

  return {x_position, y_position}
end

function Additional:move_editor()
  local cursor_position = renderer.get_cursor_pos()

  local variables = config:get()

  local x_position = variables.editor_x_position
  local y_position = variables.editor_y_position

  local minimal_width = math.max(editor_head.minimal_width, editor_text.minimal_width)
  local minimal_height = math.max(editor_head.minimal_height, editor_text.minimal_height)

  local start_position = vec2_t.new(x_position, y_position)
  local end_position = vec2_t.new(x_position + editor_head.width, y_position + editor_head.height)
  local positions = {start_position, end_position}

  if not client.is_key_pressed(1) then
    self.button_pressed_out_of_moving_rect = false
    self.moving = false
    
    if self:cursor_in_rect(positions) then
      self.start_move_position = cursor_position
    end
  end

  if client.is_key_pressed(1) then
    if not self:cursor_in_rect(positions) then
      self.button_pressed_out_of_moving_rect = true
    end
  
    if self:cursor_in_rect(positions) and not self.button_pressed_out_of_moving_rect then
      self.moving = true
    end
    
    if self.moving then
      x_position = x_position + (cursor_position.x - self.start_move_position.x)
      y_position = y_position + (cursor_position.y - self.start_move_position.y)

      self.start_move_position = cursor_position
    end
  end

  local clamped_positions = self:clamp_positions(x_position, y_position)

  variables.editor_x_position = clamped_positions[1]
  variables.editor_y_position = clamped_positions[2]
end

function Additional:reset_moving_variables()
  self.button_pressed_out_of_resizing_rect = false
  self.resizing = false
end

function Additional:resize_editor()
  local cursor_position = renderer.get_cursor_pos()

  local variables = config:get()

  local x_position = variables.editor_x_position
  local y_position = variables.editor_y_position

  local width = variables.editor_width
  local height = variables.editor_height
  local offset = variables.editor_offset
  local head_height = editor_head.height
  local full_height = head_height + offset + height

  local outline_color = variables.editor_outline_color 

  local right_bottom_corner_position = vec2_t.new(x_position + width, y_position + full_height)
  local extended_corner_start_position = vec2_t.new(right_bottom_corner_position.x - 12, right_bottom_corner_position.y - 12)
  local extended_corner_end_position = vec2_t.new(right_bottom_corner_position.x + 3, right_bottom_corner_position.y + 3)
  local extended_positions = {extended_corner_start_position, extended_corner_end_position}

  self.corner_positions = extended_positions

  if not client.is_key_pressed(1) then
    self:reset_moving_variables()
  end

  if client.is_key_pressed(1) then
    if not self:cursor_in_rect(extended_positions) then
      self.button_pressed_out_of_resizing_rect = true
    end

    if self:cursor_in_rect(extended_positions) and not self.button_pressed_out_of_resizing_rect then
      self.resizing = true
    end

    if self.resizing then      
      width = width + (cursor_position.x - right_bottom_corner_position.x)
      height = height + (cursor_position.y - right_bottom_corner_position.y)
    end
  end

  width = math.max(width, editor_head.minimal_width, editor_text.minimal_width)
  height = math.max(height, editor_head.minimal_height, editor_text.minimal_height)

  variables.editor_width = width
  variables.editor_height = height
end

return Additional