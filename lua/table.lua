tableToStr =0
dictToStr = 0

isDict = function(tbl)
	return #tbl == 0
end

tableToStr = function(tbl)
	local str = "["
	local notFirst = false
	for i, v in ipairs(tbl) do
		if notFirst then
			str = str .. ', '
		end

		if type(v) == "table" then
			if isDict(v) then
				str = str .. dictToStr(v)
			else
				str = str .. tableToStr(v)
			end
		else
			str = str .. v
		end
		notFirst = true
	end
	return str .. "]"
end


dictToStr = function(dict)
	local str = "{"
	local first = true
	
	for k, v in pairs(dict) do
		if not first then
			str = str .. ', '
		end
		if type(v) == "table" then
			if isDict(v) then
				str = str .. k .. ": " .. dictToStr(v)
			else
				str = str .. k .. ": " .. tableToStr(v)
			end
		else
			str = str .. k .. ": " .. v
		end

		first = false
	end
	return str .. "}"
end

local function printTable(tbl)
	for i, v in ipairs(tbl) do
		print(i .. " : " .. v)
	end
end

local function printDict(dict)
	for k, v in pairs(dict) do

		if type(v) == "table" then
			if #v == 0 then
				print(k .. " : " .. dictToStr(v))
			else
				print(k .. " : " .. tableToStr(v))
			end
		else
			print(k .. " : " .. v)
		end
		
	end
end

return str

