
---@class Tile
local Tile = {
	type="tile",
	pos = {x = 0, y = 0},
	color = {1,1,1},

	New = function(self, ob)
		local o = ob or {}
		Entity.assign_id(o);
		setmetatable(o, {
			__index=self,
			__tostring=function(t) return "["..t.id.."] Tile ("..t.pos.x..","..t.pos.y..")"  end
		})
		return o
	end
}

return Tile
