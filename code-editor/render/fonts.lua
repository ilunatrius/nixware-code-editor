fonts = {}

for font_size = 8, 32 do
  local font = renderer.setup_font("C:/Windows/Fonts/Verdana.ttf", font_size, 0)
  fonts[font_size] = font
end

return fonts