---@class WorldData
---@field tiles
local WorldData = {}

---@class Tile
local Tile = {
	type="tile",
	pos = {x = 0, y = 0},
	color = {1,1,1},

	New = function(self, ob)
		local o = ob or {}
		setmetatable(o, {__index=self})
		return o
	end
}

---@class Wall
local Wall = {
	type="wall",
	from = {x=0, y=0},
	to = {x=0,y=0},
	height = 1,
	color = {1,1,1},
	New = function(self, ob)
		local o = ob or {}
		setmetatable(o, {__index=self})
		return o
	end
}

---@class Billboard
---@field pos WorldCoord
local Billboard = {
	type="billboard",
	pos = {x = 0, y=0},
	size = {width=1, height=1},
	color = {1,1,1},

	New = function(self, ob)
		local o = ob or {}
		setmetatable(o, {__index=self})
		return o
	end
}



function WorldData:new()
	local o = {

		tiles: {}
		walls: {}
		
	}

	setmetatable(o, {__index=self})
	return o
end


return WorldData
