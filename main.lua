local IsoRenderer = require 'IsoRenderer'

local Entity = require 'Entity'

---@class Tile
local Tile = {
	type="tile",
	pos = {x = 0, y = 0},
	color = {1,1,1},

	New = function(self, ob)
		local o = ob or {}
		Entity.assign_id(o);
		setmetatable(o, {__index=self})
		return o
	end
}

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
		setmetatable(o, {__index=self})
		return o
	end
}

---@class Billboard
---@field pos WorldCoord
local Billboard = {
	type="billboard",
	pos = {x = 0, y=0},
	size = {width=1, height=1},
	color = {1,1,1},

	New = function(self, ob)
		local o = ob or {}
		Entity.assign_id(o);
		setmetatable(o, {__index=self})
		return o
	end
}

function love.load()
	renderer = IsoRenderer:new()

	player = {
		billboard=Billboard:New({
			pos={x=5,y=5},
			color={1, 0.5, 0.5}
		})
	}

	loaded_objects = {
	}

	for tx=0,10,1 do
		for ty=0,10,1 do
			--table.insert(loaded_objects, Tile:New({pos={x=tx+0.5, y=ty+0.5}, color={0.4,0.4,0.4}}))
		end
	end

	table.insert(loaded_objects, player.billboard)
	table.insert(loaded_objects, Billboard:New({pos={x=6,y=6}, size={width=5, height=1}}))
	table.insert(loaded_objects, Billboard:New({pos={x=6.5,y=9}, size={width=5, height=1}, color={0, 0, 0.5}}))

	for k,v in ipairs(loaded_objects) do
		renderer:update_depth(v)
	end
end

function love.update(dt)
	local speed = 3
	local move = {x=0, y=0}
	if love.keyboard.isDown('down') then
		move.x = move.x + speed
		move.y = move.y + speed
	end

	if love.keyboard.isDown('up') then
		move.x = move.x - speed
		move.y = move.y - speed
	end

	if love.keyboard.isDown('left') then
		move.x = move.x + speed
		move.y = move.y - speed
	end

	if love.keyboard.isDown('right') then
		move.x = move.x - speed
		move.y = move.y + speed
	end

	player.billboard.pos.x = player.billboard.pos.x + move.x * dt
	player.billboard.pos.y = player.billboard.pos.y + move.y * dt

	if (move.x ~= 0 or move.y ~= 0) then
		renderer:update_depth(player.billboard)
	end

end


local Vec2 = require "Vec2"

function love.draw()

	love.graphics.translate(400, 50)
	love.graphics.scale(1.5, 1.5)

	renderer:draw_world()

	local wall = Wall:New({
		from={x=1, y=1},
		to={x=2,y=1}
	})




	renderer:draw_wall(wall)

	local f = renderer:am_i_in_front_of_wall(player.billboard.pos, wall)

	love.graphics.setColor(1,0,0)
	if (f) then
		love.graphics.setColor(1,1,1)
	end

	local player_pos = renderer.world_to_screen(player.billboard.pos, renderer.tile_draw_rect)
	love.graphics.circle('fill', player_pos.x, player_pos.y, 3)
	

	--renderer:draw_wall({x=1, y=1}, {x=1, y=11})
	--renderer:draw_wall({x=1, y=1}, {x=11, y=1})

	--renderer:draw_wall({x=0, y=0}, {x=0, y=1}, 1)
	--renderer:draw_wall({x=1, y=0}, {x=0, y=1}, 1)



end
