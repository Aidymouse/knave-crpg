local u_Sort = require 'util.sort'
local u_Print = require 'util.print'
local u_Debug = require 'util.debug'

local l_WorldAttr = require 'lib.world_attributes'
local l_vec = require 'lib.vec3'

local o_Game_State = require 'obj.game_state'
local o_Cell = require "obj.map_cell"
local o_Actor = require "obj.actor"

-- Change the engine to draw faces...

Draw_Engine_Old = {
    tiles = {},
    cells = {},

    main_canvas = love.graphics.newCanvas(love.graphics.getWidth(), love.graphics.getHeight()),

    float_timer = 0
}

tile = {
    type = "floor",
    pos = l_vec.vec3(0, 0, 0),
    graphic_id = 1
}



function Draw_Engine_Old.resize(new_width, new_height)
    Draw_Engine_Old.main_canvas = love.graphics.newCanvas(new_width, new_height)
end

function Draw_Engine_Old.get_tile_from_gid(gid)
    return Draw_Engine_Old.tiles[gid]
end

local function util_get_cell_by_map_coord(row, col)
    for _, cell in ipairs(Draw_Engine_Old.cells) do
        if cell.pos.x == col and cell.pos.y == row then return cell end
    end
end

function Draw_Engine_Old.load_map(map)
    
    --print(map.tilesets)

    -- Load tilesets
    for _, tileset_info in ipairs(map.tilesets) do
        local tileset = require("maps.tilesets." .. tileset_info.name)
        
        for _, tile in ipairs(tileset.tiles) do
            local tile_gid = tile.id + tileset_info.firstgid
                        
            local image_filename = tile.image:gsub("%.%./", "")

            Draw_Engine_Old.tiles[tile_gid] = {
                id = tile.id + tileset_info.firstgid,
                image = love.graphics.newImage(image_filename),
                properties = tile.properties,
                type = tile.type
            }
        end
    end

    -- Create cells
    for _, layer in ipairs(map.layers) do
        for tile_index_plus_one, tile_gid in ipairs(layer.data) do
            
            if tile_gid == 0 then goto continue end

            local tile_index = tile_index_plus_one - 1
            local tile_col = tile_index % layer.width
            local tile_row = (tile_index - tile_index % layer.width) / layer.width

            --print(tile_col, tile_row, layer.properties.z_level)

            local cell_pos = l_vec.vec3(tile_col, tile_row, layer.properties["z_level"])

            local cell_tile = Draw_Engine_Old.tiles[tile_gid]

            if cell_tile == nil then
                print(tile_gid)
            end

            local new_cell = o_Cell(cell_pos, tile_gid)

            table.insert(Draw_Engine_Old.cells, new_cell)
            table.insert(o_Game_State.world_entities, new_cell)
            
            ::continue::
        end
    end

    table.sort(Draw_Engine_Old.cells)
end

function Draw_Engine_Old.draw_world()
    
    love.graphics.setCanvas(Draw_Engine_Old.main_canvas)
    love.graphics.clear()
    
    love.graphics.push()
    love.graphics.translate(l_WorldAttr.offset_x, l_WorldAttr.offset_y)
    love.graphics.scale(l_WorldAttr.scale, l_WorldAttr.scale)
    love.graphics.translate(-128, 0)
    
    table.sort(o_Game_State.world_entities)

    local tile_red_step
    if u_Debug.debug_mode then
        u_Debug.tile_red = 1
        tile_red_step = 1 / #Draw_Engine_Old.cells
    end
    
    for i, entity in ipairs(o_Game_State.world_entities) do
        --print(cell.tile)
        --if i > u_Debug.tile_count then break end
        if u_Debug.debug_mode then love.graphics.setColor(1, 1-u_Debug.tile_red, 1-u_Debug.tile_red) end
        

        if u_Debug.debug_mode and math.ceil(entity.pos.z) == u_Debug.only_draw_layer then 
            entity:draw()
        elseif not u_Debug.debug_mode then
            entity:draw()
        end
        
        if u_Debug.debug_mode then u_Debug.tile_red = u_Debug.tile_red - tile_red_step end
        
        --love.graphics.draw(cell.tile.image, 0, 0)
    end
    
    love.graphics.pop()
    love.graphics.setCanvas()
    
    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(Draw_Engine_Old.main_canvas, 0, 0)

end

function Draw_Engine_Old.update(dt)

    --[[ Update water bobbing ]]
    if not u_Debug.pause_water_bobbing then
        Draw_Engine_Old.float_timer = Draw_Engine_Old.float_timer + 0.01

        for i, entity in ipairs(o_Game_State.world_entities) do

            if getmetatable(entity) ~= o_Cell then goto continue end

            local cell = entity

            if Draw_Engine_Old.tiles[cell.tile_gid].type == "water" then
                cell.offset.z = math.cos(Draw_Engine_Old.float_timer + cell.pos.x/3 + cell.pos.y/3) /8 - 0.4
                cell:update_z_order()
            end

            ::continue::
        end
    end

end

function Draw_Engine_Old.draw()

    Draw_Engine_Old.draw_world()

    love.graphics.setColor(1, 0, 0)
    love.graphics.print(l_WorldAttr.offset_x..", "..l_WorldAttr.offset_y, 10, 26)
    love.graphics.setColor(1, 1, 1)

end

function Draw_Engine_Old.render_tile()
end

function Draw_Engine_Old:load_tilesets()

end

return Draw_Engine_Old