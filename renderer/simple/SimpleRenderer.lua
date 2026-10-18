local Vec2 = require 'lib.Vec2'

local SimpleRenderer = {
	tile_size = 50
}


function SimpleRenderer.DrawWorld(world_data)

	for id,ent in pairs(world_data.entities) do
		ent:Draw()
	end

	for id,wall in pairs(world_data.walls) do
		love.graphics.setColor(wall.color)

		local from = SimpleRenderer.world_to_screen(wall.from)
		local to = SimpleRenderer.world_to_screen(wall.to)

		love.graphics.line(from.x, from.y, to.x, to.y)
	end
	

end

function SimpleRenderer.world_to_screen(pos, tile_size)
	tile_size = tile_size or SimpleRenderer.tile_size
	return Vec2:New(pos.x*tile_size, pos.y*tile_size)
end

return SimpleRenderer
