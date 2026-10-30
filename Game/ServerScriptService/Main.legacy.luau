-- Services
local ServerScriptService = game:GetService("ServerScriptService")


-- Init (en parallèle pour ne pas bloquer les autres services,
-- car PhaseService:Init contient des boucles d'attente)
for _, serviceModule in ipairs(ServerScriptService.Services:GetChildren()) do
	local service = require(serviceModule)
	if type(service.Init) == "function" then
		task.spawn(function()
			service:Init()
		end)
	end
end