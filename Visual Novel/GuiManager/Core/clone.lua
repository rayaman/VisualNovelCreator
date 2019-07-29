local copy
function copy(obj, seen)
	if type(obj) ~= 'table' then return obj end
	if seen and seen[obj] then return seen[obj] end
	local s = seen or {}
	local res = setmetatable({}, getmetatable(obj))
	s[obj] = res
	for k, v in pairs(obj) do res[copy(k, s)] = copy(v, s) end
	return res
end
function gui:clone(par,isRef)
	local temp = copy(self)
	temp.isACopy = true
	if par then
		temp:SetParent(par)
	end
	if isRef or self.isRef then
		self.Visible = false
		temp.Visible = true
	end
	return temp
end