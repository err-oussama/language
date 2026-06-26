local tableToStr, dictToStr

tableToStr = function(tbl)
	local str = "["
	local notFirst = false
	for i, v in ipairs(tbl) do
		if notFirst then
			str = str .. ', '
		end

		if type(v) == "table" then
			if #v == 0 then
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


local function createNoiseTracker(startNoise)
	local currentNoise = startNoise
	return {
		makeNoise = function(amount)
			if amount < 0 then
				print("Cannot reduce noise this way!")
			else
				currentNoise = currentNoise + amount
			end
		end,
		getNoise = function()
			return currentNoise
		end,
		logStatus = function(...)
			local args = {...}
			print("STATUS: Noise is " .. currentNoise .. " " .. table.concat(args, ", "))
		end
	}
end


f1 = createNoiseTracker(0)

f1.makeNoise(50)
f1.makeNoise(-50)
print(f1.currentNoise)
print(f1.getNoise())
f1.logStatus("Guard is nearby", "Holding breath")







