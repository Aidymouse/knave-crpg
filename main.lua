local IsoRenderer = require 'IsoRenderer'

---@class Tile
local Tile = {
	type="tile",
	pos = {x = 0, y = 0},
	color = {1,1,1},

	New = function(self, ob)
		local o = ob or {}
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
		Wall:New({ from={x=0,y=0}, to={x=1,y=0}, color={0.8, 0.8, 0.8} }),
		Wall:New({ from={x=0,y=0}, to={x=0,y=1}, color={0.7, 0.7, 0.7} }),
	}

	for tx=0,10,1 do
		for ty=0,10,1 do
			table.insert(loaded_objects, Tile:New({pos={x=tx+0.5, y=ty+0.5}}))
		end
	end

	table.insert(loaded_objects, player.billboard)

	for k,v in ipairs(loaded_objects) do
		renderer:update_depth(v)
	end
end

function love.update(dt)
	local speed = 1
	if love.keyboard.isDown('down') then
		player.billboard.pos.x = player.billboard.pos.x + speed * dt
		player.billboard.pos.y = player.billboard.pos.y + speed * dt
	end

	if love.keyboard.isDown('up') then
		player.billboard.pos.x = player.billboard.pos.x - speed * dt
		player.billboard.pos.y = player.billboard.pos.y - speed * dt
	end

	if love.keyboard.isDown('left') then
		player.billboard.pos.x = player.billboard.pos.x + speed * dt
		player.billboard.pos.y = player.billboard.pos.y - speed * dt
	end

	if love.keyboard.isDown('right') then
		player.billboard.pos.x = player.billboard.pos.x - speed * dt
		player.billboard.pos.y = player.billboard.pos.y + speed * dt
	end
end


function love.draw()

	love.graphics.translate(400, 50)
	love.graphics.scale(1.5, 1.5)

	renderer:draw_world()

	--renderer:draw_wall({x=1, y=1}, {x=1, y=11})
	--renderer:draw_wall({x=1, y=1}, {x=11, y=1})

	--renderer:draw_wall({x=0, y=0}, {x=0, y=1}, 1)
	--renderer:draw_wall({x=1, y=0}, {x=0, y=1}, 1)



end
