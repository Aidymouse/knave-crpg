local l_vec = require "lib.vec3"
local l_worldattr = require 'lib.world_attributes'

local o_Entity = require 'entity.entity'

Actor = {
    __call = function(_, pos)
        
        local actor = o_Entity(pos, {
            image = love.graphics.newImage("graphics/tiles OLD/actor.png")
        })

        Actor.update_z_order(actor)

        return setmetatable(actor, Actor)
    end,

    __lt = o_Entity.__lt,
    __le = o_Entity.__le,

    __index = {
        update_z_order = o_Entity.update_z_order,

        update = function(self, dt)
            --print(getmetatable(self))

            local x_mult = 0
            local y_mult = 0

            local dir = l_vec.vec3()

            if love.keyboard.isDown("w") then dir = dir + l_vec.vec3(-1, -1) end
            if love.keyboard.isDown("s") then dir = dir + l_vec.vec3(1, 1) end
            if love.keyboard.isDown("a") then dir = dir + l_vec.vec3(-1, 1) end
            if love.keyboard.isDown("d") then dir = dir + l_vec.vec3(1, -1) end
            
            if dir.x > 0 then dir.x = 1 end
            if dir.x < 0 then dir.x = -1 end
            if dir.y > 0 then dir.y = 1 end
            if dir.y < 0 then dir.y = -1 end

            local dir = dir:normalize()

            if love.keyboard.isDown("q") then dir.z = 1 end
            if love.keyboard.isDown("e") then dir.z = -1 end

            self.pos = self.pos + dir * 1 * dt

            self:update_z_order()

        end,

        draw = function(self, dt)
            local draw_pos = l_worldattr.world_to_screen(self.pos)

            love.graphics.draw(self.image, draw_pos.x, draw_pos.y)
        end
    }
}

setmetatable(Actor, Actor)

return Actor