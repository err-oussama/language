-- module in lua is a file that return a table in it end 

local module = {}

function module.add(n1, n2)
	return n1 + n2 
end

module.sub = function(n1, n2)
	return n1 - n2
end


return module
