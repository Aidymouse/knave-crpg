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
local debug = {
	-- Global switch
	enabled=false,
	-- Tint drawn objects based on depth
	draw_depth=false,
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

		-- Idea being objects will maintain their depth line when registered with the iso renderer. The render line is the max of the tiles X or Y, then the row is sorted itself.
		-- We only need to sort a row if there are non-tiles in it, and we only need to sort a row where something has changed
		-- Cos of how coods are set up it's jus the max of the tiles X or Y coord
		-- If we have an iso grid, the horizontal line as we see from the top is depth 1
		-- Depth 2 is the next row of tiles, etc
		--
		--     /\  <-- 1
		--    /\/\ <-- 2
		--   /\/\/\ <-- 3
		--   \/\/\/ <-- 4
		--    \/\/ <-- 5
		--     \/
		depth_lines = { },

		max_depth=0,

		-- entity id to current depth, for changing
		depth_record = {
			remove_entity = function(self, ent)
				for k,v in ipairs(self) do
					if k == ent.id then
						table.remove(self, k)
					end
				end
			end
		}
	}

	local corner_width = o.tile_draw_rect.width / 2
	local corner_height = o.tile_draw_rect.height / 2
	o.tile_side_length = math.sqrt(corner_width * corner_width + corner_height * corner_height)

	print("Tile side length", o.tile_side_length)

	setmetatable(o, {__index = self})
	return o
end

---@param d IsoDrawable
-- TODO: maintain a depth cache too
function IsoRenderer:update_depth(ent)
	local depth = IsoRenderer.get_depth(ent)

	if self.depth_record[ent.id] == depth then
		return
	end

	if self.depth_record[ent.id] ~= nil then
		local cur_depth = self.depth_record[ent.id]
		self.depth_lines[cur_depth]:remove_entity(ent)
		self.depth_record:remove_entity(ent)
	end

	if self.depth_lines[depth] == nil then
		self.max_depth = math.max(self.max_depth, depth)
		self.depth_lines[depth] = {
			depth=depth,
			billboard={},
			wall={},
			tile={},
			remove_entity = function (self, ent)
				for kb,e in ipairs(self.billboard) do if e.id == ent.id then table.remove(self.billboard, kb) return end end
				for kw,e in ipairs(self.wall) do if e.id == ent.id then table.remove(self.wall, kw) return end end
				for kt,e in ipairs(self.tile) do if e.id == ent.id then table.remove(self.tile, kt) return end end
			end
		}
	end

	table.insert(self.depth_lines[depth][ent.type], ent)

	if (ent.type == "billboard") then
		table.sort(self.depth_lines[depth][ent.type], function (a, b) return a.pos.y < b.pos.y end)

		for k,v in pairs(self.depth_lines[depth][ent.type]) do
		end
	end

	print("Adding ent "..ent.id.." ("..ent.type..") to depth "..depth)
	self.depth_record[ent.id] = depth
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

function IsoRenderer:draw_world()
	-- In passes:
	-- 1st pass - ground. Draw all ground tiles in proper order: 
	-- 2nd pass - upright tiles. Draw all upright tiles in order of their base positions down.
	-- (intersecting polygons might get weird)
	render_order = ""
	for depth=0,self.max_depth,1 do
		local line = self.depth_lines[depth]
		if (line == nil) then goto continue end

		render_order = render_order..depth..","
		

		for k,tile in ipairs(line.tile) do
			self:draw_iso_drawable(tile)
		end

		for k,billboard in ipairs(line.billboard) do
			self:draw_iso_drawable(billboard)
		end

		::continue::
	end

	--print(render_order)
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
