local List = {}

function List:New()
	local o = {
		items={}
	}
	setmetatable(o, self)
	-- TODO: im sure theres something fancy I could do with __index
	self.__index = self
	return o
end

--- Pushes items onto the list
function List:Push(item)
	table.insert(self.items, item)
end

function List:Pop()
	return table.remove(self.items)
end

--- Get item at index, with -index support
function List:At(idx)
	local i = idx
	if idx < 0 then
		i = #self.items+1 + idx
	end

	if i < 1 then return nil end
	if i > #self.items then return nil end

	return self.items[i]
end

function List:Length() return #self.items end

--- Removes item (with eq check) from the list.
function List:Remove(item)
	for k,v in ipairs(self.items) do
		if v == item then 
			table.remove(self.items, k)
			return
		end
	end
end

---JS find
---@return the found value + the index + a bool for if the value was found (in case the value *is* nil)
function List:Find(predicate)
	for k,v in ipairs(self.items) do
		if predicate(v) then
			return v,k,true
		end
	end
	return nil,nil,false
end

--- Quick checker fn
function List:Has(value)
	local v,k,had = self:Find(function(v) return v == value end)
	return had
end

return List
