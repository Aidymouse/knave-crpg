local Collision = {}


function Collision.PointInRect(point, rect)
	return point.x > rect.x and point.x < rect.x + rect.width and point.y > rect.y and point.y < rect.y + rect.height
end

return Collision
