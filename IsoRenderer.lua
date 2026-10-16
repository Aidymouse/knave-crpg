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

local Vec2 = require "Vec2"

local IsoRenderer = {}
local debug = {
	-- Global switch
	enabled=true,
	-- Tint drawn objects based on depth
	draw_depth=false,
	-- updated as draw calls are made, so we can see draw order on the objects themselves
	cur_draw_counter=-1,
}

---@alias IsoDrawable = Tile | Wall | Billboard

function IsoRenderer:new()
	local o = {
		-- The screen-size rectangle that controls how we draw tiles
		tile_draw_rect = { width = 40, height = 40*0.5 },

		-- The screen-space length of 1 tile height in the Z direction
		-- Because of isometry, this should be the same as the length of the tile
		-- I.e. the dist from the middle top of the draw_rect to the middle of an edge
		tile_side_length = 0, -- Populated below

		-- Upright drawing elements, billboards and walls
		uprights = {},
		tiles = {},


	}

	local corner_width = o.tile_draw_rect.width / 2
	local corner_height = o.tile_draw_rect.height / 2
	o.tile_side_length = math.sqrt(corner_width * corner_width + corner_height * corner_height)

	print("Tile side length", o.tile_side_length)

	setmetatable(o, self)
	self.__index = self
	return o
end


function IsoRenderer:am_i_in_front_of_wall(pos, wall)
	-- [[ Identify slope of wall ]]
	--[[
	local slope = "right"

	-- depth basically = screen Y
	local screen_from = IsoRenderer.screen_to_world(wall.from, self.tile_draw_rect)
	local screen_to = IsoRenderer.screen_to_world(wall.to, self.tile_draw_rect)

	if (screen_from.y == screen_to.y) then slope = "flat" end
	-- TODO: what if wall is straight up and down
	local top = screen_from
	local bottom = screen_to
	if (screen_to.y < screen_from.y) then
		top = screen_to
		bottom = screen_from
	end

	if (bottom.x < bottom.y) then slope = "left" end
	]]

	-- If the wall is flat (both points have same depth towards screen) then we can do simple billboard check
	if (wall.from.x + wall.from.y == wall.to.x + wall.from.y) then
		return pos.x + pos.y < wall.from.x + wall.from.y
	end

	-- [[ What side am I on? ]]
	local from_vec = Vec2:New(wall.from.x, wall.from.y)
	local to_vec = Vec2:New(wall.to.x, wall.to.y)
	local p_vec = Vec2:New(pos.x, pos.y)

	local wall_vec = from_vec - to_vec
	local wall_to_p_vec = from_vec - p_vec


	-- screen space straight up 
	local up_vec = Vec2:New(-1, -1)

	local angle_0 = wall_vec:AngleBetween(up_vec)
	local angle_p = wall_to_p_vec:AngleBetween(up_vec)

	-- TODO: always get an angle going clockwise / counterclockwise to account for how the AngleBetween fn is symmetrical (i.e. only goes up to 180)

	--print(math.deg(angle_0), math.deg(angle_p))

	return angle_0 < angle_p

	-- 1. Get an angle of the wall to 0, 0 (top of screen)
	-- 2. Get angle to point to 0, 0
	-- 3. If angle 2 > angle 1, in front. Otherwise, behind
	-- 4. If angle is equal (or just about equal), then check walls other point.
	

	-- TODO: one day, I could get REALLY fancy with it, and break all lines up such that intersections become split line segments, so even intersecting walls would work. Wow
	

end


function IsoRenderer.get_depth(d)
	if (d.type == "tile") then
		local depth = math.floor(d.pos.x)+math.floor(d.pos.y)
		return depth
	elseif (d.type == "billboard") then

		-- If we *cross* any depth lines, we need to be on higher depth

		local depth = math.max(math.floor(d.pos.y)+math.floor(d.pos.x)) + 1
		return depth
	end

	return -1
end

---@param tile Tile
function IsoRenderer:draw_tile(tile)

	screen_coord = IsoRenderer.world_to_screen(tile.pos, self.tile_draw_rect)

	screen_width = self.tile_draw_rect.width
	screen_height = self.tile_draw_rect.height
	
	love.graphics.setColor(tile.color)

	-- Only works for squares
	love.graphics.polygon('fill', {
		screen_coord.x - (screen_width/2), screen_coord.y,
		screen_coord.x, screen_coord.y - (screen_height/2),
		screen_coord.x + (screen_width/2), screen_coord.y,
		screen_coord.x, screen_coord.y + (screen_height/2)
	})


	if debug.enabled then
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

	if (debug.enabled) then
		love.graphics.circle('fill', center.x, center.y, 2)	
	end

