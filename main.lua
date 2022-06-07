local sti = require "sti"
require "world"

function love.load()
  map = sti("testMap.lua")
end

function love.update(dt)
  map:update(dt)
end

function love.draw()
  setupScreen()
  map:draw(0, 0, xScale, yScale)
end
