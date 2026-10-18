local CombatEngine = {}

function CombatEngine:New(o)
	local o = {
		--- entity id: entity
		loaded_actors = {}
	}
	setmetatable(o, self)
	self.__index = self
	return o
end

return CombatEngine