end

--@param billboard Billboard - The coordinate of the bottom of the billboard
-- Note that billboards are essentially drawn diagonally on the tile from the perspective of world space, so width = 1 doesn't mean it will stretch the whole diagonal tile
-- Billboard origin is bottom middle
function IsoRenderer:draw_billboard(billboard)

	-- Assuming the billboard is facing the screen, we need to convert tile space width into screen width.
	-- The long corner-corner measurement of a tile is sqrt(2) as tiles are 1 by 1
	screen_width = (billboard.size.width / math.sqrt(2)) * self.tile_draw_rect.width
	screen_height = billboard.size.height * self.tile_side_length

	screen_pos = IsoRenderer.world_to_screen(billboard.pos, self.tile_draw_rect)

	love.graphics.setColor(billboard.color)
	love.graphics.rectangle('fill', screen_pos.x-screen_width/2, screen_pos.y-screen_height, screen_width, screen_height)

	if debug.enabled then
		love.graphics.setColor(0.6, 0, 0)
		love.graphics.circle('fill', screen_pos.x, screen_pos.y, 2)

		love.graphics.setColor(0.8,0.8,0.8)
		love.graphics.print(debug.cur_draw_counter, screen_pos.x-screen_width/2, screen_pos.y - 15)
	end

end


---@param wall Wall - Tile coord to start wall
function IsoRenderer:draw_wall(wall)
	screen_from = IsoRenderer.world_to_screen(wall.from, self.tile_draw_rect)
	screen_to = IsoRenderer.world_to_screen(wall.to, self.tile_draw_rect)
	local height=height or 1

	love.graphics.setColor(wall.color)
	love.graphics.polygon('fill', {
		screen_from.x, screen_from.y,
		screen_to.x, screen_to.y,
		screen_to.x, screen_to.y - (height*self.tile_side_length),
		screen_from.x, screen_from.y - (height*self.tile_side_length),
	})

	if (debug.enabled) then
		love.graphics.circle('fill', screen_from.x, screen_from.y, 2)
		love.graphics.setColor(0, 0.6, 0)
		love.graphics.circle('fill', screen_to.x, screen_to.y, 2)

		love.graphics.setColor(0.8,0.8,0.8)
		love.graphics.print(debug.cur_draw_counter, screen_from.x, screen_from.y - 15)
	end
end

function IsoRenderer:draw_line_on_floor(from, to)
	screen_from = IsoRenderer.world_to_screen(from, self.tile_draw_rect)
	screen_to = IsoRenderer.world_to_screen(to, self.tile_draw_rect)

	love.graphics.setColor(0, 1, 0)
	love.graphics.line(screen_from.x, screen_from.y, screen_to.x, screen_to.y)
end

function IsoRenderer:draw_iso_drawable(d)
	if (d.type == "tile") then
		self:draw_tile(d)
	elseif (d.type == "wall") then
		self:draw_wall(d)
	elseif (d.type == "billboard") then
		self:draw_billboard(d)
	else
		print("Can't draw " .. d .. ", doesn't look like drawable: " .. d.type)
	end
end

---
function IsoRenderer:sort_uprights(uprights)

	uprights = uprights or self.uprights

	table.sort(uprights, function (a,b)

		if (a.type == "billboard" and b.type == "wall") then
			return IsoRenderer:am_i_in_front_of_wall(a.pos, b) == false
		elseif (a.type == "wall" and b.type == "billboard") then
			return IsoRenderer:am_i_in_front_of_wall(b.pos, a)
		elseif (a.type == "billboard" and b.type == "billboard") then
			a_depth = a.pos.x + a.pos.y
			b_depth = b.pos.x + b.pos.y
			
			return a_depth < b_depth
		elseif (a.type == "wall" and b.type == "wall") then
			local top = a.from
			if (a.to.x + a.to.y < a.from.x + a.from.y) then
				top = a.to
			end
			local in_front = IsoRenderer:am_i_in_front_of_wall(top, b)

			print(a,b,in_front)

			return in_front == false
		end

		return false

	end)

	order=""
	for k,v in pairs(uprights) do
		order = order .. v.id .. ","
	end

end

function IsoRenderer:draw_world()
	-- In passes:
	-- 1st pass - ground. Draw all ground tiles in proper order: 
	-- 2nd pass - upright tiles. Draw all upright tiles in order of their base positions down.
	for k,tile in pairs(self.tiles) do
		self:draw_tile(tile)
	end

	self:sort_uprights()

	for k,upright in pairs(self.uprights) do
		debug.cur_draw_counter=k
		self:draw_iso_drawable(upright,k)
	end

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


end

return IsoRenderer
