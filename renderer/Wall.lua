local Entity = require 'Entity'

---@class Wall
local Wall = {
	type="wall",
	from = {x=0, y=0},
	to = {x=0,y=0},
	height = 1,
	color = {1,1,1},
	New = function(self, ob)
		local o = ob or {}
		Entity.assign_id(o);
		setmetatable(o, {
			__index=self,

			__tostring=function(w) return "["..w.id.."] Wall ("..w.from.x..","..w.from.y..") ("..w.to.x..","..w.to.y..")" end,

		})
		return o
	end
}

return Wall
