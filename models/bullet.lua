Bullet = {}

function Bullet:new(starting_pos, target_pos)
  local direction = math.atan2(target_pos.y - starting_pos.y, target_pos.x - starting_pos.x)

  local obj = {
    img =  love.graphics.newImage('assets/bullet.png'),
    speed = 500,
    x = starting_pos.x,
    y = starting_pos.y,
    direction = direction
  }

  self.__index = self
  return setmetatable(obj, self)
end

function Bullet:load()
end

function Bullet:update(dt)
  -- move bullet in direction
  self.x = self.x + math.cos(self.direction) * self.speed * dt
  self.y = self.y + math.sin(self.direction) * self.speed * dt
end

function Bullet:draw()
  -- draw bullets
  love.graphics.setColor(255,255,255)
  love.graphics.draw(self.img, self.x, self.y, 0, 1, 1, 0, 3)
end

return Bullet