local Vec2 = require 'lib.Vec2'
local Renderer = require 'renderer.Renderer'
local Collision = require 'lib.Collision'

local SimpleRenderer = Renderer:New()

function SimpleRenderer:New()
	local r = {}

	r.tile_size = 30

	setmetatable(r, self)
	self.__index = self

	return r
end


function SimpleRenderer:DrawWorld(world_data)

	for id,ent in pairs(world_data.entities) do
		local b = ent:GetBillboard()	
		local rect = SimpleRenderer.GetBillboardRect(b, self.tile_size)
		
		love.graphics.setColor(b.color)
		love.graphics.rectangle('fill', rect.x, rect.y, rect.width, rect.height)

	end

	for id,wall in pairs(world_data.walls) do
		love.graphics.setColor(wall.color)

		local from = SimpleRenderer.world_to_screen(wall.from, self.tile_size)
		local to = SimpleRenderer.world_to_screen(wall.to, self.tile_size)

		love.graphics.line(from.x, from.y, to.x, to.y)
	end
	

end

function SimpleRenderer:GetClickedEntity(world_data, mouse_pos)
	for id,ent in pairs(world_data.entities) do
		
		local b = ent:GetBillboard()
		local b_rect = SimpleRenderer.GetBillboardRect(b, self.tile_size)
		if Collision.PointInRect(mouse_pos, b_rect) then
			return id
		end
	end

	return nil
end

function SimpleRenderer.GetBillboardRect(billboard, tile_size)
		local screen_width = billboard.size.width * tile_size
		local screen_height = billboard.size.height * tile_size
		local screen_pos = SimpleRenderer.world_to_screen(billboard.pos, tile_size)
		return { x=screen_pos.x - screen_width/2, y=screen_pos.y - screen_height/2, width=screen_width, height=screen_height }
end

function SimpleRenderer:WorldToScreen(pos)
	return SimpleRenderer.world_to_screen(pos, self.tile_size)
end

function SimpleRenderer.world_to_screen(pos, tile_size)
	tile_size = tile_size or SimpleRenderer.tile_size
	return Vec2:New(pos.x*tile_size, pos.y*tile_size)
end

function SimpleRenderer.screen_to_world()
end




return SimpleRenderer
