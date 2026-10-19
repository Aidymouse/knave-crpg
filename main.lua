local IsoRenderer = require 'renderer.IsoRenderer'
local Wall = require 'renderer.Wall'
local Billboard = require 'renderer.Billboard'
local SimpleRenderer = require 'renderer.simple.SimpleRenderer'

local CombatEngine = require 'combat.CombatEngine'

local WorldData = require 'WorldData'
local Entity = require 'Entity'
local Character = require 'Character'

local Badr = require 'lib.Badr.badr'
local BadrButton = require 'lib.Badr.components.button'

local Vec2 = require 'lib.Vec2'
local List = require 'lib.List'

function love.load()

	loaded_level = WorldData:New()

	player = Character:New({ color={1, 0.5, 0.5 }})

	enemy = Character:New({ pos=Vec2:New(5, 5) })

	loaded_level:LoadEntity(player)
	loaded_level:LoadEntity(enemy)

	loaded_level:LoadWall(Wall:New{from={x=0, y=0}, to={x=0,y=11}, color={0.8,0.8,0.8}})
	loaded_level:LoadWall(Wall:New{from={x=0, y=0}, to={x=11,y=0}, color={0.6,0.6,0.6}})
	--loaded_level:LoadWall(Wall:New{from={x=4.5, y=3.5}, to={x=4.5,y=8.5}, color={0,0,0.25}})
	--loaded_level:LoadWall(Wall:New{from={x=5, y=6}, to={x=5,y=11}, color={0,0,0.5}})

	--[[
	loaded_level:LoadWall(Wall:New{from={x=0, y=0}, to={x=0,y=5}, color={1,0,0}})
  loaded_level:LoadWall(Wall:New{from={x=0, y=5}, to={x=7,y=9}, color={0,1,0}})
	loaded_level:LoadWall(Wall:New{from={x=7, y=9}, to={x=0,y=0}, color={0,0,1}})
	]]

	iso_renderer = IsoRenderer:New()
	simple_renderer = SimpleRenderer:New()

	combat_engine = CombatEngine:New({
		renderer=simple_renderer
	})

	combat_engine:LoadEntity(player)
	combat_engine:LoadEntity(enemy)


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

	combat_engine:Update(dt)


end

function love.draw()
	
	--love.graphics.translate(300,50)
	simple_renderer:DrawWorld(loaded_level)
	--iso_renderer:draw_from_graph(loaded_level)
	combat_engine:DrawUI(loaded_level)

	--iso_renderer:plain_draw(loaded_level)

end
