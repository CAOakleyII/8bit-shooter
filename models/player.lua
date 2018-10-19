local entity_system = require 'lib.entity_system'
local Bullet = require 'models.bullet'
local EntityTypes = require 'lib.entity_types'
local Direction = require 'lib.direction'



Player = {}

function Player:new(name, pos, camera)
  local player = {}
    -- general info
    player.name = name
    player.img = love.graphics.newImage('assets/warlock.png')
    player.body = love.physics.newBody(entity_system.world, pos.x, pos.y, 'dynamic')
    player.body:setMass(10)
    player.shape = love.physics.newRectangleShape(player.img:getWidth(), player.img:getHeight())
    player.fixture = love.physics.newFixture(player.body, player.shape)
    player.fixture:setRestitution(0.0)
    player.x = pos.x
    player.y = pos.y

    -- player stats 
    player.total_health = 100
    player.current_health = 100
    player.speed = 200
    player.jump_height = -300

    -- gravity info
    player.gravity = -500
    player.y_velocity = 0
    player.ground = pos.y

    -- character image offests    
    player.x_offset = player.img:getWidth() / 2
    player.y_offset = player.img:getHeight() / 2
    player.orientation = Direction.Right

    -- camera
    player.camera = camera

    -- player collections
    player.keys_down = {}

    -- networking info
    player.local_player = false
  

  self.__index = self
  return setmetatable(player, self)
end

function Player:health_as_percent()
  return (self.current_health / self.total_health) * 100
end

function Player:get_pos()
  return { x = self.body:getX(), y = self.body:getY() }
end

function Player:load(bind_keys)

  if bind_keys then
    self.local_player = true;
    function love.keypressed(key)
      self.keys_down[key] = true
      -- client:send(NetworkMessageTypes.OnPlayerInput, { id = self.id, keys = self.keys_down })
    end
    function love.keyreleased(key)
      self.keys_down[key] = nil
      -- client:send(NetworkMessageTypes.OnPlayerInput, { id = self.id, keys = self.keys_down })
    end
    function love.mousepressed(x, y, button)
      -- local x,y  = camera:mousePosition();
      -- x, y = love.mouse.getPosition()
      self.keys_down['m' .. button] =  { x = x, y = y };
      -- client:send(NetworkMessageTypes.OnPlayerInput, { id = self.id, keys = self.keys_down })
    end
    function love.mousereleased(x, y, button)
      self.keys_down['m' .. button] = nil
      -- client:send(NetworkMessageTypes.OnPlayerInput, { id = self.id, keys = self.keys_down })
    end
  end 
end

function Player:update(dt)
  if self.keys_down['d'] then
    self.body:applyForce(self.speed, 0)
		-- self.translate(self.x + (self.speed * dt), self.y)
  elseif self.keys_down['a'] then
    self.body:applyForce((self.speed) * -1, 0)
		-- self.x = self.x - (self.speed * dt)
	end
 
  if self.keys_down['space'] then
    self.body:applyForce(0, self.jump_height)
  end
  
  if self.keys_down['m1'] then
     -- get starting position based on character
    starting_pos = self:get_pos()
     
    -- move it towards the direction of the gun. 
    starting_pos.x = starting_pos.x + (self.orientation * self.x_offset) -- (opposite side of image in width)
    starting_pos.y = starting_pos.y - self.y_offset -- half the height of the character

    -- get the mouse position based on the camera.
    x,y = self.camera:mousePosition()
    target_pos = { x = x, y = y }

    entity_system:add_entity(Bullet:new(starting_pos, target_pos), EntityTypes.Object)
  end


  -- determine character orientation based off of mouse
  camera_mouse_x, y = self.camera:mousePosition()
  if camera_mouse_x < self.body:getX() then
    self.orientation = Direction.Left
  elseif camera_mouse_x > self.body:getX() then
    self.orientation = Direction.Right
  end

  -- keep the camera on the player
  local dx, dy = self.body:getX() - self.camera.x, self.body:getY() - self.camera.y
  self.camera:move(dx/2, dy/2)
end

function Player:draw()
  
  -- set color to white and print name
  love.graphics.setColor(255,255,255)
  love.graphics.print(self.name, self.body:getX() - self.x_offset - 5, self.body:getY() - 60)
  
  -- set color to red and print health bar
  love.graphics.setColor(255,0,0)
  love.graphics.rectangle('line', self.body:getX() - self.x_offset - 5, self.body:getY() - 40, 50, 5)
  love.graphics.rectangle('fill', self.body:getX() - self.x_offset - 5, self.body:getY() - 40, self:health_as_percent() / 2, 5)
  
  -- set Color needs to be set back to white, to draw an image.
  love.graphics.setColor(255,255,255)
  love.graphics.draw(self.img, self.body:getX(), self.body:getY(), 0, self.orientation, 1, self.x_offset, self.img:getHeight())
  love.graphics.polygon('line', self.body:getWorldPoints(self.shape:getPoints()))
end

return Player