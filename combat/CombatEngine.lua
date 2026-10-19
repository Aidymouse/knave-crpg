local Vec2 = require 'lib.Vec2'

local CombatState = require 'combat.CombatState'

local CombatEngine = {}


function CombatEngine:New(ob)
	local o = {
		--- entity id: combat state
		loaded_actors = {},

		round=0,

		--- id
		selected_actor=nil,
	}

	for k,v in pairs(ob) do
		o[k] = v
	end

	assert(o.renderer ~= nil, "Please assign renderer to combat engine")

	setmetatable(o, self)
	self.__index = self
	return o
end

function CombatEngine:LoadEntity(entity)
	self.loaded_actors[entity.id] = CombatState:New()
end

function CombatEngine:Update(dt)
	if (love.mouse.isDown(1)) then
		local mouse_vec = Vec2:New(love.mouse.getX(), love.mouse.getY())

		local clicked_id = self.renderer:GetClickedEntity(loaded_level, mouse_vec)
		self.selected_actor = clicked_id
	end
end

--- VERY basic
function CombatEngine:DrawUI(world_data)
	if (self.selected_actor) then
		local ent = world_data.entities[self.selected_actor]
		local ent_pos = self.renderer:WorldToScreen(ent.pos)
		love.graphics.setColor(1,0,0)
		love.graphics.circle('line', ent_pos.x, ent_pos.y, 30)
	end
end

--- Once all actions are decided, we process decision from this round and get the resulting state
function CombatEngine:ProcessRound()
end

return CombatEngine
