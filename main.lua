local IsoRenderer = require 'renderer.IsoRenderer'
local Wall = require 'renderer.Wall'
local Billboard = require 'renderer.Billboard'
local SimpleRenderer = require 'renderer.simple.SimpleRenderer'

local WorldData = require 'WorldData'
local Entity = require 'Entity'

local Vec2 = require 'lib.Vec2'
local List = require 'lib.List'

function love.load()

	loaded_level = WorldData:New()

	player = Entity:New({
		radius=1,
		pos=Vec2:New(2, 2),
		GetBillboard=function(self)
			b = Billboard:New({id=self.id, pos=self.pos, size={width=1, height=1},color={0.5,0,0}})
			return b
		end,
		Draw=function(self) 
			love.graphics.setColor(1, 0, 0)
			local p = SimpleRenderer.world_to_screen(self.pos)
			love.graphics.circle('fill', p.x, p.y, self.radius*SimpleRenderer.tile_size/2)
		end,
	})

	loaded_level:LoadEntity(player)

	--[[
	loaded_level:LoadWall(Wall:New{from={x=0, y=0}, to={x=0,y=11}, color={0.8,0.8,0.8}})
	loaded_level:LoadWall(Wall:New{from={x=0, y=0}, to={x=11,y=0}, color={0.6,0.6,0.6}})
	loaded_level:LoadWall(Wall:New{from={x=4.5, y=3.5}, to={x=4.5,y=8.5}, color={0,0,0.25}})
	loaded_level:LoadWall(Wall:New{from={x=5, y=6}, to={x=5,y=11}, color={0,0,0.5}})
	]]

	loaded_level:LoadWall(Wall:New{from={x=0, y=0}, to={x=0,y=5}, color={1,0,0}})
  loaded_level:LoadWall(Wall:New{from={x=0, y=5}, to={x=7,y=9}, color={1,0,0}})
	loaded_level:LoadWall(Wall:New{from={x=7, y=9}, to={x=0,y=0}, color={0,1,0}})



	iso_renderer = IsoRenderer:New()
end

function love.update(dt)
	local speed = 3
	local move = Vec2:New(0, 0)

	if love.keyboard.isDown('down') then
		move.x = move.x + speed
		move.y = move.y + speed
	end

	if love.keyboard.isDown('up') then
		move.x = move.x - speed
		move.y = move.y - speed
	end

	if love.keyboard.isDown('left') then
		move.x = move.x - speed
		move.y = move.y + speed
	end

	if love.keyboard.isDown('right') then
		move.x = move.x + speed
		move.y = move.y - speed
	end

	if love.keyboard.isDown('y') then
		move.x = move.x - speed
	end
	if love.keyboard.isDown('u') then
		move.y = move.y + speed
	end
	if love.keyboard.isDown('i') then
		move.y = move.y - speed
	end
	if love.keyboard.isDown('o') then
		move.x = move.x + speed
	end

	player.pos = player.pos + move * dt

end

function love.draw()
	
	love.graphics.translate(300,50)
	--SimpleRenderer.DrawWorld(loaded_level)
	iso_renderer:draw_from_graph(loaded_level)
	--iso_renderer:plain_draw(loaded_level)

end
