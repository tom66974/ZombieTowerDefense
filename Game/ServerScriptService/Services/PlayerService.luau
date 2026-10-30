local PlayerService = {}


-- Services
local ServerScriptService = game:GetService("ServerScriptService")
local Players = game:GetService("Players")


-- Modules
local Player = require(ServerScriptService.Classes.Player)


-- State
PlayerService.Difficulty = nil


-- Functions
local function onPlayerAdded(player: Player)
	
	local joinData = player:GetJoinData()
	local teleportData = joinData.TeleportData
	
	if teleportData then
		print("Mode:", teleportData.Mode)
		print("Difficulty:", teleportData.Difficulty)
		
		if teleportData.Difficulty then
			PlayerService.Difficulty = teleportData.Difficulty
		end
	end
	
end


function PlayerService:GetDifficulty(): string?
	
	return PlayerService.Difficulty
	
end


function PlayerService:Init()
	
	Players.PlayerAdded:Connect(onPlayerAdded)
	
	for _, player in ipairs(Players:GetPlayers()) do
		onPlayerAdded(player)
	end
	
end


return PlayerService
