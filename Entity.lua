local Vec2 = require 'lib.Vec2'

local id = 0;
local Entity = {}


function Entity:New(ob)
	local o = {
		id=id,
		pos=Vec2:New()
	}

	for k,v in pairs(ob or {}) do
		o[k] = v
	end

	id = id + 1
	setmetatable(o, {__index = self})
	return o
end

function Entity:Draw()
	love.graphics.circle("fill", self.pos.x, self.pos.y, 2)
end

function Entity.assign_id(ob)
	ob.id = id;
	id = id + 1;
end

--- Basically assign_id but you get the ID back to do what you want
function Entity.get_assigned_id()
	local i = id;
	id = id + 1;
	return i
end


return Entity
