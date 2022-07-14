local renderer_helper = require("code-editor.render.renderer_helper")
local config = require("code-editor.config.config")

local editor_head = require("code-editor.render.editor.editor-head")
local editor_body = require("code-editor.render.editor.editor-body")
local additional = require("code-editor.render.editor.additional")

Editor = {
  file_name = "...",
  file_path = ""
}

function Editor:draw()
  additional:move_editor()
  additional:resize_editor()

  editor_head:draw(self.file_name)
  editor_body:draw(self.file_path)
end

return Editor