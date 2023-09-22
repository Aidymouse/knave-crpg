local l_vec = require 'lib.vec3'

local u_matrix = require 'util.matrix'

-- Cell width and height describe the world as if it were a 2d grid of squares from the top down

local CELL_WIDTH = 256
local CELL_HEIGHT = 256

local World_Attributes = {
    tile_image_size = 256,

    iso = {
        a = 1 * CELL_WIDTH * 0.5,
        b = -1 * CELL_WIDTH * 0.5,
        c = 0.5 * CELL_HEIGHT * 0.5,
        d = 0.5 * CELL_HEIGHT * 0.5
    },

    offset_x = 0,
    offset_y = 0,

    scale = 0.5,

}

function love.mouse.getXYOffset()

    local new = l_vec.vec3(
        (love.mouse.getX() - World_Attributes.offset_x) / World_Attributes.scale,
        (love.mouse.getY() - World_Attributes.offset_y) / World_Attributes.scale
    )

    return new
end

World_Attributes.world_to_screen = function(pos)
    local iso = World_Attributes.iso
    
    return l_vec.vec3(
        pos.x * iso.a + pos.y * iso.b,
        pos.x * iso.c + pos.y * iso.d - pos.z * World_Attributes.tile_image_size/2
    )
end

World_Attributes.screen_to_world = function(posXY)

    -- Only returns the coord on Z level 0. There's a method in map that can get the tile

    local iso = World_Attributes.iso
    local inv = u_matrix.invert_matrix(iso.a, iso.b, iso.c, iso.d)

    return l_vec.vec3(
        posXY.x * inv.a + posXY.y * inv.b,
        posXY.x * inv.c + posXY.y * inv.d
    )


end

return World_Attributes