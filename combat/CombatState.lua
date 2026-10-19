local CombatState = {}


local AttackAction = {
	--- entity id
	target=-1
}

function CombatState:New()
	local o = {
		desired_action="",
		target={}
	}
	setmetatable(o, self)
	self.__index = self
	return o
end

return CombatState
