local Entity = require 'Entity'
local Billboard = require 'renderer.Billboard'

local Character = {}

function Character:New(o)
	local o = Entity:New(o)

	o.hp = o.hp or 8
	o.color = o.color or {0.5,0,0}	

	setmetatable(o, self)
	self.__index = self

	return o
end

function Character:GetBillboard()
	local b = Billboard:New({id=self.id, pos=self.pos, size={width=1, height=1},color=self.color})
	return b
end

return Character
