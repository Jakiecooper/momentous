native_width = 320
native_height = 180
actual_width = 1280
actual_height = 720
x_scale = actual_width/native_width
y_scale = actual_height/native_height

window_flags = {
  fullscreen = true,
  vsync = 0,
  borderless = true
}

function set_scale()
  love.graphics.scale(x_scale, y_scale)
end

function setup_window()
  love.window.setMode(actual_width, actual_height, window_flags)
end
