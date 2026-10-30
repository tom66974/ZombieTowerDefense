local PhaseService = {}


-- Services
local Players = game:GetService("Players")
local ServerScriptService = game:GetService("ServerScriptService")


-- Modules
local PlayerService = require(ServerScriptService.Services.PlayerService)
local WaveService = require(ServerScriptService.Services.WaveService)


-- Functions
function PhaseService:Intermission()
	
	for i = 10, 0, -1 do
		print("Intermission:", i)
		task.wait(1)
	end
	
end


function PhaseService:StartGame()
	
	local difficulty = PlayerService:GetDifficulty()
	WaveService:StartWaves(difficulty)

end


function PhaseService:StopGame()
	
	for i = 5, 0, -1 do
		print("End:", i)
		task.wait(1)
	end
	
	print("Game ended!")
	
end


function PhaseService:Init()
	
	self:Intermission()
	self:StartGame()
	self:StopGame()
	
end


return PhaseService
