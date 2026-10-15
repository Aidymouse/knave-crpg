--[[
--
-- [ Tile Coordinates ]
-- Organized such that 0, 0 is the top most tile. Makes the start point for rendering easy to find. Each tile has a world width and height of 1.
--              0,0
--            __-^-__
--      __--^^ .5,.5 ^^--__
-- 1,0 <         o         > 0,1
--      ^^--__       __--^^
--            ^^-_-^^
--              1,1
--
-- [ Tile Sizing ]
-- Tile size = edge length of a tile
--
-- -------------------------
-- |       __-|-__       | |
-- | __--^^   |   ^^--__ | | <- Tile draw height
-- |<------------T------>|--
-- | ^^--__   |   __--^^ |
-- |       ^^-|-^^       |
-- -----------------------
--]]
local IsoRenderer = {}
local debug = false

function IsoRenderer:new()
	local o = {
		-- The screen-size rectangle that controls how we draw tiles
		tile_draw_rect = { width = 40, height = 40*0.5 },

		-- The screen-space length of 1 tile height in the Z direction
		-- Because of isometry, this should be the same as the length of the tile
		-- I.e. the dist from the middle top of the draw_rect to the middle of an edge
		tile_side_length = 0 -- Populated below
	}

	local corner_width = o.tile_draw_rect.width / 2
	local corner_height = o.tile_draw_rect.height / 2

	o.tile_side_length = math.sqrt(corner_width * corner_width + corner_height * corner_height)
	print("Tile side length", o.tile_side_length)
	

	setmetatable(o, self)
	self.__index = self
	return o
end

---@param tile_coord WorldCoord - A coordinate in tile space, center of the tile
---@param width number - Tiles width
---@param height number - Tiles height
function IsoRenderer:draw_tile(tile_coord)

	screen_coord = IsoRenderer.world_to_screen(tile_coord, self.tile_draw_rect)

	screen_width = self.tile_draw_rect.width
	screen_height = self.tile_draw_rect.height
	
	love.graphics.setColor(1, 1, 1)

	-- Only works for squares
	love.graphics.polygon('line', {
		screen_coord.x - (screen_width/2), screen_coord.y,
		screen_coord.x, screen_coord.y - (screen_height/2),
		screen_coord.x + (screen_width/2), screen_coord.y,
		screen_coord.x, screen_coord.y + (screen_height/2)
	})


	if debug then
		--love.graphics.print(tile_coord.x .. ", " .. tile_coord.y, screen_coord.x-tile_size/2, screen_coord.y-tile_size/4)
		love.graphics.circle('fill', screen_coord.x, screen_coord.y, 1)
	end

end

function IsoRenderer:draw_rect(center_coord, width, height) 

	center = IsoRenderer.world_to_screen(center_coord, self.tile_draw_rect)

	top = IsoRenderer.world_to_screen({x=center_coord.x - width/2, y=center_coord.y - height/2}, self.tile_draw_rect)
	bottom = IsoRenderer.world_to_screen({x=center_coord.x + width/2, y=center_coord.y + height/2}, self.tile_draw_rect)
	right = IsoRenderer.world_to_screen({x=center_coord.x - width/2, y=center_coord.y + height/2}, self.tile_draw_rect)
	left = IsoRenderer.world_to_screen({x=center_coord.x + width/2, y=center_coord.y - height/2}, self.tile_draw_rect)

	love.graphics.setColor(1, 0, 1)
	love.graphics.polygon('line', {
		top.x, top.y,
		right.x, right.y,
		bottom.x, bottom.y,
		left.x, left.y
	})

	if (debug) then
		love.graphics.circle('fill', center.x, center.y, 2)	
	end

end

--@param tile_coord WorldCoord - The coordinate of the bottom of the billboard
--@param width number - Width of billboard in tilespace. 
--@param height number - Height of the billboard in tile space
-- Note that billboards are essentially drawn diagonally on the tile from the perspective of world space, so width = 1 doesn't mean it will stretch the whole diagonal tile
-- Billboard origin is bottom middle
function IsoRenderer:draw_billboard(tile_coord, width, height)

	-- Assuming the billboard is facing the screen, we need to convert tile space width into screen width.
	-- The long corner-corner measurement of a tile is sqrt(2) as tiles are 1 by 1
	screen_width = (width / math.sqrt(2)) * self.tile_draw_rect.width
	screen_height = height * self.tile_side_length

	screen_pos = IsoRenderer.world_to_screen(tile_coord, self.tile_draw_rect)

	love.graphics.setColor(1, 0, 0)
	love.graphics.rectangle('line', screen_pos.x-screen_width/2, screen_pos.y-screen_height, screen_width, screen_height)

	if debug then
		love.graphics.setColor(0.6, 0, 0)
		love.graphics.circle('fill', screen_pos.x, screen_pos.y, 2)
	end

end


---@param from WorldCoord - Tile coord to start wall
---@param to WorldCoord - Tile coord to end wall
---@param height number - Height (in tile space) of the wall
function IsoRenderer:draw_wall(from, to, height)

	screen_from = IsoRenderer.world_to_screen(from, self.tile_draw_rect)
	screen_to = IsoRenderer.world_to_screen(to, self.tile_draw_rect)
	local height=height or 1

	love.graphics.setColor(0, 1, 0)
	love.graphics.polygon('line', {
		screen_from.x, screen_from.y,
		screen_to.x, screen_to.y,
		screen_to.x, screen_to.y - (height*self.tile_side_length),
		screen_from.x, screen_from.y - (height*self.tile_side_length),
	})

	if (debug) then
		love.graphics.circle('fill', screen_from.x, screen_from.y, 2)
		love.graphics.setColor(0, 0.6, 0)
		love.graphics.circle('fill', screen_to.x, screen_to.y, 2)
	end
end

function IsoRenderer:draw_line_on_floor(from, to)
	screen_from = IsoRenderer.world_to_screen(from, self.tile_draw_rect)
	screen_to = IsoRenderer.world_to_screen(to, self.tile_draw_rect)

	love.graphics.setColor(0, 1, 0)
	love.graphics.line(screen_from.x, screen_from.y, screen_to.x, screen_to.y)

end

function IsoRenderer:draw_world()
	-- In passes:
	-- 1st pass - ground. Draw all ground tiles in proper order: 
	-- 2nd pass - upright tiles. Draw all upright tiles in order of their base positions down.
	-- (intersecting polygons might get weird)
end

---@param coord Coord Coordinate in tile space
---@param world_params Coord Coordinate in tile space
---@return Coord The coordinate in screen space
function IsoRenderer.world_to_screen(coord, tile_draw_rect)

	return {
		x = -coord.x * (tile_draw_rect.width/2) + coord.y * (tile_draw_rect.width/2),
		y = coord.y * (tile_draw_rect.height/2) + coord.x * (tile_draw_rect.height/2)
	}
end

---@param coord Coord
---@param world_params WorldParams
---@return Coord The coordinate in tile space
function IsoRenderer.screen_to_world(coord, world_params)
	local tile_size = world_params.tile_size
end

return IsoRenderer
