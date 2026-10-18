---@class WorldData
---@field tiles
local WorldData = {}


function WorldData:New()
	local o = {

		tiles={},
		walls={},
		entities={},
		
	}

	setmetatable(o, self)
	self.__index = self
	return o
end


function WorldData:LoadEntity(entity)
	if (self.entities[entity.id] ~= nil) then
		assert(1==2, 'Trying to register an entity that has already been registered')
	end
	self.entities[entity.id] = entity
end

function WorldData:LoadWall(wall)
	if (self.walls[wall.id] ~= nil) then
		assert(1==2, 'Trying to register a wall that has already been registered')
	end
	self.walls[wall.id] = wall
end

return WorldData
