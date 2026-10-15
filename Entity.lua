local id = 0;
local Entity = {}

function Entity:New(ob)
	local o = {
		id=id,
	}
	id = id + 1
	setmetatable(o, {__index = self})
	return o
end

function Entity.assign_id(ob)
	ob.id = id;
	id = id + 1;
end

return Entity
