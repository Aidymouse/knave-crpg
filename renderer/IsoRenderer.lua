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

local Vec2 = require "lib.Vec2"
local List = require "lib.List"

local IsoRenderer = {}
local debug = {
	-- Global switch
	enabled=false,
	-- Tint drawn objects based on depth
	draw_depth=false,
	-- updated as draw calls are made, so we can see draw order on the objects themselves
	cur_draw_counter=-1,
	-- draw mode for all iso drawables
	draw_mode="fill",
	-- render objects with their ID beneath the anchor dot
	draw_ids=true
}

---@alias IsoDrawable = Tile | Wall | Billboard

function IsoRenderer:New()
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

	setmetatable(o, self)
	self.__index = self
	return o
end

--- Takes a wall object and gets a {left, right, up, down} table based on the points position in screen space
function get_norm_wall(wall, draw_rect)
	local screen_from = IsoRenderer.world_to_screen(wall.from, draw_rect)
	local screen_to = IsoRenderer.world_to_screen(wall.to, draw_rect)

	local bottom=wall.to
	local top=wall.from
	local screen_bottom=screen_to
	local screen_top=screen_from

	if (screen_from.y > screen_to.y) then
			bottom=wall.from
			top=wall.to
			screen_bottom=screen_from
			screen_top=screen_to
	end

	local left=wall.to
	local right=wall.from
	local screen_left=screen_to
	local screen_right=screen_from

	if (screen_from.x < screen_to.x) then
		left = wall.from
		right = wall.to
		local screen_left=screen_from
		local screen_right=screen_to
	end

	return { 
		left=left,
		right=right,
		top=top,
		bottom=bottom,
		screen_top=screen_top,
		screen_left=screen_left,
		screen_right=screen_right,
		screen_bottom=screen_bottom,
	}

end



