local ffi = require("code-editor.ffi")
local config = require("code-editor.config.config")
local renderer_helper = require("code-editor.render.renderer_helper")

Notifications = {
  notifications = {}
}

function Notifications:add(text)
  local start_time = globalvars.get_current_time()

  table.insert(self.notifications, 1, { text=text, start_time=start_time, printed=false })
end

function get_positions_by_align(align, width, text_info)
  local screen_size = engine.get_screen_size()
  
  local text_start_offset = text_info["text_start_offset"]
  local text_size = text_info["text_size"]

  local background_start_x_position = 0
  local text_x_position = 0

  if align == 0 then -- left
    background_start_x_position = text_start_offset / 2
    text_x_position = background_start_x_position + text_start_offset
  end

  if align == 1 then -- center
    background_start_x_position = (screen_size.x / 2) - (width / 2)
    text_x_position = (screen_size.x / 2) - (text_size.x / 2)
  end

  if align == 2 then -- right
    background_start_x_position = screen_size.x - width - (text_start_offset / 2)
    text_x_position = (background_start_x_position + width) - (text_start_offset + text_size.x)
  end

  return {background_start_x_position, text_x_position}
end

function get_animated_alpha(time_passed, display_time)
  local new_alpha = 255

  local time_for_animation = display_time / 4
  local step = 255 / time_for_animation

  if time_passed < time_for_animation then
    new_alpha = math.min(255, time_passed * step)
  end

  if time_passed >= display_time - time_for_animation then
    new_alpha = math.max(0, 255 - ((time_for_animation - (display_time - time_passed)) * step))
  end

  return new_alpha
end

function draw_notification(text, id, time_passed)
  local variables = config:get()
  
  local align = variables.notification_align
  local animated_alpha = variables.notification_animated_alpha
  local font_size = variables.notification_font_size
  local width = variables.notification_width
  local height = variables.notification_height
  local offset = variables.notification_offset
  local display_time = variables.notification_display_time
  local foreground_color = variables.notification_foreground_color
  local background_color = variables.notification_background_color
  local outline_color = variables.notification_outline_color

  if animated_alpha then
    local new_alpha = get_animated_alpha(time_passed, display_time)

    foreground_color[4] = new_alpha
    background_color[4] = new_alpha
    outline_color[4] = new_alpha
  end

  local text_start_offset = 10

  local font = renderer_helper:get_font(font_size)
  local text_size = renderer.get_text_size(font, font_size, text)
  local text_info = {text_size=text_size, text_start_offset=text_start_offset}

  local minimal_width = text_size.x + (text_start_offset*2)
  local minimal_height = text_size.y + 6

  width = math.max(minimal_width, width)
  height = math.max(minimal_height, height)

  local aligned_positions = get_positions_by_align(align, width, text_info)

  local background_start_x_position = aligned_positions[1]
  local text_x_position = aligned_positions[2]

  local background_start_y_position = 5 + ((height + offset) * (id-1))
  local background_start_position = vec2_t.new(background_start_x_position, background_start_y_position) 

  local background_end_x_position = background_start_x_position + width
  local background_end_y_position = background_start_y_position + height
  local background_end_position = vec2_t.new(background_end_x_position, background_end_y_position) 

  local background_positions = {background_start_position, background_end_position}
  
  local text_y_position = background_start_y_position + ((height - text_size.y) / 2)
  local text_position = vec2_t.new(text_x_position, text_y_position)
  
  renderer_helper:draw_outlined_rect(background_positions, background_color, outline_color)
  renderer_helper:draw_text(text, text_position, font_size, foreground_color)
end

function Notifications:draw()
  local display_time = config:get().notification_display_time

  for i = 1, #self.notifications do
    local notification = self.notifications[i]

    local text = notification.text
    local start_time = notification.start_time
    local printed = notification.printed

    local current_time = globalvars.get_current_time()
    local time_passed = current_time - start_time

    if not printed then
      print(text)
      notification.printed = true
    end

    draw_notification(text, i, time_passed)

    if time_passed > display_time then
      table.remove(self.notifications, i)
    end
  end
end

return Notifications