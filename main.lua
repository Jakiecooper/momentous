local sti = require "sti"
local bump = require "lib/bump"
-- For debugging tables, printing to console
local inspect = require "lib/inspect"

require "player"
require "world"

gravity = 2250

--[[ 
   Gets the players starting x and y for the passed map's entity layers
   @param entity_objects: a table of objects which are on the entity layer of a map
   @return: the x and y coordinate of the players starting position
--]]
function get_player_start(entity_objects)
  for _, v in pairs(entity_objects) do 
    if v.name == "player_start" then return v.x, v.y end
  end
  return nil, nil
end

function love.load()
  map = sti("tiled/testMap.lua", {"bump"})
  world = bump.newWorld()
  map:bump_init(world)

  map.layers.collisions.visible = false
  map.layers.entities.visible = false

  x, y = get_player_start(map.layers.entities.objects)
  player:load(x, y)
  setup_window()
end

function love.update(dt)
  player:update(dt)
end

function love.draw()
  love.graphics.push()

  set_scale()
  map:draw(0, 0, x_scale, y_scale)
  player:draw()

  love.graphics.pop()
end

function love.keypressed(key, scancode)
  if key == "space" then player:jump() end
end

function love.conf(t)
  t.console = true
end


