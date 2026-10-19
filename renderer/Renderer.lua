local Renderer = {}

--- Renderer interface
function Renderer:New()
	local o = {}
	setmetatable(o, self)
	self.__index = self
	return o
end

function Renderer:DrawWorld(world_data)
	assert(1==2, "Renderer method unimplemented")
end

---@param world_data WorldData
---@param mouse_pos Vec2
function Renderer:GetClickedEntity(world_data, mouse_pos)
	assert(1==2, "Renderer method unimplemented")
end

return Renderer
