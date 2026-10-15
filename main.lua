local IsoRenderer = require 'IsoRenderer'

function love.load()
	renderer = IsoRenderer:new()

	player = {
		x=0.5,--0.5,
		y=0.5,--.5,
	}
end

function love.update(dt)
	local speed = 1
	if love.keyboard.isDown('down') then
		player.x = player.x + speed * dt
		player.y = player.y + speed * dt
	end

	if love.keyboard.isDown('up') then
		player.x = player.x - speed * dt
		player.y = player.y - speed * dt
	end

	if love.keyboard.isDown('left') then
		player.x = player.x + speed * dt
		player.y = player.y - speed * dt
	end

	if love.keyboard.isDown('right') then
		player.x = player.x - speed * dt
		player.y = player.y + speed * dt
	end
end

function love.draw()

	love.graphics.translate(400, 50)
	love.graphics.scale(1.5, 1.5)


	for tx=0,10,1 do
		for ty=0,10,1 do
			renderer:draw_tile({x=tx+0.5, y=ty+0.5})
		end
	end

	--renderer:draw_wall({x=1, y=1}, {x=1, y=11})
	--renderer:draw_wall({x=1, y=1}, {x=11, y=1})

	--renderer:draw_wall({x=0, y=0}, {x=0, y=1}, 1)
	--renderer:draw_wall({x=1, y=0}, {x=0, y=1}, 1)

	renderer:draw_rect(player, math.sqrt(0.5), math.sqrt(0.5))
	renderer:draw_billboard(player, 1, 1) -- should result in billboard that goes from corner to corner


end
