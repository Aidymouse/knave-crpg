local u_Sort = require 'util.sort'
local u_Print = require 'util.print'
local Debug = require 'util.debug'

local WorldAttr = require 'lib.world_attributes'
local l_vec = require 'lib.vec3'

local GameState = require 'obj.game_state'
local o_Cell = require "obj.map_cell"
local o_Actor = require "obj.actor"

local MapTile = require "entity.map_tile"

Draw_Engine = {
    tile_images = {},
    drawn_objects = {},

    main_canvas = love.graphics.newCanvas(love.graphics.getWidth(), love.graphics.getHeight()),

    float_timer = 0
}


function Draw_Engine.resize(new_width, new_height)
    Draw_Engine.main_canvas = love.graphics.newCanvas(new_width, new_height)
end

function Draw_Engine.get_tile_from_gid(gid)
    return Draw_Engine.tiles[gid]
end

local function util_get_cell_by_map_coord(row, col)
    for _, cell in ipairs(Draw_Engine.cells) do
        if cell.pos.x == col and cell.pos.y == row then return cell end
    end
end

function Draw_Engine.load_map(map)
    

    for _, tile_image in ipairs(map.tile_images) do
        Draw_Engine.tile_images[tile_image.gid] = love.graphics.newImage(tile_image.filename)
    end

    -- Turn cells into tiles
    for _, cell in ipairs(map.cells) do

        if cell.floor_gid ~= 0 then
            local new_floor_tile = MapTile:New(l_vec.vec3(cell.x, cell.y, cell.z), "floor", cell.floor_gid)
            table.insert(GameState.world_entities, new_floor_tile)
        end
        
        if cell.wall_NS_gid ~= 0 then
            local new_NS_tile = MapTile:New(l_vec.vec3(cell.x, cell.y, cell.z+1), "wall_NS", cell.wall_NS_gid)
            table.insert(GameState.world_entities, new_NS_tile)
        end

        if cell.wall_EW_gid ~= 0 then
            local new_EW_tile = MapTile:New(l_vec.vec3(cell.x, cell.y, cell.z+1), "wall_EW", cell.wall_EW_gid)
            table.insert(GameState.world_entities, new_EW_tile)
        end


        --local new_map_tile = MapTile:New(l_vec.vec3(drawn_obj.x, drawn_obj.y, drawn_obj.z), drawn_obj.tile_type, drawn_obj.gid)
        --table.insert(Draw_Engine.drawn_objects, )
        --table.insert(GameState.world_entities, new_map_tile)
    end


end

-- For some reason the __lt isnt being passed through to map tiles so I guess this will have to do
function Draw_Engine.draw_world()

    -- TODO: Uncouple drawing point and distance detection point
    -- TODO: Determine rendering order by corner furthest from origin
    
    love.graphics.setCanvas(Draw_Engine.main_canvas)
    love.graphics.clear()
    
    love.graphics.push()
    love.graphics.translate(WorldAttr.offset_x, WorldAttr.offset_y)
    love.graphics.scale(WorldAttr.scale, WorldAttr.scale)
    --love.graphics.translate(-128, 0)
    
    table.sort(GameState.world_entities)

    for _, world_entity in ipairs(GameState.world_entities) do

        if world_entity.entity_type == "map_tile" then
            
            local screen_pos = WorldAttr.world_to_screen(world_entity.pos + world_entity.offset)
            
            love.graphics.setColor(1, 1, 1)
            if world_entity.tile_type == "floor" then
                love.graphics.draw(Draw_Engine.tile_images[world_entity.gid], screen_pos.x-128, screen_pos.y)
                
            elseif world_entity.tile_type == "wall_NS" then
                -- ANchor point bottom right of wall segment
                love.graphics.draw(Draw_Engine.tile_images[world_entity.gid], screen_pos.x-128, screen_pos.y)
                
            elseif world_entity.tile_type == "wall_EW" then
                -- Anchor point bottom left of wall segment
                love.graphics.draw(Draw_Engine.tile_images[world_entity.gid], screen_pos.x, screen_pos.y)
            end
            
            if Debug.debug_mode and Debug.draw_tile_origin_point then
                love.graphics.setColor(1, 0, 0)
                love.graphics.circle("fill", screen_pos.x, screen_pos.y, 2)
            end
        end

    end
    
    love.graphics.pop()
    love.graphics.setCanvas()
    
    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(Draw_Engine.main_canvas, 0, 0)

end

function Draw_Engine.update(dt)

    --[[ Update water bobbing ]]
    if not Debug.pause_water_bobbing then
        Draw_Engine.float_timer = Draw_Engine.float_timer + 0.01

        for i, entity in ipairs(GameState.world_entities) do

            --if getmetatable(entity) ~= o_Cell then goto continue end

            --[[ Draw_Engine.tiles[cell.tile_gid].type == "water" then
                cell.offset.z = math.cos(Draw_Engine.float_timer + cell.pos.x/3 + cell.pos.y/3) /8 - 0.4
                cell:update_z_order()
            endif

            if entity.tile_type == "floor" then
                entity.offset.z = (math.cos(Draw_Engine.float_timer + entity.pos.x/3 + entity.pos.y/3)) --/ 2
                entity:update_z_order()
            end
            ]]

            --::continue::
        end
    end

end

function Draw_Engine.draw()

    Draw_Engine.draw_world()

    love.graphics.setColor(1, 0, 0)
    love.graphics.print(WorldAttr.offset_x..", "..WorldAttr.offset_y, 10, 26)
    love.graphics.setColor(1, 1, 1)

end

function Draw_Engine.render_tile()
end

function Draw_Engine:load_tilesets()

end

return Draw_Engine