local l_vec = require 'lib.vec3'

local Entity = {}

function Entity:New(pos, obj)

    local ent = obj or {}

    ent.entity_type = "unnasigned"
    ent.pos = pos or l_vec.vec3(0, 0, 0)
    ent.z_order = 0
    ent.offset = l_vec.vec3(0, 0, 0)

    setmetatable(ent, self)
    self.__index = self

    ent:update_z_order()

    return ent

end

function Entity.__lt(a, b)
    if a.z_order == b.z_order then return math.abs(a.pos.z) < math.abs(b.pos.z) end
    return a.z_order < b.z_order
end

function Entity.__le(a, b)
    if a.z_order == b.z_order then return math.abs(a.pos.z) < math.abs(b.pos.z) end
    return a.z_order < b.z_order
end

function Entity:update_z_order()
    local z_pos = self.pos + self.offset
    --c.z_order = z_pos.y + z_pos.x + z_pos.z -- Almost!!!
    self.z_order = z_pos.x + z_pos.y + z_pos.y --math.sqrt((z_pos.y) ^ 2 + (z_pos.x) ^ 2 + (z_pos.z) ^ 2)
    print(self.z_order)
end

function Entity:b()
    print("B")
end

return Entity