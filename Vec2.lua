local Vec2 = { }

function Vec2:New(x, y)
	local o = {
		x = x or 0,
		y = y or 0
	}

	setmetatable(o, self)
	self.__index = self
	return o
end

function Vec2:Cross(other)
	return self.x*other.x + self.y*other.y
end


function Vec2:Mag()
	return math.sqrt(self.x * self.x + self.y * self.y)
end

function Vec2.AngleBetween(vec, other)
	return math.acos(Vec2.Cross(vec, other) / (Vec2.Mag(vec) * Vec2.Mag(other)))
	
end

Vec2.__sub = function(a, b)
	return Vec2:New(b.x-a.x, b.y-a.y)
end

Vec2.__add = function(a, b)
	return Vec2:New(b.x+a.x, b.y+a.y)
end

Vec2.__tostring = function(v)
		return "("..v.x..", "..v.y..")"
	end

return Vec2
