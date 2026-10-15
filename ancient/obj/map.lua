local l_Draw_Engine = require 'lib.draw_engine'
local l_vec = require 'lib.vec3'
local l_worldattr = require 'lib.world_attributes'

Map = {
    __call = function(_, filename)
        local map = require(filename)

        return setmetatable(map, Map)
    end,

    __index = {
        get_hovered_pos = function(self, mouse_pos)
            -- Basically shoots a ray diagonal and down, taking advantage of the fact that tiles one up in the diagonal direction
            -- are in the same place on the screen
            
            local world_coords_z0 = l_worldattr.screen_to_world(mouse_pos)
            
            for i=#self.layers, 1, -1 do
                local layer = self.layers[i]
                local tile_offset = layer.properties.z_level

                local tile_test_pos = l_vec.vec3(world_coords_z0.x+tile_offset, world_coords_z0.y+tile_offset, i-1)


                local tile_gid = self:get_tile_gid_from_pos(tile_test_pos)
                if tile_gid and tile_gid ~= 0 then return tile_test_pos end

                
            end

            return nil
        end,

        get_tile_gid_from_pos = function(self, pos)
            local layer = self.layers[pos.z + 1]
            if layer == nil then return nil end

            local tile_x = math.floor(pos.x)
            if tile_x >= layer.width or tile_x < 0 then return nil end
            local tile_y = math.floor(pos.y)
            if tile_y >= layer.height or tile_y < 0 then return nil end


            local tile_index = math.floor(pos.x) + math.floor(pos.y)*layer.width + 1 -- +1 cos arrays are 1 based

            return layer.data[tile_index]
        
        end
    }
}

setmetatable(Map, Map)

return Map