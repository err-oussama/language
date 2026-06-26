local function User(Name, Age)
	local name = Name
	local age = Age
	return {
		setName = function(self, Name)
			if Name == nil then
				print("Name cannot be: nil")
			else
				name = Name
			end
		end,
		setAge = function(self, Age)
			if Age < 1 then
				print("Age cannot be leas then: 1")
			else
				age = Age
			end
		end,
		getName = function()
			return name
		end,
		getAge = function()
			return age
		end
	}
end



user =  User("user", 19)
user1 =  User("user1", 190)

print((user["setName"]))
print((user1["setName"]))
user1.setName(user, "Jake")

print(user.getAge(user))
print(user.getName(user))
print("+++++++++++++++++++++++")
print(user1.getAge())
print(user1.getName())

