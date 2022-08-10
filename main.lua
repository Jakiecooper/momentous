local sti = require "sti"
require("player")
require "world"

function love.load()
  map = sti("assets/fixedMap.lua", {"box2d"})
  World = love.physics.newWorld(0,0)
  map:box2d_init(World)
  map.layers.Collisons.visible = false
  Player:load()
end

function love.update(dt)
  World:update(dt)
  Player:update(dt)
end

function love.draw()
  map:draw(0, 0, 2, 2)
  love.graphics.push()
  love.graphics.scale(2,2)
  Player:draw()
  love.graphics.pop()
end

