// yay lua loader
// zero the fallen copyright
// op

local ll = {}
print("Lua Loader loaded.")
print("Created by Zero The Fallen")
print()

// use the root directory. eg if you have an addon like
// addons/qac/lua/autorun/server
// Then put "addons/qac/lua/autorun/"

ll.directories = {"lua/autorun/server/"}
ll.filesLoaded = {}

ll.loadServer = function(lua)
	if file.IsDir( lua, "GAME") then return end
	if table.HasValue(ll.filesLoaded, lua) then return end
	RunStringEx(file.Read(lua, "GAME"), lua)
	table.insert(ll.filesLoaded, lua)
end

ll.loadClient = function(lua)
	if file.IsDir( lua, "GAME") then return end
	if table.HasValue(ll.filesLoaded, lua) then return end
	AddCSLuaFile(lua)
	table.insert(ll.filesLoaded, lua)
end

ll.loadShared = function(lua)
	ll.loadServer(lua)
	ll.loadClient(lua)
end

ll.loadFiles = function()
	for k, v in pairs(ll.directories) do
		local path = v
		local curfile = ""
		local files, dirs = file.Find(v .. "*", "GAME")
		
		for k , v in pairs(files) do
			curfile = v
			ll.loadShared(path .. v)
			print("Loaded shared file:" .. path.. v)
		end
		
		for k, v in pairs(dirs) do
			if v == "server" then
				ll.loadServer(path .. v .. "/" .. curfile) 
				print("Loaded Server file:" .. path .. v .. "/" .. curfile)
			end
			if v == "client" then
				ll.loadClient(path .. v .. "/" .. curfile) 
				print("Loaded Client file:" .. path .. v .. "/" .. curfile)
			end
		end
		
	end
end

ll.loadFiles()
PrintTable(ll.filesLoaded)
