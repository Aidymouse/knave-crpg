local l_vec = require 'lib.vec3'
local l_WorldAttr = require 'lib.world_attributes'

local o_Entity = require 'entity.entity'

Map_Cell = {
    __call = function(_, position, tile_gid)

        local pos = position or l_vec.vec3(0, 0, 0)

        local cell = o_Entity(pos, {
            tile_gid = tile_gid
        })

        --local screen_pos = l_WorldAttr.world_to_screen(pos)

        --cell.z_order = screen_pos.y + pos.z*256 -- - screen_pos.x

        setmetatable(cell, Map_Cell)

        cell:update_z_order()

        return cell
    end,


    __tostring = function(t)
        return "("..t.pos.x..", "..t.pos.y..", "..t.pos.z..")" .. ", tile id: " .. t.tile_gid
    end,

    __lt = o_Entity.__lt,
    __le = o_Entity.__le,

    __index = {

        update_z_order = o_Entity.update_z_order,

        move = function(c, add_pos)
            c.pos = c.pos + add_pos
            c:update_z_order()
        end,

        set_pos = function(c, new_pos)
            c.pos = new_pos
            c:update_z_order()
        end,

        set_offset = function(c, new_offset)
            c.offset = new_offset
            c:update_z_order()
        end,

        get_draw_pos = function(c)
            return c.pos + c.offset
        end,

        draw = function(c)
            local draw_pos = l_WorldAttr.world_to_screen( c:get_draw_pos() )

            love.graphics.draw(Draw_Engine.tiles[c.tile_gid].image, draw_pos.x, draw_pos.y)
        end
    }
}

setmetatable(Map_Cell, Map_Cell)

return Map_Cell