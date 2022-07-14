local file_system = require("code-editor.filesystem")
local config = require("code-editor.config.config")
local text_colors = require("code-editor.text-colors.text-colors")
local renderer_helper = require("code-editor.render.renderer_helper")
local editor_head = require("code-editor.render.editor.editor-head")
local editor_scroll_bar = require("code-editor.render.editor.editor-scroll-bar")

EditorText = {
  minimal_width = 0,
  minimal_height = 0,
  start_line_id = 1
}

function split(str, separator)
  local result = {}
  local regex = "([^"..separator.."]+)"

  for splitted in string.gmatch(str, regex) do
    table.insert(result, splitted)
  end
  
  return result
end

function EditorText:get_max_possible_text(text, font_size, width)
  local result = ""

  local font = renderer_helper:get_font(font_size)
  local full_text_size = 0

  for i = 1, #text do
    local char = string.sub(text, i, i)
    local char_size = renderer.get_text_size(font, font_size, char)

    full_text_size = full_text_size + char_size.x
    
    if full_text_size + char_size.x > width then
      break
    end

    result = result..char
  end

  return result
end

function EditorText:draw(file_path)
  if #file_path == 0 then
    return
  end

  local variables = config:get()
  local text_colors_variables = text_colors:get()

  local foreground_color = variables.editor_body_foreground_color
  
  local x_position = variables.editor_x_position
  local y_position = variables.editor_y_position
  local offset = variables.editor_offset
  local width = variables.editor_width
  local height = variables.editor_height
  local head_height = editor_head.height
  local text_padding = 3

  local font_size = variables.editor_body_font_size
  local font = renderer_helper:get_font(font_size)

  local start_position = vec2_t.new(x_position, y_position + offset + head_height)
  local end_position = vec2_t.new(x_position + width, start_position.y + height)

  local file_lines = file_system:get_file_lines(file_path)
  local lines_count = #file_lines

  local upper_case_symbol_size = renderer.get_text_size(font, font_size, "A")
  local numbers_size = renderer.get_text_size(font, font_size, tostring(lines_count).." | ")

  self.minimal_width = (text_padding*2) + numbers_size.x + (upper_case_symbol_size.x*16)
  self.minimal_height = upper_case_symbol_size.y + (text_padding*2)

  local number_width = numbers_size.x + text_padding
  local number_height = text_padding + numbers_size.y

  local start_line_id = math.floor(editor_scroll_bar.value)

  editor_scroll_bar.max_value = lines_count

  for i = start_line_id, lines_count do
    local number_text = tostring(i).." | "
    local number_text_size = renderer.get_text_size(font, font_size, number_text)

    local number_x_position = start_position.x + (number_width - number_text_size.x)
    local number_y_position = start_position.y + text_padding + (number_height * (i-start_line_id))
    local number_position = vec2_t.new(number_x_position, number_y_position)

    if number_y_position + number_height > end_position.y then
      break
    end
    
    renderer_helper:draw_text(number_text, number_position, font_size, foreground_color)

    local line = file_lines[i]
    local text = self:get_max_possible_text(line, font_size, width - number_width)
    local separated_symbols = split(text, "%s")
    local space_size = renderer.get_text_size(font, font_size, " ")
  
    local tab_length = 0
    
    for j = 1, #text do
      if text:sub(j, j) ~= " " then break end
      tab_length = tab_length + 1
    end

    local current_x_position = x_position + number_width + text_padding + (tab_length * space_size.x)

    for j = 1, #separated_symbols do
      local symbols = separated_symbols[j]
      local symbols_size = renderer.get_text_size(font, font_size, symbols)

      local text_x_position = current_x_position + (space_size.x * (j-1))
      local text_y_position = number_y_position
      local text_position = vec2_t.new(text_x_position, text_y_position)

      local text_color = text_colors_variables[symbols] or foreground_color

      current_x_position = current_x_position + symbols_size.x

      renderer_helper:draw_text(symbols, text_position, font_size, text_color)
    end
  end
end

return EditorText