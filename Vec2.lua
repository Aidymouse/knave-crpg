local Vec2 = { }

function Vec2:New(x, y)
	local o = {
		x = x or 0,
		y = y or 0
	}

	if type(x) == "table" then
		o = x
	end

	assert(type(o.x) == "number", "Vec2 has X that is not a number: "..o.x)
	assert(type(o.y) == "number", "Vec2 has Y that is not a number: "..o.y)

	setmetatable(o, self)
	self.__index = self
	return o
end

function Vec2:Dot(other)
	return self.x*other.x + self.y * other.y
end

function Vec2:Cross(other)
	return self.x*other.y - self.y*other.x
end


function Vec2:Mag()
	return math.sqrt(self.x * self.x + self.y * self.y)
end

--- Always returns the smallest angle between the two vectors, but isn't directional at all...
function Vec2.AngleBetween(vec, other)
	local dot = vec:Dot(other)
	local cross = vec:Cross(other)
	
	return math.acos(dot / (Vec2.Mag(vec) * Vec2.Mag(other))) * (cross < 0 and -1 or 1)
	
end

function Vec2.Draw(vec, offset)
	origin = origin or Vec2:New(0, 0)
	love.graphics.line(offset.x, offset.y, vec.x + offset.x, vec.y + offset.y)
	love.graphics.circle('line', vec.x+offset.x, vec.y+offset.y, 3)
end


Vec2.__sub = function(a, b)
	return Vec2:New(b.x-a.x, b.y-a.y)
end

Vec2.__add = function(a, b)
	return Vec2:New(b.x+a.x, b.y+a.y)
end

Vec2.__mul = function(a, b)
	return Vec2:New(a.x*b, a.y*b)
end

Vec2.__eq = function (a,b)
	return a.x == b.x and a.y == b.y
end

Vec2.__tostring = function(v)
		return "("..v.x..", "..v.y..")"
end

return Vec2
