EntitySystem = {}



function EntitySystem:new()
  local obj = {
    world = love.physics.newWorld(0, 200, true),    
    entities = {},
    players = {},
    enemies = {},
    objects = {},
    text = ""
  }

  function beginContact(a, b, coll)
    x,y = coll:getNormal()
    
    print('colliding')
  end
  
  function endContact(a, b, coll)
    
    print('uncolliding')
  end
  
  function preSolve(a, b, coll)
    
  end
  
  function postSolve(a, b, coll, normalimpulse, tangentimpulse)
  end

  obj.world:setCallbacks(beginContact, endContact, preSolve, postSolve)

  self.__index = self
  return setmetatable(obj, self)
end

function EntitySystem:add_entity(entity, type)
  table.insert(self.entities, entity)
  table.insert(self[type], entity)
end

entity_system = EntitySystem:new()

return entity_system