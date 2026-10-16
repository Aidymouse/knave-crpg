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
	--table.insert(loaded_objects, Billboard:New({pos={x=6,y=6}, size={width=5, height=1}}))
	--htable.insert(loaded_objects, Billboard:New({pos={x=6.5,y=9}, size={width=5, height=1}, color={0, 0, 0.5}}))

	for k,v in ipairs(loaded_objects) do
		--renderer:update_depth(v)
	end

	local wall = Wall:New({
		from={x=1, y=1},
		to={x=2,y=1}
	})

	table.insert(renderer.uprights, player.billboard)
	table.insert(renderer.uprights, wall)
	table.insert(renderer.uprights, Billboard:New({pos={x=8,y=8},size={width=5,height=2}, color={0.5,0.5,1}}))
	
	-- billboard equiv. wall
	table.insert(renderer.uprights, Wall:New({ from={x=3,y=5}, to={x=5,y=3} }))
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

end


local Vec2 = require "Vec2"

function love.draw()

	love.graphics.translate(400, 50)
	love.graphics.scale(1.5, 1.5)

	renderer:draw_world()


	

	--renderer:draw_wall({x=1, y=1}, {x=1, y=11})
	--renderer:draw_wall({x=1, y=1}, {x=11, y=1})

	--renderer:draw_wall({x=0, y=0}, {x=0, y=1}, 1)
	--renderer:draw_wall({x=1, y=0}, {x=0, y=1}, 1)



end
