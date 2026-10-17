local Entity = require 'Entity'

---@class Billboard
---@field pos WorldCoord
local Billboard = {
	type="billboard",
	pos = {x = 0, y=0},
	size = {width=1, height=1},
	color = {1,1,1},

	New = function(self, ob)
		local o = ob or {}
		Entity.assign_id(o);
		setmetatable(o, {
			__index=self,
			__tostring=function(b) return "["..b.id.."] Billboard ("..b.pos.x..","..b.pos.y..")" end
		})
		return o
	end
}

return Billboard
