local l_vec = require "lib.vec3"

local o_Entity = require "entity.entity"

local Map_Tile = o_Entity:New()

function Map_Tile:New(pos, tile_type, gid)


    local map_tile = o_Entity:New(pos)

    map_tile.entity_type = "map_tile"

    map_tile.tile_type = tile_type
    map_tile.gid = gid

    setmetatable(map_tile, self)
    self.__index = self

    map_tile:update_z_order()


    return map_tile

end

Map_Tile.__lt = o_Entity.__lt

function Map_Tile:update_z_order()

    if self.tile_type == "floor" then
        -- Bottom point relative to world 0, 0, 0
        local z_pos = self.pos + self.offset
        z_pos.y = z_pos.y + 1
        z_pos.x = z_pos.x + 1
        z_pos.z = 0

        self.z_order = z_pos:length()
        return

    elseif self.tile_type == "wall_NS" then

        -- Top-left
        local z_pos = self.pos + self.offset
        z_pos.y = z_pos.y + 1
        --z_pos.z = z_pos.z - 1
        z_pos.z = 0

        self.z_order = z_pos:length()
        return
    
    elseif self.tile_type == "wall_EW" then

        -- Top-left
        local z_pos = self.pos + self.offset
        z_pos.x = z_pos.x + 1
        --z_pos.z = z_pos.z - 1
        z_pos.z = 0

        self.z_order = z_pos:length()
        return

    end

    self.z_order = (self.pos + self.offset):length()

end

function Map_Tile:p()
    print("P")
end

return Map_Tile