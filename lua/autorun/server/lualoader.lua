// yay lua loader]
// created by request
// op

local ll = {}
print("Lua Loader loaded.")
print("Created by Zero The Fallen")
print(debug.getinfo(1).short_src)

if !ll.loaded then
 
ll.loaded = true
print()

// use the root directory. eg if you have an addon like
// addons/qac/lua/autorun/server
// Then put "addons/qac/lua/autorun/"

ll.directories = {"lua/autorun/server/"}
ll.filesLoaded = {}


ll.loadServer = function(lua)
	if !lua then return end
	if table.HasValue(ll.filesLoaded, lua) then return end
	RunStringEx(file.Read(lua, "GAME"), lua)
	print("How it would look: RunStringEx(file.Read(" .. lua .. ", GAME)," .. lua .. "\n")
	table.insert(ll.filesLoaded, lua)
end

ll.loadClient = function(lua)
	if !lua then return end
	if table.HasValue(ll.filesLoaded, lua) then return end
	AddCSLuaFile(lua)
	print("How it would look: AddCSLuaFile(" .. lua .. ")".. "\n")
	table.insert(ll.filesLoaded, lua)
end

ll.loadShared = function(lua)
	ll.loadServer(lua)
	ll.loadClient(lua)
end

ll.loadFiles = function()
	for k, v in pairs(ll.directories) do
		local path = v
		local files, dirs = file.Find(v .. "*", "GAME")
		
		// Shared
		for k , v in pairs(files) do
			ll.loadShared(path .. v)
			//print("Loaded shared file:" .. path.. v.. "\n")
		end
		
		// Servers and Client)
		for k, v in pairs(dirs) do
			if v == "autorun" then
				local _, newdirs = file.Find(path .. "autorun/*", "GAME")
				path = path .. "autorun/"
				//print(path)
				for k, v in pairs(newdirs) do
			
					if v == "client" then
						client_path = path .. "client/" 
						//print("Client path is " .. client_path)
						local current, useless = file.Find(client_path .. "*.lua" , "GAME")
						//print("CLIENT FILES")
						//PrintTable(current)
						//print()
						for k, v in pairs(current) do
							local clientfile = client_path .. v
							ll.loadClient(clientfile) 
						end
					end
					
					if v == "server" then
						serv_path = path .. "server/"
						//print("Server path is " .. serv_path)
						local current, useless = file.Find(serv_path .. "*.lua" , "GAME")
						//print("SERVER FILES")
						//PrintTable(current)
						//print()
						for k, v in pairs(current) do
							local servfile = serv_path .. v
							ll.loadServer(servfile) 
						end
					end 
					
				end
			end
		end
	end
end

ll.loadFiles()

end