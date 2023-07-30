local l_vec = require 'lib.vec3'

Entity = {
    __call = function(_, pos, obj)

        local e = obj or {}
        e.pos = pos or l_vec.vec3(0, 0, 0)
        e.offset = l_vec.vec3(0, 0, 0)
        e.z_order = 0

        Entity.update_z_order(e)

        return e
    end,
    
    __lt = function(a, b)
        if a.z_order == b.z_order then return a.pos.z < b.pos.z end
        return a.z_order < b.z_order
    end,

    __le = function(a, b)
        if a.z_order == b.z_order then return a.pos.z <= b.pos.z end

        return a.z_order <= b.z_order
    end,

    update_z_order = function(e)
        local z_pos = e.pos + e.offset
        --c.z_order = z_pos.y + z_pos.x + z_pos.z -- Almost!!!
        e.z_order = math.sqrt( (z_pos.y)^2 + (z_pos.x)^2 + ( math.ceil(z_pos.z) )^2)
        
    end


}

setmetatable(Entity, Entity)

return Entity