---@param tile Tile
function IsoRenderer:draw_tile(tile)

	screen_coord = IsoRenderer.world_to_screen(tile.pos, self.tile_draw_rect)

	screen_width = self.tile_draw_rect.width
	screen_height = self.tile_draw_rect.height
	
	love.graphics.setColor(tile.color)

	-- Only works for squares
	love.graphics.polygon(debug.draw_mode, {
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
	love.graphics.polygon(debug.draw_modee, {
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
	love.graphics.rectangle(debug.draw_mode, screen_pos.x-screen_width/2, screen_pos.y-screen_height, screen_width, screen_height)

	if debug.enabled then
		love.graphics.setColor(0.6, 0, 0)
		love.graphics.circle('fill', screen_pos.x, screen_pos.y, 2)

		love.graphics.setColor(1,0,0)
		love.graphics.print(debug.cur_draw_counter, screen_pos.x-screen_width/2, screen_pos.y - 15)
	end

end


---@param wall Wall - Tile coord to start wall
function IsoRenderer:draw_wall(wall)
	screen_from = IsoRenderer.world_to_screen(wall.from, self.tile_draw_rect)
	screen_to = IsoRenderer.world_to_screen(wall.to, self.tile_draw_rect)
	local height=wall.height

	love.graphics.setColor(wall.color)
	love.graphics.polygon(debug.draw_mode, {
		screen_from.x, screen_from.y,
		screen_to.x, screen_to.y,
		screen_to.x, screen_to.y - (height*self.tile_side_length),
		screen_from.x, screen_from.y - (height*self.tile_side_length),
	})

	if (debug.enabled) then
		love.graphics.circle('fill', screen_from.x, screen_from.y, 2)
		love.graphics.setColor(0, 0.6, 0)
		love.graphics.circle('fill', screen_to.x, screen_to.y, 2)

		love.graphics.setColor(1, 1, 1)
		love.graphics.circle('fill', screen_to.x, screen_to.y-7, 10)
		love.graphics.setColor(1,0,0)
		love.graphics.print(debug.cur_draw_counter, screen_to.x, screen_to.y - 15)

		if (debug.draw_ids) then
		love.graphics.setColor(0,0,1)
			love.graphics.print(wall.id, screen_to.x-7, screen_to.y - 15)
		end

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
	for k,tile in pairs(self.tiles) do
		self:draw_tile(tile)
	end

	--self:sort_uprights()

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
		x = coord.x * (tile_draw_rect.width/2) - coord.y * (tile_draw_rect.width/2),
		y = coord.y * (tile_draw_rect.height/2) + coord.x * (tile_draw_rect.height/2)
	}

end

---@param coord Coord
---@param world_params WorldParams
---@return Coord The coordinate in tile space
function IsoRenderer.screen_to_world(coord, world_params)


end

---@return true if the position is in the front of the wall (e.g. should be drawn first in isometric context)
function IsoRenderer:am_i_in_front_of_wall(pos, wall)

	local pos_depth = pos.x + pos.y

	if (wall.from.x + wall.from.y == wall.to.x + wall.to.y) then
		return pos_depth > wall.from.x + wall.from.y
	end

	local norm = get_norm_wall(wall, self.tile_draw_rect)
	local top = norm.top
	local bottom = norm.bottom

	local screen_pos = IsoRenderer.world_to_screen(pos, self.tile_draw_rect)

	--[[
	local sv_pos = Vec2:New(screen_pos.x, screen_pos.y)

	local sv_wall = sv_top - sv_bottom
	sv_wall:Draw(sv_top)
	local pos_to_top = sv_top - sv_pos
	pos_to_top:Draw(sv_top)
	]]

	local top_depth = top.x + top.y
	local bottom_depth = bottom.x + bottom.y

	--print(pos_depth, top_depth, bottom_depth)

	if (pos_depth < top_depth) then return false end
	if (pos_depth > bottom_depth) then return true end

	-- [[ What side am I on? ]]
	local top_as_vec = Vec2:New(top.x, top.y)
	local bottom_as_vec = Vec2:New(bottom.x, bottom.y)
	local pos_as_vec = Vec2:New(pos.x, pos.y)
	local wall_vec = top_as_vec - bottom_as_vec
	local wall_to_p_vec = top_as_vec - pos_as_vec

	local angle = wall_vec:AngleBetween(wall_to_p_vec)

	local sv_top = Vec2:New(IsoRenderer.world_to_screen(top, self.tile_draw_rect))
	local sv_bottom = Vec2:New(IsoRenderer.world_to_screen(bottom, self.tile_draw_rect))

	if (sv_bottom.x > sv_top.x) then
		return angle > 0
	end

	if (sv_bottom.y > sv_top.y) then
		return angle < 0
	end

	return angle > 0

end

--- Creates a dependency graph. Each node points at nodes it must be drawn before. Essentially if you draw X, you're then safe to visit another node off of X and draw it
function IsoRenderer:construct_dependency_graph(world_data)
	local graph = {}

	--- Functions of type to type. Functions return true if outer type must be rendered BEFORE obj of inner type
	--- E.g. billboard.wall returns true if billboard should be rendered first
	local dependency_checks = {
		billboard = {
			billboard = function (b, b2) return b.pos.x + b.pos.y < b2.pos.x + b2.pos.y end,
			wall = function (b, w) return self:am_i_in_front_of_wall(b.pos, w) == false end
		},
		wall = {
			billboard = function (w, b) return self:am_i_in_front_of_wall(b.pos, w) end,
			wall = function(w, w2) 
				--[[

				-- If two walls are on the same spot, just favour the leftmost one
				if (Vec2:New(norm_w.top) == Vec2:New(norm_w2.top) or Vec2:New(norm_w.bottom)) then
					print(Vec2:New(norm_w.left), Vec2:New(norm_w2.left))
					local render_first = norm_w.left.y < norm_w2.left.y
					print("Walls are in the same spot: ",w.id, w2.id,render_first)
					--return render_first
					return false
				end

				return self:am_i_in_front_of_wall(norm_w.top, w2) == false 
				]]	

				-- If the walls don't overlap on the screen in any way then it actually does not matter and idgaf
				local norm_w = get_norm_wall(w, self.tile_draw_rect)
				local norm_w2 = get_norm_wall(w2, self.tile_draw_rect)

				local w_aabb = { x=norm_w.screen_left.x, y=norm_w.screen_top.y, width=norm_w.screen_right.x - norm_w.screen_left.x, height=norm_w.screen_bottom.y - norm_w.screen_top.y }
				local w2_aabb = { x=norm_w2.screen_left.x, y=norm_w.screen_top.y, width=norm_w.screen_right.x - norm_w.screen_left.x, height=norm_w.screen_bottom.y - norm_w.screen_top.y }

				local overlap = w_aabb.x < w2_aabb.x + w2_aabb.width and w_aabb.x + w_aabb.width > w2_aabb.x and w_aabb.y < w2_aabb.y + w2_aabb.height and w_aabb.y + w_aabb.height > w2_aabb.y
				
				if (not overlap) then return false end

				return w.from.x + w.from.y + w.to.x + w.to.y < w2.from.x + w2.from.y + w2.to.x + w2.to.y
			end
		}
	}

	-- Harvest uprights from data
	-- TODO: load these into the renderer as needed
	uprights = {}
	for k,entity in pairs(world_data.entities) do 
		table.insert(uprights, entity:GetBillboard())
	end
	for k,wall in pairs(world_data.walls) do 
		table.insert(uprights, wall)
	end

	-- Start blank graph
	for k, upright in pairs(uprights) do
		--print(upright)
		graph[upright.id] = {
			down={},
			up={},
			drawable = upright,
		}
	end

	-- Do the N^2 graph construction
	for k,upright in pairs(uprights) do
		for k2,check in pairs(uprights) do
			if upright.id == check.id then goto continue end

			if (dependency_checks[upright.type][check.type](upright, check)) then
				table.insert(graph[upright.id].down, check.id)
				table.insert(graph[check.id].up, upright.id)
			end

			::continue::
		end
	end

	-- DEBUG: print the graph
	for id,dependencies in pairs(graph) do
		s = "["
		for idx,depId in pairs(dependencies.up) do
			s = s .. depId .. ", "
		end
		s = s.."] "..id..": "
		for idx,depId in pairs(dependencies.down) do
			s = s .. depId .. ", "
		end
		--print(s)
	end

	return graph

	
end

--- Traverse the dependency graph and draw things only after their dependencies have been drawn
function IsoRenderer:draw_from_graph(world_data)
	--print("Draw time")
	local depGraph = self:construct_dependency_graph(world_data)

	local no_deps = {}
	for id,deps in pairs(depGraph) do
		if (#deps.up == 0) then
			table.insert(no_deps, id)
		end
	end

	assert(#no_deps > 0)

	visited = List:New()
	seen = List:New()

	debug.cur_draw_counter = 0
	--print("Draw time!")
	for k,id in ipairs(no_deps) do
		self:draw_from_node(id, depGraph[id], depGraph, visited, seen)
	end

end

function IsoRenderer:draw_from_node(id, deps, graph, visited, seen)

	if (visited:Has(id)) then return end
	if (not seen:Has(id)) then 
		seen:Push(id)
	end

	for k,upId in pairs(deps.up) do
		if (not visited:Has(upId)) then
			--print(visited)
			--print(id.." is requesting draw for dependency "..upId)
			self:draw_from_node(upId,graph[upId],graph, visited,seen)
		else
			--print(id.." is skipping draw request for dependency "..upId.." because we've visited it")
		end
	end

	if (not visited:Has(id)) then
		visited:Push(id)
		--print("Got to draw call for: " .. id .. ", ", graph[id].drawable)
		debug.cur_draw_counter = debug.cur_draw_counter + 1
		self:draw_iso_drawable(graph[id].drawable)
	end

	for k,downId in pairs(deps.down) do
		if (not visited:Has(downId)) then
			--print(id.." Believes it's okay to request draw for "..downId)
			self:draw_from_node(downId,graph[downId],graph,visited,seen)
		end
	end
end

--[[
function IsoRenderer:plain_draw(world_data)
	for id,wall in pairs(world_data.walls) do
		self:draw_wall(wall)
	end

	for id,ent in pairs(world_data.entities) do
		self:draw_billboard(ent:GetBillboard())
	end
end
]]

return IsoRenderer
