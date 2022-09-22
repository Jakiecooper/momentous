local sti = require "sti"
local bump = require "lib/bump"
-- For debugging tables, printing to console
local inspect = require "lib/inspect"
local ldtk = require "ldtk/ldtk"

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
  --resizing the screen to 512px width and 512px height
  love.window.setMode(512, 512)

  --setting up the project for pixelart
  love.graphics.setDefaultFilter('nearest', 'nearest')
  love.graphics.setLineStyle('rough')
  --

  --loads a .ldtk file
  ldtk:load('ldtk/Map', 'Level_0')
  ldtk:setFlipped(true) --flips the loop
                        --you may not need this if you have your own custom loop

  --[[
      This is called when an entity is created

      entity = {x = (int), y = (int), width = (int), height = (int), visible = (bool)
                  px = (int), py = (int), order = (int), props = (table)}

      px is pivot x and py is pivot y
      props contains all custom fields defined in LDtk for that entity
      remember that colors are HEX not RGB.
      You can use ldtk ldtk.getColorHex(color) to get an RGB table like {0.21, 0.57, 0.92}
  ]]
  function ldtk.entity(entity)
      local newObject = object(entity) --creating new object based on the class we defined before
      table.insert(objects, newObject) --add the object to the table we use to draw
  end

  --[[
      This is called when a new layer object is created
      The given object has x, y, order, identifier, visible, color and a draw function
      layer:draw() --used to draw the layer
  ]]
  function ldtk.layer(layer)
      table.insert(objects, layer) --adding layer to the table we use to draw
  end

  --[[
      This is called before we create the new level.
      You may use it to remove old objects and change some settings like background color
      level = {bgColor = (table), identifier = (string), worldX  = (int), worldY = (int),
               width = (int), height = (int), props = (table)}

      props table has the custom fields defined in LDtk
  ]]
  function ldtk.onLevelLoad(level)
      objects = {} --removing all objects so we can create our new room
      love.graphics.setBackgroundColor(level.bgColor) --changing background color
  end

  --[[
      -- This is called after the new level is created. (after creating all layers and entities)
      You may use it to change some settings for objects or to call a function.
      level = {bgColor = (table), identifier = (string), worldX  = (int), worldY = (int),
               width = (int), height = (int), props = (table)}
  ]]
  function ldtk.onLevelCreated(level)
      load(level.props.create)() --here we use a string defined in LDtk as a function
  end

  --Loading the first level.
  ldtk:goTo(1)

  --[[
      You can load a level by its name
      ldtk:level('Level_0')
      You can load a level by its index (starting at 1 as the first level)
      ldtk:goTo(4) --loads the forth level
      You can load the next and previous levels
      ldtk:next() --loads the next level or the first if we are in the last one
      ldtk:previous() --loads the previous level or the last if we are in the first
      You can reload current level (if player loses for example)
      ldtk:reload()
  ]]
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