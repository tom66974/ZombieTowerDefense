local PlayerService = {}


-- Services
local Players = game:GetService("Players")


-- Functions
function PlayerService:Init()
	
	Players.PlayerAdded:Connect(function(player: Player)
		local joinData = player:GetJoinData()
		local teleportData = joinData.TeleportData
		
		if teleportData then
			print("Mode:", teleportData.Mode)
			print("Difficulty:", teleportData.Difficulty)
		end
	end)
	
end


return PlayerService
