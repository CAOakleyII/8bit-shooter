local EntityTypes = require 'lib.entity_types'
local entity_system = require 'lib.entity_system'
local Player = require 'models.player'
local Camera = require 'packages.hump.camera'

platform = {}

function platform:update(dt)
end

function platform:draw()

end

local_player = nil

function love.keypressed(key, u)
  --Debug
  if key == "rctrl" then --set to whatever key you want to use
     debug.debug()
  end
end

function love.load()

  -- set basic settings 
  cursor = love.mouse.newCursor('assets/crosshair.png', 0, 0)
  love.mouse.setCursor(cursor)

  -- create platform
  platform.body = love.physics.newBody(entity_system.world, 400, 400, 'static')
  platform.width = 200
  platform.height = 50
  platform.shape = love.physics.newRectangleShape(200, 50)
	platform.fixture = love.physics.newFixture(platform.body, platform.shape)

  entity_system:add_entity(platform, EntityTypes.Object)
	 
  -- load player
	x = love.graphics.getWidth() / 2
	y = love.graphics.getHeight() / 2 - 100

  local pos = { x = x, y = y }
  local_player = Player:new('Cervial', pos, Camera(pos.x, pos.y))
  local_player:load(true)

  entity_system:add_entity(local_player, EntityTypes.Player)
  
end
 
function love.update(dt)
  for k,v in pairs(entity_system.entities) do 
    if v then
      v:update(dt)
    end
  end
  entity_system.world:update(dt)
end
 
function love.draw()
  local_player.camera:attach()

  love.graphics.setColor(255, 255, 255)
  love.graphics.polygon("fill", platform.body:getWorldPoints(platform.shape:getPoints()))
 

  for k,v in pairs(entity_system.entities) do 
    if v then
      v:draw()
    end
  end

  love.graphics.print(entity_system.text, 10, 10)
  local_player.camera:detach()
end