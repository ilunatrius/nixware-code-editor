local fonts = require("code-editor.render.fonts")

RendererHelper = {}

function convert_array_to_color(clr)
  return color_t.new(clr[1], clr[2], clr[3], clr[4])
end

function RendererHelper:get_font(font_size)
  return fonts[font_size]
end

function RendererHelper:draw_text(text, position, font_size, color)
  local converted_color = convert_array_to_color(color)
  local font = self:get_font(font_size)

  renderer.text(text, font, position, font_size, converted_color)
end

function RendererHelper:draw_filled_rect(positions, color)
  local converted_color = convert_array_to_color(color)

  local from = positions[1]
  local to = positions[2]

  renderer.rect_filled(from, to, converted_color)
end

function RendererHelper:draw_outlined_rect(positions, color, outline_color)
  local converted_color = convert_array_to_color(color)
  local converted_outline_color = convert_array_to_color(outline_color)

  local from = positions[1]
  local to = positions[2]

  renderer.rect_filled(from, to, converted_color)
  renderer.rect(from, to, converted_outline_color)
end

return RendererHelper