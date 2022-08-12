local sti = require "sti"
require "player"
require "world"

function love.load()
  map = sti("assets/fixedMap.lua", {"bump"})
  world = love.physics.newWorld(0,0)
  map:bump_init(world)
  map.layers.Collisons.visible = true
  player:load()
end

function love.update(dt)
  world:update(dt)
  player:update(dt)
end

function love.draw()
  map:draw(0, 0, 2, 2)
  love.graphics.push()
  love.graphics.scale(2,2)
  player:draw()
  love.graphics.pop()
end

