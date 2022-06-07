nativeWidth = 320
nativeHeight = 180
actualWidth = 2560
actualHeight = 1440
xScale = actualWidth/nativeWidth
yScale = actualHeight/nativeHeight
--[[
windowFlags = {
  fullscreen = true,
  vsync = 0,
  borderless = true
}
-]]

function setupScreen()
  love.window.setMode(actualWidth, actualHeight, windowFlags)
  love.graphics.scale(xScale, yScale)
end
