local inspect = require "lib/inspect"
require "world"

player = {}

--[[
    Caps the players speed to the its define maximum speed
--]]
local function cap_speed()
    if player.x_velocity > 0 then player.x_velocity = player.max_speed
    elseif player.x_velocity < 0 then player.x_velocity = -1 * player.max_speed end

end

--[[
    Applies gravity to the player passed as an argument
    @param player: the player to apply gravity to
    @param dt: the difference between frames
--]]
local function apply_gravity(player, dt)
    if player.touching_wall and player.y_velocity >= 0 then player.y_velocity = player.y_velocity + ((gravity / player.wall_slide_quotient) * dt)
    else player.y_velocity = player.y_velocity + (gravity * dt) end
end

--[[
    Sets the player.grounded field based on whether or not the player is
    on the ground
    @param player: the player to check for being on the ground
    @param cols: the object containing collisions returned by bump
    @param cols_len: the length of the cols object returned by bump
--]]
local function set_grounded(player, cols, cols_len)
    for i=1, cols_len do
        if cols[i].normal.x == 0 and cols[i].normal.y == -1 then
            player.grounded = true
            player.y_velocity = 0
            player.time_since_grounded = love.timer.getTime()
            return
        end
    end
    player.grounded = false
end

--[[
    Check if the player 'bonks' on the ceiling, meaning their velocity
    should be set to zero
    @param player: the player to check for bonking on the ceiling
    @param cols: the object of collisions returned by bump
    @param cols_len: the length of the cols object returned by bump
--]]
local function check_ceil_bonk(player, cols, cols_len)
    for i=1, cols_len do
        if cols[i].normal.x == 0 and cols[i].normal.y == 1 then
            player.y_velocity = 0
            return
        end
    end
end

--[[
    Check if the player is touching the wall by checking the collisions passed
    @param player: the player to check for touching the wall
    @param cols: the object of collisions returned by bump
    @param cols_len: the length of the cols object returned by bump
--]]
local function check_touching_wall(player, cols, cols_len)
    for i=1, cols_len do
        if cols[i].normal.x == 1 or cols[i].normal.x == -1 then
            player.touching_wall = true
            if cols[i].normal.x == 1 then player.touched_wall_direction = "left"
            else player.touched_wall_direction = "right" end
            return
        end
    end
    player.touched_wall_direction = nil
    player.touching_wall = false
end

--[[
    Handles the player input and changes the movement
    @param player: the player to check for touching the wall
    @param dt: the distance between frames rendered
--]]
local function handle_movement(player, dt)
    if love.keyboard.isDown("d", "right") then
        if player.grounded then player.x_velocity = player.x_velocity + (player.grounded_x_accel * dt)
        else player.x_velocity = player.x_velocity + (player.air_x_accel * dt) end

    elseif love.keyboard.isDown("a", "left") then
        if player.grounded then player.x_velocity = player.x_velocity - (player.grounded_x_accel * dt)
        else player.x_velocity = player.x_velocity - (player.air_x_accel * dt) end

    elseif player.x_velocity ~= 0 then
        if player.x_velocity > 0 then
            player.x_velocity = player.x_velocity - player.friction
            if player.x_velocity < 0 then player.x_velocity = 0 end
        else
            player.x_velocity = player.x_velocity + player.friction
            if player.x_velocity > 0 then player.x_velocity = 0 end
        end
    end
end

--[[
    Loads the player, initalizing all its fields and adding it to the world
    @param x_init: the x value of the player's initial location, within the map
    @param y_init: the y value of the player's initial location, within the map
--]]
function player:load(x_init, y_init)
    self.x = x_init
    self.y = y_init
    self.w = 16
    self.h = 16
    self.x_velocity = 0
    self.y_velocity = 0
    self.max_speed = 150
    self.grounded_x_accel = 3200
    self.air_x_accel = 500
    self.friction = 3500
    self.grounded = true
    self.jump_accel = 550
    self.touching_wall = false
    self.touched_wall_direction = nil
    self.wall_jump_accel = 50
    self.time_since_grounded = 0
    self.wall_slide_quotient = 12

    world:add(self, self.x, self.y, self.w, self.h)
end

--[[
    Makes the player jump
--]]
function player:jump()
    if self.grounded or self.touching_wall then
            self.y_velocity = self.y_velocity - (self.jump_accel)
    end
    if self.touching_wall then
        self.x_velocity = self.x_velocity * -1
        if self.touched_wall_direction == "right" then
            self.x_velocity = self.x_velocity - (self.wall_jump_accel)
        elseif self.touched_wall_direction == "left" then
            self.x_velocity = self.x_velocity + (self.wall_jump_accel)
        end
    end
    time_on_ground = love.timer.getTime() - self.time_since_grounded
end

--[[
    Updates the player, applying gravity and dealing with user input
    @param dt: the distance between frames rendered
--]]
function player:update(dt)
    if self.grounded then  cap_speed() end

    apply_gravity(self, dt)
    handle_movement(self, dt)
    self.x = self.x + (self.x_velocity * dt)
    self.y = self.y + (self.y_velocity * dt)
    if self.x < 0 then self.x = 0 end
    if self.x + self.w > native_width then self.x = native_width - self.w end

    self.x, self.y, cols, cols_len = world:move(self, self.x, self.y)

    if player.x_velocity ~= 0 or player.y_velocity ~= 0 then
        set_grounded(player, cols, cols_len)
        check_ceil_bonk(player, cols, cols_len)
        check_touching_wall(player, cols, cols_len)
    end
end

local function draw_box(box, r,g,b)
    love.graphics.push("all")

    love.graphics.setColor(r,g,b,0.25)
    love.graphics.rectangle("fill", box.x, box.y, box.w, box.h)
    love.graphics.setColor(r,g,b)
    love.graphics.rectangle("line", box.x, box.y, box.w, box.h)

    love.graphics.pop()
end

function player:draw()
    draw_box(self, 200, 100, 0)
end

