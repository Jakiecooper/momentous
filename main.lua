local sti = require "sti"
require "world"

function love.load()
  map = sti("testMap.lua")
  setupWindow()
end

function love.update(dt)
  map:update(dt)
end

function love.draw()
  map:draw(0, 0, xScale, yScale)
  setScale()
end
