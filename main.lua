local IsoRenderer = require 'IsoRenderer'

local Entity = require 'Entity'
local Vec2 = require 'Vec2'
local Wall = require 'Wall'
local Billboard = require 'Billboard'

---@class Tile
local Tile = {
	type="tile",
	pos = {x = 0, y = 0},
	color = {1,1,1},

	New = function(self, ob)
		local o = ob or {}
		Entity.assign_id(o);
		setmetatable(o, {
			__index=self,
			__tostring=function(t) return "["..t.id.."] Tile ("..t.pos.x..","..t.pos.y..")"  end
		})
		return o
	end
}


function love.load()

	local up = Vec2:New(-1, -1)
	local left = Vec2:New(1, 0)
	local right = Vec2:New(0, 1)

	print("Angle To Left: "..Vec2.AngleBetween(up, left))
	print("Angle To Right: "..Vec2.AngleBetween(up, right))

	renderer = IsoRenderer:new()

	player = {
		billboard=Billboard:New({
			pos={x=5,y=5},
			color={1, 0.5, 0.5}
		})
	}

	for tx=0,10,1 do
		for ty=0,10,1 do

			table.insert(renderer.tiles, Tile:New({pos={x=tx+0.5, y=ty+0.5}, color={0.6,0.6,0.6}}))
		end
	end

	table.insert(renderer.uprights, Wall:New({from={x=0,y=0}, to={x=0,y=11}, color={0.8,0.8,0.8}, height=1}))
	table.insert(renderer.uprights, Wall:New({from={x=0.1,y=0.1}, to={x=11,y=0}, color={0.7,0.7,0.7}, height=1}))

	table.insert(renderer.uprights, player.billboard)
	--table.insert(renderer.uprights, Wall:New({from={x=1,y=1}, to={x=2,y=1}, color={0,0.5,0}}))
	--table.insert(renderer.uprights, Wall:New({from={x=2,y=3}, to={x=2,y=5}}))
	table.insert(renderer.uprights, Billboard:New({pos={x=8,y=8},size={width=5,height=2}, color={0.5,0.5,1}}))
	
	-- billboard equiv. wall
	--table.insert(renderer.uprights, Wall:New({ from={x=3,y=5}, to={x=5,y=3} }))
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

function love.draw()

	love.graphics.translate(400, 50)
	love.graphics.scale(1.5, 1.5)

	renderer:draw_world()



	--[[ Vector Tests

	local world_up = renderer.world_to_screen({x=-1, y=-1}, renderer.tile_draw_rect)
	local screen_up = Vec2:New(world_up.x, world_up.y)

	screen_up:Draw()
	
	local screen_player = IsoRenderer.world_to_screen(player.billboard.pos, renderer.tile_draw_rect)
	local p_vec = Vec2:New(screen_player.x, screen_player.y)
	
	love.graphics.setColor(1, 0, 0)
	p_vec:Draw()

	local angle = p_vec:AngleBetween(screen_up)
	print(angle)

	local up = Vec2:New(0, -1) * 50
	love.graphics.setColor(1, 1, 1)
	up:Draw()
	

	local angle = p_vec:AngleBetween(up)
	love.graphics.print(math.deg(angle), p_vec.x, p_vec.y)
	]]

end
