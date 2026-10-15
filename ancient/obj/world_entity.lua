local World_Entity = {}

function World_Entity.New(type)
    assert(type ~= nil, "Type of world entity cannot be null!")

    return {
        type = type
    }

end

return World_Entity