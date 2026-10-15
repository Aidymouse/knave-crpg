---@class WorldData
---@field tiles
local WorldData = {}



function WorldData:new()
	local o = {

		tiles: {}
		walls: {}
		
	}

	setmetatable(o, {__index=self})
	return o
end


return WorldData
