local version = "0.0.1"

Player = {}
--Player.__index = {
--	test = function(self)
--		print(self)
--	end
--}

Player.__index = function(tab, key)
	print("First argument	: { " .. tostring(tab) .. " }")
	print("Second argument	: { " .. tostring(key) .. " }")
	return "default value"
end


setmetatable(Player, Player)



-- Player.__index = Player

function Player.new(Name)
	local self = { 
		name = Name,
		health = 100,
		mana = 50,
		__index = {
			test = function(self)
				print("__index")
			end
		}
	}
	setmetatable(self, self)
--	setmetatable(self, Player)
	return self
end


function Player.heal(self, amount)
	self.health = self.health + amount
	print(self.name .. " healed for " ..amount ..". Health is now " .. self.health .. ".")
end

--return Player
--
pl = Player.new()

print(Player.one)
print(Player)

--[=[
[self (Bob)] 
   |
   +-- (Missing a key? Go to metatable 'Player')
         |
         V
   [Player Table]
         |
         +-- __index -------> [ Custom Anonymous Table ]
         |                       • test = function() ...
         |
         +-- new = function()    (Lua NEVER looks here for missing keys
         +-- heal = function()    because __index didn't point here!) 
]=]
